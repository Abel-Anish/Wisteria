import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    DoctorProfiles,
    Patients,
    PreviousMedicalInformations,
    PreviousMedications,
    PreviousTestResults,
    Examinations,
    MedicalImages,
    MedicalModels,
    ModelVersions,
    ModelRuns,
    ModelRunResults,
    ModelFindings,
    AiAnalyses,
    Evidence,
    DoctorReviews,
    FinalReports,
    SyncItems,
  ],
)
class WisteriaDatabase extends _$WisteriaDatabase {
  WisteriaDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'wisteria_v2'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(doctorProfiles, doctorProfiles.email);

          await m.addColumn(doctorProfiles, doctorProfiles.documentPath);

          await m.addColumn(doctorProfiles, doctorProfiles.documentFileName);
        }

        if (from < 3) {
          await m.addColumn(patients, patients.gender);
        }
      },
    );
  }
}
