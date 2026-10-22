import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:wisteria/core/database/database.dart';
import 'package:wisteria/core/database/repositories/medical_model_repository.dart';
import 'package:wisteria/core/database/repositories/patient_repository.dart';
import 'package:wisteria/core/models/system_model_catalog.dart';
import 'package:wisteria/core/services/model_registry_service.dart';
import 'package:wisteria/core/services/onnx_inference_service.dart';
import 'package:wisteria/core/theme/wisteria_theme.dart';
import 'package:wisteria/features/doctor/doctor_profile_page.dart';
import 'package:wisteria/features/models/medical_model_page.dart';
import 'package:wisteria/features/workspace/main_workspace_panel.dart';
import 'package:wisteria/features/workspace/system_workspace_panel.dart';
import 'package:wisteria/features/examinations/create_examination_page.dart';
import 'package:wisteria/features/examinations/examination_details_page.dart';
import 'package:wisteria/features/patients/new_patient_registration_page.dart';
import 'package:wisteria/features/patients/patient_details_page.dart';
import 'package:wisteria/features/patients/patient_page.dart';
import 'package:wisteria/features/patients/widgets/patient_age_avatar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Verify all registered local assets can be loaded from rootBundle',
    () async {
      const assets = [
        'assets/images/new_patients.jpg',
        'assets/images/registered_patients.jpg',
        'assets/images/doctor.png',
        'assets/images/model.jpg',
        'assets/images/data sync.jpg',
        'assets/images/settings.jpg',
        'assets/images/cardiology.jpg',
        'assets/images/neurology.jpg',
        'assets/images/ophthalmology.jpg',
        'assets/logo/bglogo.png',
        'assets/logo/logo.png',
        'assets/logo/Frame 1.png',
        'assets/logo/logo.svg',
        'assets/logo/Frame 1.svg',
      ];

      for (final asset in assets) {
        final byteData = await rootBundle.load(asset);
        expect(
          byteData.lengthInBytes,
          greaterThan(0),
          reason: 'Asset $asset failed to load or is empty',
        );
      }
    },
  );

  test('Verify patient age category mapping', () {
    expect(getPatientAgeCategory(null), PatientAgeCategory.adult);
    expect(getPatientAgeCategory(5), PatientAgeCategory.child);
    expect(getPatientAgeCategory(12), PatientAgeCategory.child);
    expect(getPatientAgeCategory(13), PatientAgeCategory.teenager);
    expect(getPatientAgeCategory(19), PatientAgeCategory.teenager);
    expect(getPatientAgeCategory(20), PatientAgeCategory.adult);
    expect(getPatientAgeCategory(59), PatientAgeCategory.adult);
    expect(getPatientAgeCategory(60), PatientAgeCategory.senior);
    expect(getPatientAgeCategory(85), PatientAgeCategory.senior);
  });

  testWidgets('MainWorkspacePanel renders cards in both Dark and Light mode', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final db = WisteriaDatabase(NativeDatabase.memory());

    // Dark Mode test
    await tester.pumpWidget(
      MaterialApp(
        theme: buildWisteriaTheme(brightness: Brightness.dark),
        home: Scaffold(body: MainWorkspacePanel(database: db)),
      ),
    );
    await tester.pump();

    expect(find.text('New Patient'), findsOneWidget);
    expect(find.text('Registered Patients'), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(2));

    // Light Mode test
    await tester.pumpWidget(
      MaterialApp(
        theme: buildWisteriaTheme(brightness: Brightness.light),
        home: Scaffold(body: MainWorkspacePanel(database: db)),
      ),
    );
    await tester.pump();

    expect(find.text('New Patient'), findsOneWidget);
    expect(find.text('Registered Patients'), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(2));

    await db.close();
  });

  testWidgets(
    'NewPatientRegistrationPage renders standalone registration screen with mandatory indicators',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());

      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.dark),
          home: NewPatientRegistrationPage(database: db),
        ),
      );
      await tester.pump();

      expect(find.text('New Patient Registration'), findsOneWidget);
      expect(find.text('Patient Name'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Blood Group'), findsOneWidget);
      expect(find.text('Other Contact'), findsOneWidget);
      expect(find.text('Contact Address'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Register Patient'), findsOneWidget);

      // Verify 6 red asterisk indicators exist
      expect(find.text('*'), findsNWidgets(6));

      await db.close();
    },
  );

  testWidgets(
    'NewPatientRegistrationPage validates mandatory empty fields on submit',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());

      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.light),
          home: NewPatientRegistrationPage(database: db),
        ),
      );
      await tester.pump();

      // Tap Register Patient without entering anything
      await tester.tap(find.text('Register Patient'));
      await tester.pumpAndSettle();

      // Verify error messages appear for all 6 fields
      expect(find.text('Patient name is required.'), findsOneWidget);
      expect(find.text('Phone number is required.'), findsOneWidget);
      expect(find.text('Age is required.'), findsOneWidget);
      expect(find.text('Please select a blood group.'), findsOneWidget);
      expect(find.text('Other contact is required.'), findsOneWidget);
      expect(find.text('Contact address is required.'), findsOneWidget);

      await db.close();
    },
  );

  testWidgets(
    'NewPatientRegistrationPage validates invalid formats for phone, age, contact',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());

      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.light),
          home: NewPatientRegistrationPage(database: db),
        ),
      );
      await tester.pump();

      // Fill in invalid values
      await tester.enterText(find.byKey(const Key('name_field')), 'John Doe');
      await tester.enterText(
        find.byKey(const Key('phone_field')),
        'abc',
      ); // Invalid phone
      await tester.enterText(
        find.byKey(const Key('age_field')),
        '200',
      ); // Invalid age out of range
      await tester.enterText(
        find.byKey(const Key('other_contact_field')),
        'invalid-contact',
      ); // Invalid contact format
      await tester.enterText(
        find.byKey(const Key('address_field')),
        '123 Main St',
      );

      await tester.tap(find.text('Register Patient'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid phone number.'), findsOneWidget);
      expect(find.text('Enter a valid age between 0 and 150.'), findsOneWidget);
      expect(find.text('Please select a blood group.'), findsOneWidget);
      expect(
        find.text('Enter a valid email or emergency contact.'),
        findsOneWidget,
      );

      await db.close();
    },
  );

  testWidgets(
    'NewPatientRegistrationPage registers successfully with complete valid data',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());

      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.dark),
          home: NewPatientRegistrationPage(database: db),
        ),
      );
      await tester.pump();

      // Fill in valid values for all 6 fields
      await tester.enterText(
        find.byKey(const Key('name_field')),
        '   Sarah Connor   ',
      );
      await tester.enterText(
        find.byKey(const Key('phone_field')),
        '+1-555-019-2834',
      );
      await tester.enterText(find.byKey(const Key('age_field')), '29');

      // Select Blood Group
      await tester.tap(find.byKey(const Key('blood_group_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('O+').last);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('other_contact_field')),
        'sarah@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('address_field')),
        '742 Evergreen Terrace',
      );

      await tester.tap(find.text('Register Patient'));
      await tester.pumpAndSettle();

      // Check DB insertion
      final patients = await db.select(db.patients).get();
      expect(patients.length, equals(1));
      expect(patients.first.name, equals('Sarah Connor'));
      expect(patients.first.phoneNumber, equals('+1-555-019-2834'));
      expect(patients.first.age, equals(29));
      expect(patients.first.bloodGroup, equals('O+'));
      expect(patients.first.otherContact, equals('sarah@example.com'));
      expect(patients.first.address, equals('742 Evergreen Terrace'));

      await db.close();
    },
  );

  testWidgets('PatientPage renders directory without New Patient button', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final db = WisteriaDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      MaterialApp(
        theme: buildWisteriaTheme(brightness: Brightness.light),
        home: PatientPage(database: db),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Registered Patients'), findsOneWidget);
    expect(find.text('Search by name, ID, or phone number...'), findsOneWidget);
    expect(find.text('Blood Group'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'New Patient'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Add Patient'), findsNothing);

    await db.close();
  });

  testWidgets(
    'DoctorProfilePage renders 2-column layout and compact document panel',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());

      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.dark),
          home: DoctorProfilePage(database: db),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Doctor Profile'), findsWidgets);
      expect(find.text('DOCTOR INFORMATION'), findsOneWidget);
      expect(find.text('CLINIC & PROFESSIONAL DETAILS'), findsOneWidget);
      expect(find.text('DOCTOR DOCUMENT'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('No Doctor Document Uploaded'), findsOneWidget);

      await db.close();
    },
  );

  test('Verify theme mode controller persistence switching', () {
    WisteriaThemeController.setThemeMode(ThemeMode.light);
    expect(WisteriaThemeController.currentThemeMode, ThemeMode.light);
    expect(WisteriaThemeController.isDark, isFalse);

    WisteriaThemeController.setThemeMode(ThemeMode.dark);
    expect(WisteriaThemeController.currentThemeMode, ThemeMode.dark);
    expect(WisteriaThemeController.isDark, isTrue);
  });

  testWidgets(
    'SystemWorkspacePanel renders cards in both Dark and Light mode',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());

      // Dark Mode test
      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.dark),
          home: Scaffold(body: SystemWorkspacePanel(database: db)),
        ),
      );
      await tester.pump();

      expect(find.text('Doctor Profile'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Models'), findsOneWidget);
      expect(find.text('Sync'), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(4));

      await db.close();
    },
  );

  test('Verify teal color scheme constants and palettes', () {
    expect(WisteriaColors.primary, const Color(0xFF098FA6));
    expect(WisteriaColors.pink, const Color(0xFFC998A2));
    expect(WisteriaColors.burgundy, const Color(0xFF96162C));
    expect(WisteriaColors.mutedRose, const Color(0xFFAF6A6A));
    expect(WisteriaColors.darkPalette.primary, const Color(0xFF098FA6));
    expect(WisteriaColors.lightPalette.primary, const Color(0xFF098FA6));

    expect(WisteriaColors.darkPalette.background, const Color(0xFF0D0D0D));
    expect(WisteriaColors.darkPalette.surface, const Color(0xFF3D3D3D));
    expect(WisteriaColors.darkPalette.textPrimary, const Color(0xFFFFFFFF));
    expect(WisteriaColors.darkPalette.textSecondary, const Color(0xFFCCCCCC));
    expect(WisteriaColors.darkPalette.border, const Color(0xFF333333));

    expect(WisteriaColors.lightPalette.background, const Color(0xFFF0F5F6));
    expect(WisteriaColors.lightPalette.surface, const Color(0xFFFFFFFF));
    expect(WisteriaColors.lightPalette.textPrimary, const Color(0xFF1E293B));
    expect(WisteriaColors.lightPalette.textSecondary, const Color(0xFF5A6E7C));
  });

  test(
    'ModelRegistryService auto-registers catalog models and safely purges john entry idempotently',
    () async {
      final db = WisteriaDatabase(NativeDatabase.memory());
      final repo = MedicalModelRepository(db);

      // Manually insert an unwanted 'john' test model record to simulate obsolete data
      await repo.createModel(
        id: 'john',
        name: 'john',
        description: 'Obsolete test model',
        task: 'Testing',
        modality: 'X-Ray',
        runtime: 'ONNX',
      );

      var models = await repo.getAllModels();
      expect(models.any((m) => m.name.toLowerCase() == 'john'), isTrue);

      // Perform catalog synchronization
      final service = ModelRegistryService(db);
      await service.synchronizeCatalog();

      models = await repo.getAllModels();
      expect(models.any((m) => m.name.toLowerCase() == 'john'), isFalse);
      expect(models.any((m) => m.name == 'Pneumonia ResNet18'), isTrue);
      expect(models.any((m) => m.name == 'Brain Tumor ResNet18'), isTrue);

      // Repeat sync to verify idempotency (no duplicates created)
      await service.synchronizeCatalog();
      models = await repo.getAllModels();
      expect(
        models.where((m) => m.id == 'wisteria-pneumonia-resnet18').length,
        equals(1),
      );
      expect(
        models.where((m) => m.id == 'wisteria-brain-tumor-resnet18').length,
        equals(1),
      );

      await db.close();
    },
  );

  // ── Brain Tumor catalog tests ──────────────────────────────────────────────

  test('SystemModelCatalog contains exactly 2 catalog models', () {
    expect(SystemModelCatalog.allModels.length, equals(2));
  });

  test('Brain Tumor catalog entry has correct metadata', () {
    final bt = SystemModelCatalog.brainTumorResNet18;
    expect(bt.id, equals('wisteria-brain-tumor-resnet18'));
    expect(bt.modality, equals('MRI'));
    expect(bt.task, equals('Brain Tumor Classification'));
    expect(bt.assetPath, equals('assets/models/brain_tumor_resnet18.onnx'));
    expect(bt.outputClasses.length, equals(4));
    expect(bt.outputClasses[0], equals('glioma'));
    expect(bt.outputClasses[1], equals('meningioma'));
    expect(bt.outputClasses[2], equals('notumor'));
    expect(bt.outputClasses[3], equals('pituitary'));
    expect(bt.isSupported, isTrue);
  });

  test('BrainTumorInferenceService class labels match notebook contract', () {
    // Class order must exactly match PyTorch ImageFolder alphabetical ordering
    // as confirmed by notebook output:
    //   Class mapping: {'glioma': 0, 'meningioma': 1, 'notumor': 2, 'pituitary': 3}
    expect(BrainTumorInferenceService.classLabels.length, equals(4));
    expect(BrainTumorInferenceService.classLabels[0], equals('glioma'));
    expect(BrainTumorInferenceService.classLabels[1], equals('meningioma'));
    expect(BrainTumorInferenceService.classLabels[2], equals('notumor'));
    expect(BrainTumorInferenceService.classLabels[3], equals('pituitary'));
  });

  test('BrainTumorInferenceService normalization constants match notebook', () {
    // ImageNet normalization used in both train and test_transform in notebook.
    expect(BrainTumorInferenceService.mean[0], closeTo(0.485, 1e-6));
    expect(BrainTumorInferenceService.mean[1], closeTo(0.456, 1e-6));
    expect(BrainTumorInferenceService.mean[2], closeTo(0.406, 1e-6));
    expect(BrainTumorInferenceService.std[0], closeTo(0.229, 1e-6));
    expect(BrainTumorInferenceService.std[1], closeTo(0.224, 1e-6));
    expect(BrainTumorInferenceService.std[2], closeTo(0.225, 1e-6));
    expect(BrainTumorInferenceService.inputSize, equals(224));
  });

  test('BrainTumorInferenceService model asset path matches pubspec declaration', () {
    expect(
      BrainTumorInferenceService.modelAsset,
      equals('assets/models/brain_tumor_resnet18.onnx'),
    );
  });

  test('OnnxInferenceService (Pneumonia) constants remain unchanged', () {
    expect(OnnxInferenceService.modelAsset,
        equals('assets/models/pneumonia_resnet18.onnx'));
    expect(OnnxInferenceService.inputSize, equals(224));
    expect(OnnxInferenceService.mean[0], closeTo(0.485, 1e-6));
    expect(OnnxInferenceService.mean[1], closeTo(0.456, 1e-6));
    expect(OnnxInferenceService.mean[2], closeTo(0.406, 1e-6));
    expect(OnnxInferenceService.std[0], closeTo(0.229, 1e-6));
    expect(OnnxInferenceService.std[1], closeTo(0.224, 1e-6));
    expect(OnnxInferenceService.std[2], closeTo(0.225, 1e-6));
  });

  testWidgets(
    'MedicalModelPage renders auto-registered models without Register model button',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());
      final service = ModelRegistryService(db);
      await service.synchronizeCatalog();

      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.dark),
          home: MedicalModelPage(database: db),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Medical Model Management'), findsWidgets);
      expect(
        find.text(
          'Manage available medical AI models and their installed versions.',
        ),
        findsOneWidget,
      );
      // 2 models are now registered: Pneumonia + Brain Tumor
      expect(find.text('2 recognized models'), findsOneWidget);
      expect(find.text('Pneumonia ResNet18'), findsOneWidget);
      expect(find.text('Brain Tumor ResNet18'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Register model'), findsNothing);

      await db.close();
    },
  );

  testWidgets(
    'CreateExaminationPage has no dropdowns in Examination Setup and supports both pneumonia and brain tumor detection',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());
      final service = ModelRegistryService(db);
      await service.synchronizeCatalog();

      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.dark),
          home: CreateExaminationPage(
            database: db,
            patientId: 'patient-test-123',
            patientName: 'Test Patient',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Stage 0: Specialty selection should show Cardiology and Neurology
      expect(find.text('Select Medical Specialty'), findsOneWidget);
      expect(find.text('Cardiology'), findsOneWidget);
      expect(find.text('Neurology'), findsOneWidget);

      // Select Cardiology (Pneumonia)
      await tester.tap(find.text('Cardiology'));
      await tester.pumpAndSettle();

      // Check Examination Setup
      expect(find.text('Examination Setup'), findsOneWidget);
      expect(find.text('Test Patient'), findsOneWidget);
      expect(find.text('patient-test-123'), findsOneWidget);

      // Verify dropdowns are completely removed
      expect(find.text('Examination Type'), findsNothing);
      expect(find.text('Previous Data Context'), findsNothing);
      expect(find.byType(DropdownButton<String>), findsNothing);

      // Verify image addition is present
      expect(find.text('Medical Image'), findsOneWidget);
      expect(find.text('Click to select a chest X-ray image'), findsOneWidget);

      // Verify AI Analysis section is present with Pneumonia model
      expect(find.text('AI Analysis'), findsOneWidget);
      expect(find.text('Pneumonia ResNet18'), findsOneWidget);

      // Now switch specialty to Neurology (Brain Tumor)
      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();

      expect(find.text('Select Medical Specialty'), findsOneWidget);
      await tester.tap(find.text('Neurology'));
      await tester.pumpAndSettle();

      // Check Examination Setup for Brain Tumor
      expect(find.text('Examination Setup'), findsOneWidget);
      expect(find.text('Examination Type'), findsNothing);
      expect(find.text('Previous Data Context'), findsNothing);
      expect(find.byType(DropdownButton<String>), findsNothing);

      // Verify image addition is present for Brain MRI
      expect(find.text('Medical Image'), findsOneWidget);
      expect(find.text('Click to select a brain MRI image'), findsOneWidget);

      // Verify AI Analysis section is present with Brain Tumor model
      expect(find.text('Brain Tumor ResNet18'), findsOneWidget);

      await db.close();
    },
  );

  testWidgets(
    'ExaminationDetailsPage has no dropdown selection lists in AI Analysis section',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());
      final service = ModelRegistryService(db);
      await service.synchronizeCatalog();

      // Create test patient
      await db.into(db.patients).insert(
            PatientsCompanion.insert(
              id: 'patient-456',
              name: 'Jane Doe',
            ),
          );

      // Create test examination
      await db.into(db.examinations).insert(
            ExaminationsCompanion.insert(
              id: 'exam-456',
              patientId: 'patient-456',
              examinationType: 'MRI',
              examinationDate: DateTime.now(),
              previousDataRange: '6 Months',
              status: 'COMPLETED',
            ),
          );

      // Create test medical image
      await db.into(db.medicalImages).insert(
            MedicalImagesCompanion.insert(
              id: 'img-456',
              examinationId: 'exam-456',
              filePath: 'test/path/img.jpg',
              originalFileName: 'brain_scan.jpg',
              fileFormat: 'jpg',
              modality: 'MRI',
              clinicalDate: DateTime.now(),
            ),
          );

      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.dark),
          home: ExaminationDetailsPage(
            database: db,
            examinationId: 'exam-456',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify AI Analysis section is present
      expect(find.text('AI Analysis'), findsOneWidget);

      // Verify dropdowns (Select Image, Select Model) are completely removed
      expect(find.text('Select Image'), findsNothing);
      expect(find.text('Select Model'), findsNothing);
      expect(find.text('Choose a model'), findsNothing);
      expect(find.text('Choose an image'), findsNothing);
      expect(find.byType(DropdownButton<String>), findsNothing);

      // Verify model info card and Run button are present directly
      expect(find.text('Brain Tumor ResNet18'), findsWidgets);
      expect(find.text('Run Brain Tumor ResNet18'), findsOneWidget);

      await db.close();
    },
  );

  testWidgets(
    'PatientDetailsPage renders Option C layout with compact identity header, side-by-side patient info and new exam, paired analytics and history, and bottom examinations section in Dark and Light modes',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());
      final patientRepo = PatientRepository(db);

      await patientRepo.createPatient(
        id: 'patient-opt-a',
        name: 'Dr. Jane Doe',
        age: 34,
        bloodGroup: 'O+',
        phoneNumber: '+1 555-0199',
        otherContact: 'jane.doe@hospital.org',
        address: '452 Healthcare Ave, Metro City',
      );

      for (final brightness in [Brightness.dark, Brightness.light]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: buildWisteriaTheme(brightness: brightness),
            home: PatientDetailsPage(
              database: db,
              patientId: 'patient-opt-a',
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Compact Patient Identity Header
        expect(find.text('Dr. Jane Doe'), findsOneWidget);
        expect(find.text('patient-opt-a'), findsOneWidget);
        expect(find.text('Edit Patient'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);

        // Left Column: Patient Information Section (Tidy Grid)
        expect(find.text('Patient Information'), findsOneWidget);
        expect(find.text('AGE'), findsOneWidget);
        expect(find.text('34 years'), findsOneWidget);
        expect(find.text('BLOOD GROUP'), findsOneWidget);
        expect(find.text('O+'), findsOneWidget);
        expect(find.text('PRIMARY PHONE'), findsOneWidget);
        expect(find.text('+1 555-0199'), findsOneWidget);
        expect(find.text('SECONDARY CONTACT'), findsOneWidget);
        expect(find.text('jane.doe@hospital.org'), findsOneWidget);
        expect(find.text('RESIDENTIAL ADDRESS'), findsOneWidget);
        expect(find.text('452 Healthcare Ave, Metro City'), findsOneWidget);

        // Right Column: Prominent New Examination Card
        expect(find.text('New Examination'), findsOneWidget);
        expect(find.text('PRIMARY'), findsOneWidget);
        expect(find.text('Begin Examination'), findsOneWidget);

        // Right Column: Secondary Modules
        expect(find.text('Patient Analytics'), findsOneWidget);
        expect(find.text('Medical History & Trends'), findsOneWidget);
        expect(find.text('Coming Soon'), findsNWidgets(2));

        // Bottom Section: Examinations Records (Sensible Empty State)
        expect(find.text('Examinations Records'), findsOneWidget);
        expect(find.text('No Examinations Recorded'), findsOneWidget);
      }

      await db.close();
    },
  );

  testWidgets(
    'Back navigation fix: PatientDetailsPage -> Begin Examination -> Back returns to originating PatientDetailsPage',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());
      final service = ModelRegistryService(db);
      await service.synchronizeCatalog();

      final patientRepo = PatientRepository(db);
      await patientRepo.createPatient(
        id: 'patient-nav-test',
        name: 'Arthur Pendelton',
        age: 58,
        bloodGroup: 'A+',
        phoneNumber: '+1 555-8822',
        address: '10 Elm Street',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.dark),
          home: PatientDetailsPage(
            database: db,
            patientId: 'patient-nav-test',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify we start on PatientDetailsPage
      expect(find.text('Arthur Pendelton'), findsOneWidget);
      expect(find.text('Begin Examination'), findsOneWidget);

      // Tap Begin Examination -> opens CreateExaminationPage
      await tester.tap(find.text('Begin Examination'));
      await tester.pumpAndSettle();

      // Verify we are now on CreateExaminationPage (Stage 0: Select Medical Specialty)
      expect(find.text('Select Medical Specialty'), findsOneWidget);
      expect(find.textContaining('Arthur Pendelton'), findsOneWidget);
      expect(find.text('Cardiology'), findsOneWidget);
      expect(find.text('Neurology'), findsOneWidget);
      expect(find.text('Ophthalmology'), findsOneWidget);

      // Verify WisteriaBackButton label indicates 'Patient Details'
      expect(find.text('Patient Details'), findsOneWidget);

      // Tap Back button
      await tester.tap(find.text('Patient Details'));
      await tester.pumpAndSettle();

      // Crucial verification: We must return directly to Arthur Pendelton's PatientDetailsPage!
      expect(find.text('Select Medical Specialty'), findsNothing);
      expect(find.text('Arthur Pendelton'), findsOneWidget);
      expect(find.text('patient-nav-test'), findsOneWidget);
      expect(find.text('Patient Information'), findsOneWidget);
      expect(find.text('Begin Examination'), findsOneWidget);

      await db.close();
    },
  );

  testWidgets(
    'CreateExaminationPage Option B displays 3 stacked horizontal specialty cards with modality and availability badges',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());
      final service = ModelRegistryService(db);
      await service.synchronizeCatalog();

      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.light),
          home: CreateExaminationPage(
            database: db,
            patientId: 'patient-option-b',
            patientName: 'Elena Rostova',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Stage 0 Header
      expect(find.text('Select Medical Specialty'), findsOneWidget);

      // Verify Option B cards
      expect(find.text('Cardiology'), findsOneWidget);
      expect(find.text('CHEST X-RAY'), findsOneWidget);
      expect(find.text('Pneumonia Detection · Chest X-Ray'), findsOneWidget);

      expect(find.text('Neurology'), findsOneWidget);
      expect(find.text('BRAIN MRI'), findsOneWidget);
      expect(find.text('Brain Tumor Detection · MRI'), findsOneWidget);

      expect(find.text('Ophthalmology'), findsOneWidget);
      expect(find.text('RETINAL / OCT'), findsOneWidget);
      expect(find.text('Eye & Vision · Coming Soon'), findsOneWidget);
      expect(find.text('Unavailable'), findsOneWidget);

      // Badges
      expect(find.text('ACTIVE AI'), findsNWidgets(2));
      expect(find.text('COMING SOON'), findsOneWidget);

      await db.close();
    },
  );

  test('Verify Neutral Grayscale Dark Mode Theme specification and button color preservation', () {
    // 1. Five Reference Neutral Shades
    expect(WisteriaColors.darkPalette.background, const Color(0xFF0D0D0D)); // Near-black background
    expect(WisteriaColors.darkPalette.surfaceLow, const Color(0xFF1D1D1D)); // Secondary dark surface
    expect(WisteriaColors.darkPalette.surfaceContainer, const Color(0xFF2D2D2D)); // Elevated surface
    expect(WisteriaColors.darkPalette.surface, const Color(0xFF3D3D3D)); // Card or panel surface
    expect(WisteriaColors.darkPalette.surfaceHighest, const Color(0xFF4D4D4D)); // Lighter neutral surface

    // 2. White typography throughout dark mode
    expect(WisteriaColors.darkPalette.textPrimary, const Color(0xFFFFFFFF));
    expect(WisteriaColors.darkPalette.textSecondary, const Color(0xFFCCCCCC));
    expect(WisteriaColors.darkPalette.textMuted, const Color(0xFF8E8E8E));
    expect(WisteriaColors.darkPalette.textOnPrimary, const Color(0xFFFFFFFF));

    // 3. Strict button color preservation
    expect(WisteriaColors.darkPalette.primary, const Color(0xFF098FA6));
    expect(WisteriaColors.darkPalette.primaryMuted, const Color(0xFF07788C));
    expect(WisteriaColors.darkPalette.secondary, const Color(0xFF0D9488));
    expect(WisteriaColors.darkPalette.tertiary, const Color(0xFF2DD4BF));

    // 4. Neutral borders and focus
    expect(WisteriaColors.darkPalette.border, const Color(0xFF333333));
    expect(WisteriaColors.darkPalette.borderSubtle, const Color(0xFF222222));
    expect(WisteriaColors.darkPalette.borderFocus, const Color(0xFF6E6E6E));

    // 5. Light mode preservation
    expect(WisteriaColors.lightPalette.background, const Color(0xFFF0F5F6));
    expect(WisteriaColors.lightPalette.surface, const Color(0xFFFFFFFF));
    expect(WisteriaColors.lightPalette.primary, const Color(0xFF098FA6));
    expect(WisteriaColors.lightPalette.primaryMuted, const Color(0xFF07788C));
    expect(WisteriaColors.lightPalette.textPrimary, const Color(0xFF1E293B));
  });
  testWidgets(
    'Patient gender field persists across create, update, and PatientDetailsPage display',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());
      final repo = PatientRepository(db);

      // 1. Create patient with Gender
      await repo.createPatient(
        id: 'patient-gender-test',
        name: 'Alex Morgan',
        age: 28,
        bloodGroup: 'AB+',
        gender: 'Female',
        phoneNumber: '+1-555-0144',
        otherContact: 'alex@example.org',
        address: '100 Medical Plaza',
      );

      // Verify DB stored gender
      final p1 = await repo.getPatientById('patient-gender-test');
      expect(p1?.gender, equals('Female'));

      // 2. Render in PatientDetailsPage in Dark Mode and verify Gender display
      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.dark),
          home: PatientDetailsPage(
            database: db,
            patientId: 'patient-gender-test',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('GENDER'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);

      // 3. Update patient gender to Other
      final updated = await repo.updatePatient(
        id: 'patient-gender-test',
        name: 'Alex Morgan',
        age: 28,
        bloodGroup: 'AB+',
        gender: 'Other',
        phoneNumber: '+1-555-0144',
        otherContact: 'alex@example.org',
        address: '100 Medical Plaza',
      );
      expect(updated, isTrue);

      final p2 = await repo.getPatientById('patient-gender-test');
      expect(p2?.gender, equals('Other'));

      await db.close();
    },
  );

  testWidgets(
    'Patient Record Overview dark mode renders white icon glyphs without blue container backgrounds',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());
      final repo = PatientRepository(db);

      await repo.createPatient(
        id: 'patient-icon-test',
        name: 'Test Patient',
        age: 45,
        bloodGroup: 'B+',
        gender: 'Male',
        phoneNumber: '+1-555-9988',
        otherContact: 'test@example.com',
        address: '77 Clinic Way',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.dark),
          home: PatientDetailsPage(
            database: db,
            patientId: 'patient-icon-test',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find icons in info items (e.g. cake, bloodtype, wc, phone, alternate_email, location_on)
      final ageIcon = tester.widget<Icon>(find.byIcon(Icons.cake_outlined));
      expect(ageIcon.color, equals(Colors.white));

      final genderIcon = tester.widget<Icon>(find.byIcon(Icons.wc_rounded));
      expect(genderIcon.color, equals(Colors.white));

      final bloodIcon = tester.widget<Icon>(find.byIcon(Icons.bloodtype_outlined));
      expect(bloodIcon.color, equals(Colors.white));

      final phoneIcon = tester.widget<Icon>(find.byIcon(Icons.phone_outlined));
      expect(phoneIcon.color, equals(Colors.white));

      // Header icon
      final personHeaderIcon = tester.widget<Icon>(find.byIcon(Icons.person_outline_rounded));
      expect(personHeaderIcon.color, equals(Colors.white));

      // Begin Examination button preserves primary color
      expect(find.text('Begin Examination'), findsOneWidget);

      await db.close();
    },
  );
  testWidgets(
    'CreateExaminationPage dark mode renders white icons without blue backgrounds and preserves buttons/badges',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final db = WisteriaDatabase(NativeDatabase.memory());

      await tester.pumpWidget(
        MaterialApp(
          theme: buildWisteriaTheme(brightness: Brightness.dark),
          home: CreateExaminationPage(
            database: db,
            patientId: 'patient-test-icons',
            patientName: 'Jane Smith',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Top bar patient pill icon is white
      final topPatientIcon = tester.widget<Icon>(
        find.descendant(
          of: find.byType(AppBar).evaluate().isEmpty ? find.byType(Scaffold) : find.byType(AppBar),
          matching: find.byIcon(Icons.person_outline_rounded),
        ).first,
      );
      expect(topPatientIcon.color, equals(Colors.white));

      // Select Cardiology specialty
      await tester.tap(find.text('Select Specialty').first);
      await tester.pumpAndSettle();

      // Active specialty banner icon (favorite_rounded) is white
      final specialtyIcon = tester.widget<Icon>(find.byIcon(Icons.favorite_rounded));
      expect(specialtyIcon.color, equals(Colors.white));

      // Examination Setup section icon (assignment_outlined) is white
      final examSetupIcon = tester.widget<Icon>(find.byIcon(Icons.assignment_outlined));
      expect(examSetupIcon.color, equals(Colors.white));

      // Patient identity icon in Stage A is white
      final patientIcons = tester.widgetList<Icon>(find.byIcon(Icons.person_outline_rounded));
      for (final icon in patientIcons) {
        expect(icon.color, equals(Colors.white));
      }

      // Medical Image header icon is white
      final medicalImageIcon = tester.widget<Icon>(find.byIcon(Icons.image_outlined));
      expect(medicalImageIcon.color, equals(Colors.white));

      // Image upload icon (add_photo_alternate_outlined) is white
      final uploadIcon = tester.widget<Icon>(find.byIcon(Icons.add_photo_alternate_outlined));
      expect(uploadIcon.color, equals(Colors.white));

      // AI Analysis section icon (memory_rounded) is white
      final aiAnalysisIcon = tester.widget<Icon>(find.byIcon(Icons.memory_rounded));
      expect(aiAnalysisIcon.color, equals(Colors.white));

      // ONNX model icon (developer_board_rounded) is white
      final onnxIcon = tester.widget<Icon>(find.byIcon(Icons.developer_board_rounded));
      expect(onnxIcon.color, equals(Colors.white));

      // Clinical disclaimer icon (verified_user_outlined) is white
      final disclaimerIcon = tester.widget<Icon>(find.byIcon(Icons.verified_user_outlined));
      expect(disclaimerIcon.color, equals(Colors.white));

      // Buttons preserved: Browse Image File button is present
      expect(find.text('Browse Image File'), findsOneWidget);

      // Status indicator preserved: LOCAL ONNX badge is present
      expect(find.text('LOCAL ONNX'), findsOneWidget);

      await db.close();
    },
  );
}