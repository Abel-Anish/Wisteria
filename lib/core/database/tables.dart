import 'package:drift/drift.dart';

// ============================================================
// DOCTOR PROFILE
// ============================================================

class DoctorProfiles extends Table {
  TextColumn get id => text()();

  TextColumn get doctorName => text()();

  TextColumn get specialization => text().nullable()();

  TextColumn get clinicName => text().nullable()();

  TextColumn get clinicAddress => text().nullable()();

  TextColumn get clinicPhoneNumber => text().nullable()();

  TextColumn get email => text().nullable()();

  TextColumn get signature => text().nullable()();

  TextColumn get documentPath => text().nullable()();

  TextColumn get documentFileName => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// PATIENT
// ============================================================

class Patients extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get phoneNumber => text().nullable()();

  IntColumn get age => integer().nullable()();

  DateTimeColumn get dateOfBirth => dateTime().nullable()();

  TextColumn get bloodGroup => text().nullable()();

  TextColumn get gender => text().nullable()();

  TextColumn get otherContact => text().nullable()();

  TextColumn get address => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// PREVIOUS MEDICAL INFORMATION
// ============================================================

class PreviousMedicalInformations extends Table {
  TextColumn get id => text()();

  TextColumn get patientId => text().references(Patients, #id)();

  TextColumn get title => text()();

  TextColumn get description => text()();

  TextColumn get source => text().nullable()();

  DateTimeColumn get dateOrPeriod => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// PREVIOUS MEDICATION
// ============================================================

class PreviousMedications extends Table {
  TextColumn get id => text()();

  TextColumn get patientId => text().references(Patients, #id)();

  TextColumn get medicineName => text()();

  TextColumn get dosage => text().nullable()();

  TextColumn get duration => text().nullable()();

  TextColumn get reasonOrCondition => text().nullable()();

  TextColumn get source => text().nullable()();

  DateTimeColumn get dateOrPeriod => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// PREVIOUS TEST RESULTS
// ============================================================

class PreviousTestResults extends Table {
  TextColumn get id => text()();

  TextColumn get patientId => text().references(Patients, #id)();

  TextColumn get testName => text()();

  TextColumn get category => text().nullable()();

  DateTimeColumn get dateTaken => dateTime().nullable()();

  TextColumn get hospitalOrClinic => text().nullable()();

  TextColumn get summary => text().nullable()();

  TextColumn get keyFindings => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// EXAMINATION
// ============================================================

class Examinations extends Table {
  TextColumn get id => text()();

  TextColumn get patientId => text().references(Patients, #id)();

  TextColumn get examinationType => text()();

  DateTimeColumn get examinationDate => dateTime()();

  TextColumn get doctorNotes => text().nullable()();

  TextColumn get previousDataRange => text()();

  TextColumn get status => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// MEDICAL IMAGE
// ============================================================

class MedicalImages extends Table {
  TextColumn get id => text()();

  TextColumn get examinationId => text().references(Examinations, #id)();

  TextColumn get filePath => text()();

  TextColumn get originalFileName => text()();

  TextColumn get fileFormat => text()();

  TextColumn get modality => text()();

  DateTimeColumn get clinicalDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// MEDICAL MODEL
// ============================================================

class MedicalModels extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  TextColumn get task => text()();

  TextColumn get modality => text()();

  TextColumn get runtime => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// MODEL VERSION
// ============================================================

class ModelVersions extends Table {
  TextColumn get id => text()();

  TextColumn get modelId => text().references(MedicalModels, #id)();

  TextColumn get version => text()();

  TextColumn get filePath => text()();

  TextColumn get checksum => text()();

  TextColumn get compatibility => text().nullable()();

  TextColumn get installationStatus => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// MODEL RUN
// ============================================================

class ModelRuns extends Table {
  TextColumn get id => text()();

  TextColumn get examinationId => text().references(Examinations, #id)();

  TextColumn get modelId => text().references(MedicalModels, #id)();

  TextColumn get modelVersionId => text().references(ModelVersions, #id)();

  TextColumn get inputImageId => text().references(MedicalImages, #id)();

  DateTimeColumn get inputImageDate => dateTime()();

  DateTimeColumn get executionTimestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// MODEL RUN RESULT
// ============================================================

class ModelRunResults extends Table {
  TextColumn get id => text()();

  TextColumn get modelRunId => text().references(ModelRuns, #id)();

  TextColumn get status => text()();

  TextColumn get confidence => text().nullable()();

  TextColumn get uncertainty => text().nullable()();

  TextColumn get rawModelOutput => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// MODEL FINDING
// ============================================================

class ModelFindings extends Table {
  TextColumn get id => text()();

  TextColumn get modelRunResultId => text().references(ModelRunResults, #id)();

  TextColumn get label => text()();

  TextColumn get value => text()();

  TextColumn get confidence => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// AI ANALYSIS
// ============================================================

class AiAnalyses extends Table {
  TextColumn get id => text()();

  TextColumn get examinationId => text().references(Examinations, #id)();

  DateTimeColumn get generatedAt => dateTime()();

  TextColumn get ollamaModel => text()();

  TextColumn get contextWindow => text()();

  TextColumn get summary => text().nullable()();

  TextColumn get uncertainty => text().nullable()();

  TextColumn get status => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// EVIDENCE
// ============================================================

class Evidence extends Table {
  TextColumn get id => text()();

  TextColumn get analysisId => text().references(AiAnalyses, #id)();

  TextColumn get sourceType => text()();

  TextColumn get sourceId => text()();

  DateTimeColumn get sourceDate => dateTime().nullable()();

  TextColumn get content => text()();

  TextColumn get relevance => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// DOCTOR REVIEW
// ============================================================

class DoctorReviews extends Table {
  TextColumn get id => text()();

  TextColumn get examinationId => text().references(Examinations, #id)();

  TextColumn get reviewStatus => text()();

  DateTimeColumn get reviewedAt => dateTime()();

  TextColumn get finalizedAnalysis => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// FINAL REPORT
// ============================================================

class FinalReports extends Table {
  TextColumn get id => text()();

  TextColumn get examinationId => text().references(Examinations, #id)();

  DateTimeColumn get generatedAt => dateTime()();

  TextColumn get filePath => text()();

  TextColumn get finalizedAnalysis => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================
// SYNC ITEM
// ============================================================

class SyncItems extends Table {
  TextColumn get id => text()();

  TextColumn get entityId => text()();

  TextColumn get entityType => text()();

  IntColumn get localVersion => integer()();

  IntColumn get cloudVersion => integer().nullable()();

  TextColumn get syncStatus => text()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
