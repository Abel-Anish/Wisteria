class CatalogModel {
  final String id;
  final String displayName;
  final String description;
  final String task;
  final String modality;
  final String architecture;
  final String runtime;
  final String inputRequirements;
  final List<String> outputClasses;
  final String assetPath;
  final String version;
  final String compatibility;
  final bool isSupported;

  const CatalogModel({
    required this.id,
    required this.displayName,
    required this.description,
    required this.task,
    required this.modality,
    required this.architecture,
    required this.runtime,
    required this.inputRequirements,
    required this.outputClasses,
    required this.assetPath,
    required this.version,
    required this.compatibility,
    this.isSupported = true,
  });
}

class SystemModelCatalog {
  SystemModelCatalog._();

  static const CatalogModel pneumoniaResNet18 = CatalogModel(
    id: 'wisteria-pneumonia-resnet18',
    displayName: 'Pneumonia ResNet18',
    description:
        'Binary classification of chest X-ray images for pneumonia detection. Locally bundled ONNX model.',
    task: 'Pneumonia Classification',
    modality: 'X-Ray',
    architecture: 'ResNet-18',
    runtime: 'ONNX Runtime',
    inputRequirements: '224x224 RGB Image Tensor (NCHW)',
    outputClasses: ['NORMAL', 'PNEUMONIA'],
    assetPath: 'assets/models/pneumonia_resnet18.onnx',
    version: '1.0.0',
    compatibility: 'Wisteria 1.0',
    isSupported: true,
  );

  /// Brain Tumor ResNet18 model.
  ///
  /// Four-class classification of brain MRI images.
  /// Input: [1, 3, 224, 224] float32, RGB, ImageNet normalization.
  /// Output: [1, 4] raw logits. Classes (alphabetical, matching training order):
  ///   0 = glioma, 1 = meningioma, 2 = notumor, 3 = pituitary
  static const CatalogModel brainTumorResNet18 = CatalogModel(
    id: 'wisteria-brain-tumor-resnet18',
    displayName: 'Brain Tumor ResNet18',
    description:
        'Four-class brain tumor classification from MRI images. '
        'Classes: Glioma, Meningioma, No Tumor, Pituitary. Locally bundled ONNX model.',
    task: 'Brain Tumor Classification',
    modality: 'MRI',
    architecture: 'ResNet-18',
    runtime: 'ONNX Runtime',
    inputRequirements: '224x224 RGB MRI Image Tensor (NCHW)',
    outputClasses: ['glioma', 'meningioma', 'notumor', 'pituitary'],
    assetPath: 'assets/models/brain_tumor_resnet18.onnx',
    version: '1.0.0',
    compatibility: 'Wisteria 1.0',
    isSupported: true,
  );

  /// Predefined catalog of authoritative medical AI models supported by Wisteria.
  static List<CatalogModel> get allModels => [
        pneumoniaResNet18,
        brainTumorResNet18,
      ];

  static CatalogModel? getById(String id) {
    for (final model in allModels) {
      if (model.id == id) return model;
    }
    return null;
  }
}
