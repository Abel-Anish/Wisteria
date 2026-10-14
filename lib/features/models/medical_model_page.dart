import 'package:flutter/material.dart';

import '../../core/database/database.dart';
import '../../core/database/repositories/medical_model_repository.dart';
import '../../core/models/system_model_catalog.dart';
import '../../core/services/model_registry_service.dart';
import '../../core/theme/wisteria_theme.dart';
import 'model_inference_test_page.dart';

class MedicalModelPage extends StatefulWidget {
  final WisteriaDatabase database;

  const MedicalModelPage({super.key, required this.database});

  @override
  State<MedicalModelPage> createState() => _MedicalModelPageState();
}

class _MedicalModelPageState extends State<MedicalModelPage> {
  late final MedicalModelRepository _repository;
  late Future<List<MedicalModel>> _modelsFuture;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _repository = MedicalModelRepository(widget.database);
    _loadModels();
  }

  void _loadModels() {
    _modelsFuture = _repository.getAllModels();
  }

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    try {
      final registryService = ModelRegistryService(widget.database);
      await registryService.synchronizeCatalog();
      setState(_loadModels);
      await _modelsFuture;
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Medical Model Management'),
        backgroundColor: colors.background,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Rescan and synchronize models',
            onPressed: _isRefreshing ? null : _refresh,
            icon: _isRefreshing
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.primary,
                    ),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: FutureBuilder<List<MedicalModel>>(
            future: _modelsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && !_isRefreshing) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Could not load models: ${snapshot.error}',
                    style: TextStyle(color: colors.textSecondary),
                  ),
                );
              }

              final models = snapshot.data ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Medical Model Management',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Manage available medical AI models and their installed versions.',
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                            border: Border.all(
                              color: colors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            '${models.length} ${models.length == 1 ? 'recognized model' : 'recognized models'}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Model List ──
                  Expanded(
                    child: models.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.memory_rounded,
                                  size: 56,
                                  color: colors.textSecondary,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No medical models registered.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Click refresh to scan the application model catalog.',
                                  style: TextStyle(color: colors.textSecondary),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            itemCount: models.length,
                            itemBuilder: (context, index) {
                              return _ModelCard(
                                model: models[index],
                                repository: _repository,
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ModelCard extends StatefulWidget {
  final MedicalModel model;
  final MedicalModelRepository repository;

  const _ModelCard({
    required this.model,
    required this.repository,
  });

  @override
  State<_ModelCard> createState() => _ModelCardState();
}

class _ModelCardState extends State<_ModelCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catalogModel = SystemModelCatalog.getById(widget.model.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(
          color: _isExpanded ? colors.primary.withValues(alpha: 0.5) : colors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Collapsed Card Header ──
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Icon(
                      Icons.memory_rounded,
                      color: colors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Title & Meta
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.model.name,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.model.task} • ${widget.model.modality} • ${widget.model.runtime}',
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Version & Status Badge
                  FutureBuilder<List<ModelVersion>>(
                    future: widget.repository.getVersionsForModel(widget.model.id),
                    builder: (context, snapshot) {
                      final versions = snapshot.data ?? [];
                      final installedVersion = versions.firstWhere(
                        (v) => v.installationStatus == 'INSTALLED',
                        orElse: () => versions.isNotEmpty
                            ? versions.first
                            : ModelVersion(
                                id: '',
                                modelId: widget.model.id,
                                version: catalogModel?.version ?? '1.0.0',
                                filePath: '',
                                checksum: '',
                                compatibility: null,
                                installationStatus: 'NOT_INSTALLED',
                              ),
                      );

                      final status = installedVersion.installationStatus;
                      final versionStr = installedVersion.version;

                      return Row(
                        children: [
                          Text(
                            'v$versionStr',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildStatusBadge(colors, status),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: 12),

                  // Expand Arrow
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded Content ──
          if (_isExpanded) ...[
            Divider(height: 1, color: colors.border),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (widget.model.description?.isNotEmpty == true) ...[
                    Text(
                      widget.model.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textPrimary.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Metadata Grid
                  Text(
                    'MODEL SPECIFICATIONS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      children: [
                        _specRow(
                          colors,
                          'Architecture',
                          catalogModel?.architecture ?? 'ResNet-18',
                        ),
                        _specRow(
                          colors,
                          'Input Spec',
                          catalogModel?.inputRequirements ??
                              '224x224 RGB / Grayscale Image Tensor',
                        ),
                        _specRow(
                          colors,
                          'Output Classes',
                          catalogModel?.outputClasses.join(', ') ??
                              'NORMAL, PNEUMONIA',
                        ),
                        _specRow(
                          colors,
                          'Asset Path',
                          catalogModel?.assetPath ??
                              'assets/models/pneumonia_resnet18.onnx',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Versions List
                  Text(
                    'INSTALLED VERSIONS & ARTIFACTS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 10),

                  FutureBuilder<List<ModelVersion>>(
                    future: widget.repository.getVersionsForModel(widget.model.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(),
                        );
                      }

                      final versions = snapshot.data ?? [];

                      if (versions.isEmpty) {
                        return Text(
                          'No version artifacts registered.',
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.textSecondary,
                          ),
                        );
                      }

                      return Column(
                        children: versions.map((v) {
                          final isInstalled = v.installationStatus == 'INSTALLED';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colors.background,
                              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                              border: Border.all(color: colors.border),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isInstalled
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_outlined,
                                  size: 18,
                                  color: isInstalled
                                      ? const Color(0xFF10B981)
                                      : Colors.orange,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Version ${v.version} — ${v.filePath}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                      if (v.compatibility != null)
                                        Text(
                                          'Compatibility: ${v.compatibility}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colors.textSecondary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                _buildStatusBadge(colors, v.installationStatus),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Actions
                  FutureBuilder<List<ModelVersion>>(
                    future: widget.repository.getVersionsForModel(widget.model.id),
                    builder: (context, snapshot) {
                      final versions = snapshot.data ?? [];
                      final isInstalled = versions.any(
                        (v) => v.installationStatus == 'INSTALLED',
                      );

                      if (!isInstalled) return const SizedBox.shrink();

                      return Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ModelInferenceTestPage(
                                  modelId: widget.model.id,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded, size: 18),
                          label: const Text('Test Model Inference'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colors.primary,
                            side: BorderSide(color: colors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _specRow(WisteriaColorPalette colors, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(WisteriaColorPalette colors, String status) {
    Color bg;
    Color fg;
    Color border;
    String label;

    switch (status.toUpperCase()) {
      case 'INSTALLED':
        bg = const Color(0xFF10B981).withValues(alpha: 0.12);
        fg = const Color(0xFF10B981);
        border = const Color(0xFF10B981).withValues(alpha: 0.35);
        label = 'Installed';
        break;
      case 'NOT_INSTALLED':
        bg = Colors.orange.withValues(alpha: 0.12);
        fg = Colors.orange.shade700;
        border = Colors.orange.withValues(alpha: 0.35);
        label = 'Not Installed';
        break;
      case 'UNAVAILABLE':
        bg = colors.textSecondary.withValues(alpha: 0.12);
        fg = colors.textSecondary;
        border = colors.textSecondary.withValues(alpha: 0.35);
        label = 'Unavailable';
        break;
      case 'ERROR':
      default:
        bg = Colors.red.withValues(alpha: 0.12);
        fg = Colors.red;
        border = Colors.red.withValues(alpha: 0.35);
        label = 'Error';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
