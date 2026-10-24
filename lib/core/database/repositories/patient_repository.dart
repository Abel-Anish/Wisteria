import 'package:drift/drift.dart';

import '../database.dart';

class PatientRepository {
  final WisteriaDatabase database;

  PatientRepository(this.database);

  Future<List<Patient>> getAllPatients() {
    return database.select(database.patients).get();
  }

  Future<Patient?> getPatientById(String id) {
    return (database.select(
      database.patients,
    )..where((patient) => patient.id.equals(id))).getSingleOrNull();
  }

  Future<void> createPatient({
    required String id,
    required String name,
    String? phoneNumber,
    int? age,
    DateTime? dateOfBirth,
    String? bloodGroup,
    String? gender,
    String? otherContact,
    String? address,
  }) async {
    await database
        .into(database.patients)
        .insert(
          PatientsCompanion.insert(
            id: id,
            name: name,
            phoneNumber: Value(phoneNumber),
            age: Value(age),
            dateOfBirth: Value(dateOfBirth),
            bloodGroup: Value(bloodGroup),
            gender: Value(gender),
            otherContact: Value(otherContact),
            address: Value(address),
          ),
        );
  }

  Future<bool> updatePatient({
    required String id,
    required String name,
    String? phoneNumber,
    int? age,
    DateTime? dateOfBirth,
    String? bloodGroup,
    String? gender,
    String? otherContact,
    String? address,
  }) async {
    final updatedRows =
        await (database.update(
          database.patients,
        )..where((patient) => patient.id.equals(id))).write(
          PatientsCompanion(
            name: Value(name),
            phoneNumber: Value(phoneNumber),
            age: Value(age),
            dateOfBirth: Value(dateOfBirth),
            bloodGroup: Value(bloodGroup),
            gender: Value(gender),
            otherContact: Value(otherContact),
            address: Value(address),
          ),
        );

    return updatedRows > 0;
  }

  Future<bool> deletePatient(String id) async {
    final deletedRows = await (database.delete(
      database.patients,
    )..where((patient) => patient.id.equals(id))).go();

    return deletedRows > 0;
  }

  Future<List<Patient>> searchPatients(String query) {
    final searchQuery = '%${query.trim()}%';

    return (database.select(database.patients)
          ..where(
            (patient) =>
                patient.name.like(searchQuery) |
                patient.id.like(searchQuery) |
                patient.phoneNumber.like(searchQuery),
          )
          ..orderBy([(patient) => OrderingTerm.asc(patient.name)]))
        .get();
  }
}
