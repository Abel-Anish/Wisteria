import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../core/theme/wisteria_theme.dart';
import '../shared/wisteria_back_button.dart';

/// Native in-app PDF viewer page for WISTERIA (Windows desktop).
///
/// Renders local PDF files using pdfrx (backed by PDFium native library).
/// Supports page navigation, zoom in/out, fit-to-page, and error handling.
/// All rendering is offline — no external viewer or browser is launched.
class DoctorDocumentViewerPage extends StatefulWidget {
  final String documentPath;
  final String documentName;

  const DoctorDocumentViewerPage({
    super.key,
    required this.documentPath,
    required this.documentName,
  });

  @override
  State<DoctorDocumentViewerPage> createState() =>
      _DoctorDocumentViewerPageState();
}

class _DoctorDocumentViewerPageState extends State<DoctorDocumentViewerPage> {
  /// Controls the embedded PdfViewer widget.
  /// PdfViewerController extends `ValueListenable<Matrix4>` — it is NOT a
  /// ChangeNotifier, so we listen via addListener / removeListener.
  final PdfViewerController _pdfController = PdfViewerController();

  bool _fileExists = true;
  bool _isCheckingFile = true;

  @override
  void initState() {
    super.initState();
    _pdfController.addListener(_onControllerChanged);
    _verifyFileExists();
  }

  @override
  void dispose() {
    _pdfController.removeListener(_onControllerChanged);
    // PdfViewerController has no dispose() method in pdfrx 2.4.8.
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _verifyFileExists() async {
    final exists = await File(widget.documentPath).exists();
    if (!mounted) return;
    setState(() {
      _fileExists = exists;
      _isCheckingFile = false;
    });
  }

  // ── Page navigation helpers ──────────────────────────────────────────────

  /// Safe current page number (1-based). Returns 1 while document is loading.
  int get _currentPage =>
      _pdfController.isReady ? (_pdfController.pageNumber ?? 1) : 1;

  /// Total page count. Returns 0 while document is loading.
  int get _totalPages => _pdfController.isReady ? _pdfController.pageCount : 0;

  void _goToPreviousPage() {
    if (!_pdfController.isReady) return;
    final target = _currentPage - 1;
    if (target >= 1) {
      _pdfController.goToPage(pageNumber: target);
    }
  }

  void _goToNextPage() {
    if (!_pdfController.isReady) return;
    final target = _currentPage + 1;
    if (target <= _totalPages) {
      _pdfController.goToPage(pageNumber: target);
    }
  }

  // ── Zoom helpers ─────────────────────────────────────────────────────────

  void _zoomIn() {
    if (!_pdfController.isReady) return;
    _pdfController.zoomUp();
  }

  void _zoomOut() {
    if (!_pdfController.isReady) return;
    _pdfController.zoomDown();
  }

  /// Fit current page to the viewport width using pdfrx's built-in
  /// `alternativeFitScale` (fit-to-page) or `coverScale` as fallback.
  void _fitToPage() {
    if (!_pdfController.isReady) return;
    final fitScale =
        _pdfController.alternativeFitScale ?? _pdfController.coverScale;
    final center = _pdfController.centerPosition;
    _pdfController.setZoom(center, fitScale);
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(colors),
            Expanded(child: _buildBody(colors)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(WisteriaColorPalette colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          // Back navigation
          WisteriaBackButton(
            label: 'Back to Profile',
            onTap: () => Navigator.of(context).pop(),
          ),

          const SizedBox(width: 20),

          // Document title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.documentName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    letterSpacing: -0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.picture_as_pdf_rounded,
                      size: 12,
                      color: const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'PDF Document',
                      style: TextStyle(fontSize: 11, color: colors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Controls (only shown when document is ready)
          _buildControls(colors),
        ],
      ),
    );
  }

  Widget _buildControls(WisteriaColorPalette colors) {
    final bool ready = _pdfController.isReady;
    final int page = _currentPage;
    final int total = _totalPages;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Page Navigation ──
        _ControlButton(
          icon: Icons.chevron_left_rounded,
          tooltip: 'Previous page',
          enabled: ready && page > 1,
          onTap: _goToPreviousPage,
          colors: colors,
        ),

        // Page indicator
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: colors.surfaceLowest,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Text(
            ready ? '$page / $total' : '— / —',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),

        _ControlButton(
          icon: Icons.chevron_right_rounded,
          tooltip: 'Next page',
          enabled: ready && page < total,
          onTap: _goToNextPage,
          colors: colors,
        ),

        const SizedBox(width: 12),
        _buildDivider(colors),
        const SizedBox(width: 12),

        // ── Zoom Controls ──
        _ControlButton(
          icon: Icons.remove_rounded,
          tooltip: 'Zoom out',
          enabled: ready,
          onTap: _zoomOut,
          colors: colors,
        ),
        _ControlButton(
          icon: Icons.add_rounded,
          tooltip: 'Zoom in',
          enabled: ready,
          onTap: _zoomIn,
          colors: colors,
        ),
        _ControlButton(
          icon: Icons.fit_screen_rounded,
          tooltip: 'Fit to page',
          enabled: ready,
          onTap: _fitToPage,
          colors: colors,
        ),
      ],
    );
  }

  Widget _buildDivider(WisteriaColorPalette colors) {
    return Container(width: 1, height: 22, color: colors.border);
  }

  Widget _buildBody(WisteriaColorPalette colors) {
    if (_isCheckingFile) {
      return Center(child: CircularProgressIndicator(color: colors.primary));
    }

    if (!_fileExists) {
      return _buildErrorState(
        colors,
        icon: Icons.file_present_rounded,
        title: 'Document Not Found',
        message:
            'The PDF file could not be located on disk.\n\n'
            'Path: ${widget.documentPath}',
      );
    }

    return Container(
      color: const Color(0xFF2A2A2A), // neutral dark canvas for PDF pages
      child: PdfViewer.file(
        widget.documentPath,
        controller: _pdfController,
        params: PdfViewerParams(
          backgroundColor: const Color(0xFF2A2A2A),
          loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
            final palette = WisteriaColors.of(context);
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: palette.primary),
                  const SizedBox(height: 16),
                  Text(
                    totalBytes != null
                        ? 'Loading PDF… ${(bytesDownloaded / totalBytes * 100).toStringAsFixed(0)}%'
                        : 'Loading PDF…',
                    style: TextStyle(
                      fontSize: 13,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(
    WisteriaColorPalette colors, {
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: colors.surfaceLow,
          borderRadius: BorderRadius.zero,
          border: Border.all(color: colors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: WisteriaColors.error.withValues(alpha: 0.10),
                borderRadius: BorderRadius.zero,
              ),
              child: Icon(icon, size: 28, color: WisteriaColors.error),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Back to Profile'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.primary,
                side: BorderSide(color: colors.primary.withValues(alpha: 0.4)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Small reusable icon button ───────────────────────────────────────────────

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.tooltip,
    required this.enabled,
    required this.onTap,
    required this.colors,
  });

  final IconData icon;
  final String tooltip;
  final bool enabled;
  final VoidCallback onTap;
  final WisteriaColorPalette colors;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.zero,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 18,
              color: enabled ? colors.textPrimary : colors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
