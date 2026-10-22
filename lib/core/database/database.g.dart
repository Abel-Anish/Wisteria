// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DoctorProfilesTable extends DoctorProfiles
    with TableInfo<$DoctorProfilesTable, DoctorProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoctorProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorNameMeta = const VerificationMeta(
    'doctorName',
  );
  @override
  late final GeneratedColumn<String> doctorName = GeneratedColumn<String>(
    'doctor_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specializationMeta = const VerificationMeta(
    'specialization',
  );
  @override
  late final GeneratedColumn<String> specialization = GeneratedColumn<String>(
    'specialization',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clinicNameMeta = const VerificationMeta(
    'clinicName',
  );
  @override
  late final GeneratedColumn<String> clinicName = GeneratedColumn<String>(
    'clinic_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clinicAddressMeta = const VerificationMeta(
    'clinicAddress',
  );
  @override
  late final GeneratedColumn<String> clinicAddress = GeneratedColumn<String>(
    'clinic_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clinicPhoneNumberMeta = const VerificationMeta(
    'clinicPhoneNumber',
  );
  @override
  late final GeneratedColumn<String> clinicPhoneNumber =
      GeneratedColumn<String>(
        'clinic_phone_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signatureMeta = const VerificationMeta(
    'signature',
  );
  @override
  late final GeneratedColumn<String> signature = GeneratedColumn<String>(
    'signature',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _documentPathMeta = const VerificationMeta(
    'documentPath',
  );
  @override
  late final GeneratedColumn<String> documentPath = GeneratedColumn<String>(
    'document_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _documentFileNameMeta = const VerificationMeta(
    'documentFileName',
  );
  @override
  late final GeneratedColumn<String> documentFileName = GeneratedColumn<String>(
    'document_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    doctorName,
    specialization,
    clinicName,
    clinicAddress,
    clinicPhoneNumber,
    email,
    signature,
    documentPath,
    documentFileName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doctor_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoctorProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('doctor_name')) {
      context.handle(
        _doctorNameMeta,
        doctorName.isAcceptableOrUnknown(data['doctor_name']!, _doctorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_doctorNameMeta);
    }
    if (data.containsKey('specialization')) {
      context.handle(
        _specializationMeta,
        specialization.isAcceptableOrUnknown(
          data['specialization']!,
          _specializationMeta,
        ),
      );
    }
    if (data.containsKey('clinic_name')) {
      context.handle(
        _clinicNameMeta,
        clinicName.isAcceptableOrUnknown(data['clinic_name']!, _clinicNameMeta),
      );
    }
    if (data.containsKey('clinic_address')) {
      context.handle(
        _clinicAddressMeta,
        clinicAddress.isAcceptableOrUnknown(
          data['clinic_address']!,
          _clinicAddressMeta,
        ),
      );
    }
    if (data.containsKey('clinic_phone_number')) {
      context.handle(
        _clinicPhoneNumberMeta,
        clinicPhoneNumber.isAcceptableOrUnknown(
          data['clinic_phone_number']!,
          _clinicPhoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('signature')) {
      context.handle(
        _signatureMeta,
        signature.isAcceptableOrUnknown(data['signature']!, _signatureMeta),
      );
    }
    if (data.containsKey('document_path')) {
      context.handle(
        _documentPathMeta,
        documentPath.isAcceptableOrUnknown(
          data['document_path']!,
          _documentPathMeta,
        ),
      );
    }
    if (data.containsKey('document_file_name')) {
      context.handle(
        _documentFileNameMeta,
        documentFileName.isAcceptableOrUnknown(
          data['document_file_name']!,
          _documentFileNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoctorProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoctorProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      doctorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_name'],
      )!,
      specialization: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specialization'],
      ),
      clinicName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clinic_name'],
      ),
      clinicAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clinic_address'],
      ),
      clinicPhoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clinic_phone_number'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      signature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature'],
      ),
      documentPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_path'],
      ),
      documentFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_file_name'],
      ),
    );
  }

  @override
  $DoctorProfilesTable createAlias(String alias) {
    return $DoctorProfilesTable(attachedDatabase, alias);
  }
}

class DoctorProfile extends DataClass implements Insertable<DoctorProfile> {
  final String id;
  final String doctorName;
  final String? specialization;
  final String? clinicName;
  final String? clinicAddress;
  final String? clinicPhoneNumber;
  final String? email;
  final String? signature;
  final String? documentPath;
  final String? documentFileName;
  const DoctorProfile({
    required this.id,
    required this.doctorName,
    this.specialization,
    this.clinicName,
    this.clinicAddress,
    this.clinicPhoneNumber,
    this.email,
    this.signature,
    this.documentPath,
    this.documentFileName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['doctor_name'] = Variable<String>(doctorName);
    if (!nullToAbsent || specialization != null) {
      map['specialization'] = Variable<String>(specialization);
    }
    if (!nullToAbsent || clinicName != null) {
      map['clinic_name'] = Variable<String>(clinicName);
    }
    if (!nullToAbsent || clinicAddress != null) {
      map['clinic_address'] = Variable<String>(clinicAddress);
    }
    if (!nullToAbsent || clinicPhoneNumber != null) {
      map['clinic_phone_number'] = Variable<String>(clinicPhoneNumber);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || signature != null) {
      map['signature'] = Variable<String>(signature);
    }
    if (!nullToAbsent || documentPath != null) {
      map['document_path'] = Variable<String>(documentPath);
    }
    if (!nullToAbsent || documentFileName != null) {
      map['document_file_name'] = Variable<String>(documentFileName);
    }
    return map;
  }

  DoctorProfilesCompanion toCompanion(bool nullToAbsent) {
    return DoctorProfilesCompanion(
      id: Value(id),
      doctorName: Value(doctorName),
      specialization: specialization == null && nullToAbsent
          ? const Value.absent()
          : Value(specialization),
      clinicName: clinicName == null && nullToAbsent
          ? const Value.absent()
          : Value(clinicName),
      clinicAddress: clinicAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(clinicAddress),
      clinicPhoneNumber: clinicPhoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(clinicPhoneNumber),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      signature: signature == null && nullToAbsent
          ? const Value.absent()
          : Value(signature),
      documentPath: documentPath == null && nullToAbsent
          ? const Value.absent()
          : Value(documentPath),
      documentFileName: documentFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(documentFileName),
    );
  }

  factory DoctorProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoctorProfile(
      id: serializer.fromJson<String>(json['id']),
      doctorName: serializer.fromJson<String>(json['doctorName']),
      specialization: serializer.fromJson<String?>(json['specialization']),
      clinicName: serializer.fromJson<String?>(json['clinicName']),
      clinicAddress: serializer.fromJson<String?>(json['clinicAddress']),
      clinicPhoneNumber: serializer.fromJson<String?>(
        json['clinicPhoneNumber'],
      ),
      email: serializer.fromJson<String?>(json['email']),
      signature: serializer.fromJson<String?>(json['signature']),
      documentPath: serializer.fromJson<String?>(json['documentPath']),
      documentFileName: serializer.fromJson<String?>(json['documentFileName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'doctorName': serializer.toJson<String>(doctorName),
      'specialization': serializer.toJson<String?>(specialization),
      'clinicName': serializer.toJson<String?>(clinicName),
      'clinicAddress': serializer.toJson<String?>(clinicAddress),
      'clinicPhoneNumber': serializer.toJson<String?>(clinicPhoneNumber),
      'email': serializer.toJson<String?>(email),
      'signature': serializer.toJson<String?>(signature),
      'documentPath': serializer.toJson<String?>(documentPath),
      'documentFileName': serializer.toJson<String?>(documentFileName),
    };
  }

  DoctorProfile copyWith({
    String? id,
    String? doctorName,
    Value<String?> specialization = const Value.absent(),
    Value<String?> clinicName = const Value.absent(),
    Value<String?> clinicAddress = const Value.absent(),
    Value<String?> clinicPhoneNumber = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> signature = const Value.absent(),
    Value<String?> documentPath = const Value.absent(),
    Value<String?> documentFileName = const Value.absent(),
  }) => DoctorProfile(
    id: id ?? this.id,
    doctorName: doctorName ?? this.doctorName,
    specialization: specialization.present
        ? specialization.value
        : this.specialization,
    clinicName: clinicName.present ? clinicName.value : this.clinicName,
    clinicAddress: clinicAddress.present
        ? clinicAddress.value
        : this.clinicAddress,
    clinicPhoneNumber: clinicPhoneNumber.present
        ? clinicPhoneNumber.value
        : this.clinicPhoneNumber,
    email: email.present ? email.value : this.email,
    signature: signature.present ? signature.value : this.signature,
    documentPath: documentPath.present ? documentPath.value : this.documentPath,
    documentFileName: documentFileName.present
        ? documentFileName.value
        : this.documentFileName,
  );
  DoctorProfile copyWithCompanion(DoctorProfilesCompanion data) {
    return DoctorProfile(
      id: data.id.present ? data.id.value : this.id,
      doctorName: data.doctorName.present
          ? data.doctorName.value
          : this.doctorName,
      specialization: data.specialization.present
          ? data.specialization.value
          : this.specialization,
      clinicName: data.clinicName.present
          ? data.clinicName.value
          : this.clinicName,
      clinicAddress: data.clinicAddress.present
          ? data.clinicAddress.value
          : this.clinicAddress,
      clinicPhoneNumber: data.clinicPhoneNumber.present
          ? data.clinicPhoneNumber.value
          : this.clinicPhoneNumber,
      email: data.email.present ? data.email.value : this.email,
      signature: data.signature.present ? data.signature.value : this.signature,
      documentPath: data.documentPath.present
          ? data.documentPath.value
          : this.documentPath,
      documentFileName: data.documentFileName.present
          ? data.documentFileName.value
          : this.documentFileName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoctorProfile(')
          ..write('id: $id, ')
          ..write('doctorName: $doctorName, ')
          ..write('specialization: $specialization, ')
          ..write('clinicName: $clinicName, ')
          ..write('clinicAddress: $clinicAddress, ')
          ..write('clinicPhoneNumber: $clinicPhoneNumber, ')
          ..write('email: $email, ')
          ..write('signature: $signature, ')
          ..write('documentPath: $documentPath, ')
          ..write('documentFileName: $documentFileName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    doctorName,
    specialization,
    clinicName,
    clinicAddress,
    clinicPhoneNumber,
    email,
    signature,
    documentPath,
    documentFileName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoctorProfile &&
          other.id == this.id &&
          other.doctorName == this.doctorName &&
          other.specialization == this.specialization &&
          other.clinicName == this.clinicName &&
          other.clinicAddress == this.clinicAddress &&
          other.clinicPhoneNumber == this.clinicPhoneNumber &&
          other.email == this.email &&
          other.signature == this.signature &&
          other.documentPath == this.documentPath &&
          other.documentFileName == this.documentFileName);
}

class DoctorProfilesCompanion extends UpdateCompanion<DoctorProfile> {
  final Value<String> id;
  final Value<String> doctorName;
  final Value<String?> specialization;
  final Value<String?> clinicName;
  final Value<String?> clinicAddress;
  final Value<String?> clinicPhoneNumber;
  final Value<String?> email;
  final Value<String?> signature;
  final Value<String?> documentPath;
  final Value<String?> documentFileName;
  final Value<int> rowid;
  const DoctorProfilesCompanion({
    this.id = const Value.absent(),
    this.doctorName = const Value.absent(),
    this.specialization = const Value.absent(),
    this.clinicName = const Value.absent(),
    this.clinicAddress = const Value.absent(),
    this.clinicPhoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.signature = const Value.absent(),
    this.documentPath = const Value.absent(),
    this.documentFileName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoctorProfilesCompanion.insert({
    required String id,
    required String doctorName,
    this.specialization = const Value.absent(),
    this.clinicName = const Value.absent(),
    this.clinicAddress = const Value.absent(),
    this.clinicPhoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.signature = const Value.absent(),
    this.documentPath = const Value.absent(),
    this.documentFileName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       doctorName = Value(doctorName);
  static Insertable<DoctorProfile> custom({
    Expression<String>? id,
    Expression<String>? doctorName,
    Expression<String>? specialization,
    Expression<String>? clinicName,
    Expression<String>? clinicAddress,
    Expression<String>? clinicPhoneNumber,
    Expression<String>? email,
    Expression<String>? signature,
    Expression<String>? documentPath,
    Expression<String>? documentFileName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (doctorName != null) 'doctor_name': doctorName,
      if (specialization != null) 'specialization': specialization,
      if (clinicName != null) 'clinic_name': clinicName,
      if (clinicAddress != null) 'clinic_address': clinicAddress,
      if (clinicPhoneNumber != null) 'clinic_phone_number': clinicPhoneNumber,
      if (email != null) 'email': email,
      if (signature != null) 'signature': signature,
      if (documentPath != null) 'document_path': documentPath,
      if (documentFileName != null) 'document_file_name': documentFileName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoctorProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? doctorName,
    Value<String?>? specialization,
    Value<String?>? clinicName,
    Value<String?>? clinicAddress,
    Value<String?>? clinicPhoneNumber,
    Value<String?>? email,
    Value<String?>? signature,
    Value<String?>? documentPath,
    Value<String?>? documentFileName,
    Value<int>? rowid,
  }) {
    return DoctorProfilesCompanion(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      specialization: specialization ?? this.specialization,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      clinicPhoneNumber: clinicPhoneNumber ?? this.clinicPhoneNumber,
      email: email ?? this.email,
      signature: signature ?? this.signature,
      documentPath: documentPath ?? this.documentPath,
      documentFileName: documentFileName ?? this.documentFileName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (doctorName.present) {
      map['doctor_name'] = Variable<String>(doctorName.value);
    }
    if (specialization.present) {
      map['specialization'] = Variable<String>(specialization.value);
    }
    if (clinicName.present) {
      map['clinic_name'] = Variable<String>(clinicName.value);
    }
    if (clinicAddress.present) {
      map['clinic_address'] = Variable<String>(clinicAddress.value);
    }
    if (clinicPhoneNumber.present) {
      map['clinic_phone_number'] = Variable<String>(clinicPhoneNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (signature.present) {
      map['signature'] = Variable<String>(signature.value);
    }
    if (documentPath.present) {
      map['document_path'] = Variable<String>(documentPath.value);
    }
    if (documentFileName.present) {
      map['document_file_name'] = Variable<String>(documentFileName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoctorProfilesCompanion(')
          ..write('id: $id, ')
          ..write('doctorName: $doctorName, ')
          ..write('specialization: $specialization, ')
          ..write('clinicName: $clinicName, ')
          ..write('clinicAddress: $clinicAddress, ')
          ..write('clinicPhoneNumber: $clinicPhoneNumber, ')
          ..write('email: $email, ')
          ..write('signature: $signature, ')
          ..write('documentPath: $documentPath, ')
          ..write('documentFileName: $documentFileName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PatientsTable extends Patients with TableInfo<$PatientsTable, Patient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bloodGroupMeta = const VerificationMeta(
    'bloodGroup',
  );
  @override
  late final GeneratedColumn<String> bloodGroup = GeneratedColumn<String>(
    'blood_group',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _otherContactMeta = const VerificationMeta(
    'otherContact',
  );
  @override
  late final GeneratedColumn<String> otherContact = GeneratedColumn<String>(
    'other_contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phoneNumber,
    age,
    bloodGroup,
    gender,
    otherContact,
    address,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Patient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('blood_group')) {
      context.handle(
        _bloodGroupMeta,
        bloodGroup.isAcceptableOrUnknown(data['blood_group']!, _bloodGroupMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('other_contact')) {
      context.handle(
        _otherContactMeta,
        otherContact.isAcceptableOrUnknown(
          data['other_contact']!,
          _otherContactMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Patient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Patient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      bloodGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blood_group'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      otherContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_contact'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class Patient extends DataClass implements Insertable<Patient> {
  final String id;
  final String name;
  final String? phoneNumber;
  final int? age;
  final String? bloodGroup;
  final String? gender;
  final String? otherContact;
  final String? address;
  const Patient({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.age,
    this.bloodGroup,
    this.gender,
    this.otherContact,
    this.address,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || bloodGroup != null) {
      map['blood_group'] = Variable<String>(bloodGroup);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || otherContact != null) {
      map['other_contact'] = Variable<String>(otherContact);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      id: Value(id),
      name: Value(name),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      bloodGroup: bloodGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodGroup),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      otherContact: otherContact == null && nullToAbsent
          ? const Value.absent()
          : Value(otherContact),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
    );
  }

  factory Patient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Patient(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      age: serializer.fromJson<int?>(json['age']),
      bloodGroup: serializer.fromJson<String?>(json['bloodGroup']),
      gender: serializer.fromJson<String?>(json['gender']),
      otherContact: serializer.fromJson<String?>(json['otherContact']),
      address: serializer.fromJson<String?>(json['address']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'age': serializer.toJson<int?>(age),
      'bloodGroup': serializer.toJson<String?>(bloodGroup),
      'gender': serializer.toJson<String?>(gender),
      'otherContact': serializer.toJson<String?>(otherContact),
      'address': serializer.toJson<String?>(address),
    };
  }

  Patient copyWith({
    String? id,
    String? name,
    Value<String?> phoneNumber = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<String?> bloodGroup = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> otherContact = const Value.absent(),
    Value<String?> address = const Value.absent(),
  }) => Patient(
    id: id ?? this.id,
    name: name ?? this.name,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    age: age.present ? age.value : this.age,
    bloodGroup: bloodGroup.present ? bloodGroup.value : this.bloodGroup,
    gender: gender.present ? gender.value : this.gender,
    otherContact: otherContact.present ? otherContact.value : this.otherContact,
    address: address.present ? address.value : this.address,
  );
  Patient copyWithCompanion(PatientsCompanion data) {
    return Patient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      age: data.age.present ? data.age.value : this.age,
      bloodGroup: data.bloodGroup.present
          ? data.bloodGroup.value
          : this.bloodGroup,
      gender: data.gender.present ? data.gender.value : this.gender,
      otherContact: data.otherContact.present
          ? data.otherContact.value
          : this.otherContact,
      address: data.address.present ? data.address.value : this.address,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Patient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('age: $age, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('gender: $gender, ')
          ..write('otherContact: $otherContact, ')
          ..write('address: $address')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phoneNumber,
    age,
    bloodGroup,
    gender,
    otherContact,
    address,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Patient &&
          other.id == this.id &&
          other.name == this.name &&
          other.phoneNumber == this.phoneNumber &&
          other.age == this.age &&
          other.bloodGroup == this.bloodGroup &&
          other.gender == this.gender &&
          other.otherContact == this.otherContact &&
          other.address == this.address);
}

class PatientsCompanion extends UpdateCompanion<Patient> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> phoneNumber;
  final Value<int?> age;
  final Value<String?> bloodGroup;
  final Value<String?> gender;
  final Value<String?> otherContact;
  final Value<String?> address;
  final Value<int> rowid;
  const PatientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.age = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.gender = const Value.absent(),
    this.otherContact = const Value.absent(),
    this.address = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientsCompanion.insert({
    required String id,
    required String name,
    this.phoneNumber = const Value.absent(),
    this.age = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.gender = const Value.absent(),
    this.otherContact = const Value.absent(),
    this.address = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Patient> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phoneNumber,
    Expression<int>? age,
    Expression<String>? bloodGroup,
    Expression<String>? gender,
    Expression<String>? otherContact,
    Expression<String>? address,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (age != null) 'age': age,
      if (bloodGroup != null) 'blood_group': bloodGroup,
      if (gender != null) 'gender': gender,
      if (otherContact != null) 'other_contact': otherContact,
      if (address != null) 'address': address,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? phoneNumber,
    Value<int?>? age,
    Value<String?>? bloodGroup,
    Value<String?>? gender,
    Value<String?>? otherContact,
    Value<String?>? address,
    Value<int>? rowid,
  }) {
    return PatientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      gender: gender ?? this.gender,
      otherContact: otherContact ?? this.otherContact,
      address: address ?? this.address,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (bloodGroup.present) {
      map['blood_group'] = Variable<String>(bloodGroup.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (otherContact.present) {
      map['other_contact'] = Variable<String>(otherContact.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('age: $age, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('gender: $gender, ')
          ..write('otherContact: $otherContact, ')
          ..write('address: $address, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreviousMedicalInformationsTable extends PreviousMedicalInformations
    with
        TableInfo<
          $PreviousMedicalInformationsTable,
          PreviousMedicalInformation
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreviousMedicalInformationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES patients (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOrPeriodMeta = const VerificationMeta(
    'dateOrPeriod',
  );
  @override
  late final GeneratedColumn<DateTime> dateOrPeriod = GeneratedColumn<DateTime>(
    'date_or_period',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    title,
    description,
    source,
    dateOrPeriod,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'previous_medical_informations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreviousMedicalInformation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('date_or_period')) {
      context.handle(
        _dateOrPeriodMeta,
        dateOrPeriod.isAcceptableOrUnknown(
          data['date_or_period']!,
          _dateOrPeriodMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreviousMedicalInformation map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreviousMedicalInformation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      dateOrPeriod: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_or_period'],
      ),
    );
  }

  @override
  $PreviousMedicalInformationsTable createAlias(String alias) {
    return $PreviousMedicalInformationsTable(attachedDatabase, alias);
  }
}

class PreviousMedicalInformation extends DataClass
    implements Insertable<PreviousMedicalInformation> {
  final String id;
  final String patientId;
  final String title;
  final String description;
  final String? source;
  final DateTime? dateOrPeriod;
  const PreviousMedicalInformation({
    required this.id,
    required this.patientId,
    required this.title,
    required this.description,
    this.source,
    this.dateOrPeriod,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || dateOrPeriod != null) {
      map['date_or_period'] = Variable<DateTime>(dateOrPeriod);
    }
    return map;
  }

  PreviousMedicalInformationsCompanion toCompanion(bool nullToAbsent) {
    return PreviousMedicalInformationsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      title: Value(title),
      description: Value(description),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      dateOrPeriod: dateOrPeriod == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOrPeriod),
    );
  }

  factory PreviousMedicalInformation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreviousMedicalInformation(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      source: serializer.fromJson<String?>(json['source']),
      dateOrPeriod: serializer.fromJson<DateTime?>(json['dateOrPeriod']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'source': serializer.toJson<String?>(source),
      'dateOrPeriod': serializer.toJson<DateTime?>(dateOrPeriod),
    };
  }

  PreviousMedicalInformation copyWith({
    String? id,
    String? patientId,
    String? title,
    String? description,
    Value<String?> source = const Value.absent(),
    Value<DateTime?> dateOrPeriod = const Value.absent(),
  }) => PreviousMedicalInformation(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    title: title ?? this.title,
    description: description ?? this.description,
    source: source.present ? source.value : this.source,
    dateOrPeriod: dateOrPeriod.present ? dateOrPeriod.value : this.dateOrPeriod,
  );
  PreviousMedicalInformation copyWithCompanion(
    PreviousMedicalInformationsCompanion data,
  ) {
    return PreviousMedicalInformation(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      source: data.source.present ? data.source.value : this.source,
      dateOrPeriod: data.dateOrPeriod.present
          ? data.dateOrPeriod.value
          : this.dateOrPeriod,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreviousMedicalInformation(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('source: $source, ')
          ..write('dateOrPeriod: $dateOrPeriod')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, patientId, title, description, source, dateOrPeriod);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreviousMedicalInformation &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.title == this.title &&
          other.description == this.description &&
          other.source == this.source &&
          other.dateOrPeriod == this.dateOrPeriod);
}

class PreviousMedicalInformationsCompanion
    extends UpdateCompanion<PreviousMedicalInformation> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> title;
  final Value<String> description;
  final Value<String?> source;
  final Value<DateTime?> dateOrPeriod;
  final Value<int> rowid;
  const PreviousMedicalInformationsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.source = const Value.absent(),
    this.dateOrPeriod = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreviousMedicalInformationsCompanion.insert({
    required String id,
    required String patientId,
    required String title,
    required String description,
    this.source = const Value.absent(),
    this.dateOrPeriod = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patientId = Value(patientId),
       title = Value(title),
       description = Value(description);
  static Insertable<PreviousMedicalInformation> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? source,
    Expression<DateTime>? dateOrPeriod,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (source != null) 'source': source,
      if (dateOrPeriod != null) 'date_or_period': dateOrPeriod,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreviousMedicalInformationsCompanion copyWith({
    Value<String>? id,
    Value<String>? patientId,
    Value<String>? title,
    Value<String>? description,
    Value<String?>? source,
    Value<DateTime?>? dateOrPeriod,
    Value<int>? rowid,
  }) {
    return PreviousMedicalInformationsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      title: title ?? this.title,
      description: description ?? this.description,
      source: source ?? this.source,
      dateOrPeriod: dateOrPeriod ?? this.dateOrPeriod,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (dateOrPeriod.present) {
      map['date_or_period'] = Variable<DateTime>(dateOrPeriod.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreviousMedicalInformationsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('source: $source, ')
          ..write('dateOrPeriod: $dateOrPeriod, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreviousMedicationsTable extends PreviousMedications
    with TableInfo<$PreviousMedicationsTable, PreviousMedication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreviousMedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES patients (id)',
    ),
  );
  static const VerificationMeta _medicineNameMeta = const VerificationMeta(
    'medicineName',
  );
  @override
  late final GeneratedColumn<String> medicineName = GeneratedColumn<String>(
    'medicine_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
    'dosage',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonOrConditionMeta = const VerificationMeta(
    'reasonOrCondition',
  );
  @override
  late final GeneratedColumn<String> reasonOrCondition =
      GeneratedColumn<String>(
        'reason_or_condition',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOrPeriodMeta = const VerificationMeta(
    'dateOrPeriod',
  );
  @override
  late final GeneratedColumn<DateTime> dateOrPeriod = GeneratedColumn<DateTime>(
    'date_or_period',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    medicineName,
    dosage,
    duration,
    reasonOrCondition,
    source,
    dateOrPeriod,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'previous_medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreviousMedication> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('medicine_name')) {
      context.handle(
        _medicineNameMeta,
        medicineName.isAcceptableOrUnknown(
          data['medicine_name']!,
          _medicineNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicineNameMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('reason_or_condition')) {
      context.handle(
        _reasonOrConditionMeta,
        reasonOrCondition.isAcceptableOrUnknown(
          data['reason_or_condition']!,
          _reasonOrConditionMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('date_or_period')) {
      context.handle(
        _dateOrPeriodMeta,
        dateOrPeriod.isAcceptableOrUnknown(
          data['date_or_period']!,
          _dateOrPeriodMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreviousMedication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreviousMedication(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      )!,
      medicineName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medicine_name'],
      )!,
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration'],
      ),
      reasonOrCondition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_or_condition'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      dateOrPeriod: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_or_period'],
      ),
    );
  }

  @override
  $PreviousMedicationsTable createAlias(String alias) {
    return $PreviousMedicationsTable(attachedDatabase, alias);
  }
}

class PreviousMedication extends DataClass
    implements Insertable<PreviousMedication> {
  final String id;
  final String patientId;
  final String medicineName;
  final String? dosage;
  final String? duration;
  final String? reasonOrCondition;
  final String? source;
  final DateTime? dateOrPeriod;
  const PreviousMedication({
    required this.id,
    required this.patientId,
    required this.medicineName,
    this.dosage,
    this.duration,
    this.reasonOrCondition,
    this.source,
    this.dateOrPeriod,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['medicine_name'] = Variable<String>(medicineName);
    if (!nullToAbsent || dosage != null) {
      map['dosage'] = Variable<String>(dosage);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<String>(duration);
    }
    if (!nullToAbsent || reasonOrCondition != null) {
      map['reason_or_condition'] = Variable<String>(reasonOrCondition);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || dateOrPeriod != null) {
      map['date_or_period'] = Variable<DateTime>(dateOrPeriod);
    }
    return map;
  }

  PreviousMedicationsCompanion toCompanion(bool nullToAbsent) {
    return PreviousMedicationsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      medicineName: Value(medicineName),
      dosage: dosage == null && nullToAbsent
          ? const Value.absent()
          : Value(dosage),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      reasonOrCondition: reasonOrCondition == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonOrCondition),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      dateOrPeriod: dateOrPeriod == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOrPeriod),
    );
  }

  factory PreviousMedication.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreviousMedication(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      medicineName: serializer.fromJson<String>(json['medicineName']),
      dosage: serializer.fromJson<String?>(json['dosage']),
      duration: serializer.fromJson<String?>(json['duration']),
      reasonOrCondition: serializer.fromJson<String?>(
        json['reasonOrCondition'],
      ),
      source: serializer.fromJson<String?>(json['source']),
      dateOrPeriod: serializer.fromJson<DateTime?>(json['dateOrPeriod']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'medicineName': serializer.toJson<String>(medicineName),
      'dosage': serializer.toJson<String?>(dosage),
      'duration': serializer.toJson<String?>(duration),
      'reasonOrCondition': serializer.toJson<String?>(reasonOrCondition),
      'source': serializer.toJson<String?>(source),
      'dateOrPeriod': serializer.toJson<DateTime?>(dateOrPeriod),
    };
  }

  PreviousMedication copyWith({
    String? id,
    String? patientId,
    String? medicineName,
    Value<String?> dosage = const Value.absent(),
    Value<String?> duration = const Value.absent(),
    Value<String?> reasonOrCondition = const Value.absent(),
    Value<String?> source = const Value.absent(),
    Value<DateTime?> dateOrPeriod = const Value.absent(),
  }) => PreviousMedication(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    medicineName: medicineName ?? this.medicineName,
    dosage: dosage.present ? dosage.value : this.dosage,
    duration: duration.present ? duration.value : this.duration,
    reasonOrCondition: reasonOrCondition.present
        ? reasonOrCondition.value
        : this.reasonOrCondition,
    source: source.present ? source.value : this.source,
    dateOrPeriod: dateOrPeriod.present ? dateOrPeriod.value : this.dateOrPeriod,
  );
  PreviousMedication copyWithCompanion(PreviousMedicationsCompanion data) {
    return PreviousMedication(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      medicineName: data.medicineName.present
          ? data.medicineName.value
          : this.medicineName,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      duration: data.duration.present ? data.duration.value : this.duration,
      reasonOrCondition: data.reasonOrCondition.present
          ? data.reasonOrCondition.value
          : this.reasonOrCondition,
      source: data.source.present ? data.source.value : this.source,
      dateOrPeriod: data.dateOrPeriod.present
          ? data.dateOrPeriod.value
          : this.dateOrPeriod,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreviousMedication(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('medicineName: $medicineName, ')
          ..write('dosage: $dosage, ')
          ..write('duration: $duration, ')
          ..write('reasonOrCondition: $reasonOrCondition, ')
          ..write('source: $source, ')
          ..write('dateOrPeriod: $dateOrPeriod')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    medicineName,
    dosage,
    duration,
    reasonOrCondition,
    source,
    dateOrPeriod,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreviousMedication &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.medicineName == this.medicineName &&
          other.dosage == this.dosage &&
          other.duration == this.duration &&
          other.reasonOrCondition == this.reasonOrCondition &&
          other.source == this.source &&
          other.dateOrPeriod == this.dateOrPeriod);
}

class PreviousMedicationsCompanion extends UpdateCompanion<PreviousMedication> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> medicineName;
  final Value<String?> dosage;
  final Value<String?> duration;
  final Value<String?> reasonOrCondition;
  final Value<String?> source;
  final Value<DateTime?> dateOrPeriod;
  final Value<int> rowid;
  const PreviousMedicationsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.medicineName = const Value.absent(),
    this.dosage = const Value.absent(),
    this.duration = const Value.absent(),
    this.reasonOrCondition = const Value.absent(),
    this.source = const Value.absent(),
    this.dateOrPeriod = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreviousMedicationsCompanion.insert({
    required String id,
    required String patientId,
    required String medicineName,
    this.dosage = const Value.absent(),
    this.duration = const Value.absent(),
    this.reasonOrCondition = const Value.absent(),
    this.source = const Value.absent(),
    this.dateOrPeriod = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patientId = Value(patientId),
       medicineName = Value(medicineName);
  static Insertable<PreviousMedication> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? medicineName,
    Expression<String>? dosage,
    Expression<String>? duration,
    Expression<String>? reasonOrCondition,
    Expression<String>? source,
    Expression<DateTime>? dateOrPeriod,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (medicineName != null) 'medicine_name': medicineName,
      if (dosage != null) 'dosage': dosage,
      if (duration != null) 'duration': duration,
      if (reasonOrCondition != null) 'reason_or_condition': reasonOrCondition,
      if (source != null) 'source': source,
      if (dateOrPeriod != null) 'date_or_period': dateOrPeriod,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreviousMedicationsCompanion copyWith({
    Value<String>? id,
    Value<String>? patientId,
    Value<String>? medicineName,
    Value<String?>? dosage,
    Value<String?>? duration,
    Value<String?>? reasonOrCondition,
    Value<String?>? source,
    Value<DateTime?>? dateOrPeriod,
    Value<int>? rowid,
  }) {
    return PreviousMedicationsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      duration: duration ?? this.duration,
      reasonOrCondition: reasonOrCondition ?? this.reasonOrCondition,
      source: source ?? this.source,
      dateOrPeriod: dateOrPeriod ?? this.dateOrPeriod,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (medicineName.present) {
      map['medicine_name'] = Variable<String>(medicineName.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (reasonOrCondition.present) {
      map['reason_or_condition'] = Variable<String>(reasonOrCondition.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (dateOrPeriod.present) {
      map['date_or_period'] = Variable<DateTime>(dateOrPeriod.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreviousMedicationsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('medicineName: $medicineName, ')
          ..write('dosage: $dosage, ')
          ..write('duration: $duration, ')
          ..write('reasonOrCondition: $reasonOrCondition, ')
          ..write('source: $source, ')
          ..write('dateOrPeriod: $dateOrPeriod, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreviousTestResultsTable extends PreviousTestResults
    with TableInfo<$PreviousTestResultsTable, PreviousTestResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreviousTestResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES patients (id)',
    ),
  );
  static const VerificationMeta _testNameMeta = const VerificationMeta(
    'testName',
  );
  @override
  late final GeneratedColumn<String> testName = GeneratedColumn<String>(
    'test_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateTakenMeta = const VerificationMeta(
    'dateTaken',
  );
  @override
  late final GeneratedColumn<DateTime> dateTaken = GeneratedColumn<DateTime>(
    'date_taken',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hospitalOrClinicMeta = const VerificationMeta(
    'hospitalOrClinic',
  );
  @override
  late final GeneratedColumn<String> hospitalOrClinic = GeneratedColumn<String>(
    'hospital_or_clinic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keyFindingsMeta = const VerificationMeta(
    'keyFindings',
  );
  @override
  late final GeneratedColumn<String> keyFindings = GeneratedColumn<String>(
    'key_findings',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    testName,
    category,
    dateTaken,
    hospitalOrClinic,
    summary,
    keyFindings,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'previous_test_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreviousTestResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('test_name')) {
      context.handle(
        _testNameMeta,
        testName.isAcceptableOrUnknown(data['test_name']!, _testNameMeta),
      );
    } else if (isInserting) {
      context.missing(_testNameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('date_taken')) {
      context.handle(
        _dateTakenMeta,
        dateTaken.isAcceptableOrUnknown(data['date_taken']!, _dateTakenMeta),
      );
    }
    if (data.containsKey('hospital_or_clinic')) {
      context.handle(
        _hospitalOrClinicMeta,
        hospitalOrClinic.isAcceptableOrUnknown(
          data['hospital_or_clinic']!,
          _hospitalOrClinicMeta,
        ),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('key_findings')) {
      context.handle(
        _keyFindingsMeta,
        keyFindings.isAcceptableOrUnknown(
          data['key_findings']!,
          _keyFindingsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreviousTestResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreviousTestResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      )!,
      testName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}test_name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      dateTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_taken'],
      ),
      hospitalOrClinic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hospital_or_clinic'],
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      keyFindings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_findings'],
      ),
    );
  }

  @override
  $PreviousTestResultsTable createAlias(String alias) {
    return $PreviousTestResultsTable(attachedDatabase, alias);
  }
}

class PreviousTestResult extends DataClass
    implements Insertable<PreviousTestResult> {
  final String id;
  final String patientId;
  final String testName;
  final String? category;
  final DateTime? dateTaken;
  final String? hospitalOrClinic;
  final String? summary;
  final String? keyFindings;
  const PreviousTestResult({
    required this.id,
    required this.patientId,
    required this.testName,
    this.category,
    this.dateTaken,
    this.hospitalOrClinic,
    this.summary,
    this.keyFindings,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['test_name'] = Variable<String>(testName);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || dateTaken != null) {
      map['date_taken'] = Variable<DateTime>(dateTaken);
    }
    if (!nullToAbsent || hospitalOrClinic != null) {
      map['hospital_or_clinic'] = Variable<String>(hospitalOrClinic);
    }
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || keyFindings != null) {
      map['key_findings'] = Variable<String>(keyFindings);
    }
    return map;
  }

  PreviousTestResultsCompanion toCompanion(bool nullToAbsent) {
    return PreviousTestResultsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      testName: Value(testName),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      dateTaken: dateTaken == null && nullToAbsent
          ? const Value.absent()
          : Value(dateTaken),
      hospitalOrClinic: hospitalOrClinic == null && nullToAbsent
          ? const Value.absent()
          : Value(hospitalOrClinic),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      keyFindings: keyFindings == null && nullToAbsent
          ? const Value.absent()
          : Value(keyFindings),
    );
  }

  factory PreviousTestResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreviousTestResult(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      testName: serializer.fromJson<String>(json['testName']),
      category: serializer.fromJson<String?>(json['category']),
      dateTaken: serializer.fromJson<DateTime?>(json['dateTaken']),
      hospitalOrClinic: serializer.fromJson<String?>(json['hospitalOrClinic']),
      summary: serializer.fromJson<String?>(json['summary']),
      keyFindings: serializer.fromJson<String?>(json['keyFindings']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'testName': serializer.toJson<String>(testName),
      'category': serializer.toJson<String?>(category),
      'dateTaken': serializer.toJson<DateTime?>(dateTaken),
      'hospitalOrClinic': serializer.toJson<String?>(hospitalOrClinic),
      'summary': serializer.toJson<String?>(summary),
      'keyFindings': serializer.toJson<String?>(keyFindings),
    };
  }

  PreviousTestResult copyWith({
    String? id,
    String? patientId,
    String? testName,
    Value<String?> category = const Value.absent(),
    Value<DateTime?> dateTaken = const Value.absent(),
    Value<String?> hospitalOrClinic = const Value.absent(),
    Value<String?> summary = const Value.absent(),
    Value<String?> keyFindings = const Value.absent(),
  }) => PreviousTestResult(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    testName: testName ?? this.testName,
    category: category.present ? category.value : this.category,
    dateTaken: dateTaken.present ? dateTaken.value : this.dateTaken,
    hospitalOrClinic: hospitalOrClinic.present
        ? hospitalOrClinic.value
        : this.hospitalOrClinic,
    summary: summary.present ? summary.value : this.summary,
    keyFindings: keyFindings.present ? keyFindings.value : this.keyFindings,
  );
  PreviousTestResult copyWithCompanion(PreviousTestResultsCompanion data) {
    return PreviousTestResult(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      testName: data.testName.present ? data.testName.value : this.testName,
      category: data.category.present ? data.category.value : this.category,
      dateTaken: data.dateTaken.present ? data.dateTaken.value : this.dateTaken,
      hospitalOrClinic: data.hospitalOrClinic.present
          ? data.hospitalOrClinic.value
          : this.hospitalOrClinic,
      summary: data.summary.present ? data.summary.value : this.summary,
      keyFindings: data.keyFindings.present
          ? data.keyFindings.value
          : this.keyFindings,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreviousTestResult(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('testName: $testName, ')
          ..write('category: $category, ')
          ..write('dateTaken: $dateTaken, ')
          ..write('hospitalOrClinic: $hospitalOrClinic, ')
          ..write('summary: $summary, ')
          ..write('keyFindings: $keyFindings')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    testName,
    category,
    dateTaken,
    hospitalOrClinic,
    summary,
    keyFindings,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreviousTestResult &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.testName == this.testName &&
          other.category == this.category &&
          other.dateTaken == this.dateTaken &&
          other.hospitalOrClinic == this.hospitalOrClinic &&
          other.summary == this.summary &&
          other.keyFindings == this.keyFindings);
}

class PreviousTestResultsCompanion extends UpdateCompanion<PreviousTestResult> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> testName;
  final Value<String?> category;
  final Value<DateTime?> dateTaken;
  final Value<String?> hospitalOrClinic;
  final Value<String?> summary;
  final Value<String?> keyFindings;
  final Value<int> rowid;
  const PreviousTestResultsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.testName = const Value.absent(),
    this.category = const Value.absent(),
    this.dateTaken = const Value.absent(),
    this.hospitalOrClinic = const Value.absent(),
    this.summary = const Value.absent(),
    this.keyFindings = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreviousTestResultsCompanion.insert({
    required String id,
    required String patientId,
    required String testName,
    this.category = const Value.absent(),
    this.dateTaken = const Value.absent(),
    this.hospitalOrClinic = const Value.absent(),
    this.summary = const Value.absent(),
    this.keyFindings = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patientId = Value(patientId),
       testName = Value(testName);
  static Insertable<PreviousTestResult> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? testName,
    Expression<String>? category,
    Expression<DateTime>? dateTaken,
    Expression<String>? hospitalOrClinic,
    Expression<String>? summary,
    Expression<String>? keyFindings,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (testName != null) 'test_name': testName,
      if (category != null) 'category': category,
      if (dateTaken != null) 'date_taken': dateTaken,
      if (hospitalOrClinic != null) 'hospital_or_clinic': hospitalOrClinic,
      if (summary != null) 'summary': summary,
      if (keyFindings != null) 'key_findings': keyFindings,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreviousTestResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? patientId,
    Value<String>? testName,
    Value<String?>? category,
    Value<DateTime?>? dateTaken,
    Value<String?>? hospitalOrClinic,
    Value<String?>? summary,
    Value<String?>? keyFindings,
    Value<int>? rowid,
  }) {
    return PreviousTestResultsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      testName: testName ?? this.testName,
      category: category ?? this.category,
      dateTaken: dateTaken ?? this.dateTaken,
      hospitalOrClinic: hospitalOrClinic ?? this.hospitalOrClinic,
      summary: summary ?? this.summary,
      keyFindings: keyFindings ?? this.keyFindings,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (testName.present) {
      map['test_name'] = Variable<String>(testName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (dateTaken.present) {
      map['date_taken'] = Variable<DateTime>(dateTaken.value);
    }
    if (hospitalOrClinic.present) {
      map['hospital_or_clinic'] = Variable<String>(hospitalOrClinic.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (keyFindings.present) {
      map['key_findings'] = Variable<String>(keyFindings.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreviousTestResultsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('testName: $testName, ')
          ..write('category: $category, ')
          ..write('dateTaken: $dateTaken, ')
          ..write('hospitalOrClinic: $hospitalOrClinic, ')
          ..write('summary: $summary, ')
          ..write('keyFindings: $keyFindings, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExaminationsTable extends Examinations
    with TableInfo<$ExaminationsTable, Examination> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExaminationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES patients (id)',
    ),
  );
  static const VerificationMeta _examinationTypeMeta = const VerificationMeta(
    'examinationType',
  );
  @override
  late final GeneratedColumn<String> examinationType = GeneratedColumn<String>(
    'examination_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examinationDateMeta = const VerificationMeta(
    'examinationDate',
  );
  @override
  late final GeneratedColumn<DateTime> examinationDate =
      GeneratedColumn<DateTime>(
        'examination_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _doctorNotesMeta = const VerificationMeta(
    'doctorNotes',
  );
  @override
  late final GeneratedColumn<String> doctorNotes = GeneratedColumn<String>(
    'doctor_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _previousDataRangeMeta = const VerificationMeta(
    'previousDataRange',
  );
  @override
  late final GeneratedColumn<String> previousDataRange =
      GeneratedColumn<String>(
        'previous_data_range',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    examinationType,
    examinationDate,
    doctorNotes,
    previousDataRange,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'examinations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Examination> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('examination_type')) {
      context.handle(
        _examinationTypeMeta,
        examinationType.isAcceptableOrUnknown(
          data['examination_type']!,
          _examinationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationTypeMeta);
    }
    if (data.containsKey('examination_date')) {
      context.handle(
        _examinationDateMeta,
        examinationDate.isAcceptableOrUnknown(
          data['examination_date']!,
          _examinationDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationDateMeta);
    }
    if (data.containsKey('doctor_notes')) {
      context.handle(
        _doctorNotesMeta,
        doctorNotes.isAcceptableOrUnknown(
          data['doctor_notes']!,
          _doctorNotesMeta,
        ),
      );
    }
    if (data.containsKey('previous_data_range')) {
      context.handle(
        _previousDataRangeMeta,
        previousDataRange.isAcceptableOrUnknown(
          data['previous_data_range']!,
          _previousDataRangeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousDataRangeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Examination map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Examination(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      )!,
      examinationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examination_type'],
      )!,
      examinationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}examination_date'],
      )!,
      doctorNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_notes'],
      ),
      previousDataRange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_data_range'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $ExaminationsTable createAlias(String alias) {
    return $ExaminationsTable(attachedDatabase, alias);
  }
}

class Examination extends DataClass implements Insertable<Examination> {
  final String id;
  final String patientId;
  final String examinationType;
  final DateTime examinationDate;
  final String? doctorNotes;
  final String previousDataRange;
  final String status;
  const Examination({
    required this.id,
    required this.patientId,
    required this.examinationType,
    required this.examinationDate,
    this.doctorNotes,
    required this.previousDataRange,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['examination_type'] = Variable<String>(examinationType);
    map['examination_date'] = Variable<DateTime>(examinationDate);
    if (!nullToAbsent || doctorNotes != null) {
      map['doctor_notes'] = Variable<String>(doctorNotes);
    }
    map['previous_data_range'] = Variable<String>(previousDataRange);
    map['status'] = Variable<String>(status);
    return map;
  }

  ExaminationsCompanion toCompanion(bool nullToAbsent) {
    return ExaminationsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      examinationType: Value(examinationType),
      examinationDate: Value(examinationDate),
      doctorNotes: doctorNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorNotes),
      previousDataRange: Value(previousDataRange),
      status: Value(status),
    );
  }

  factory Examination.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Examination(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      examinationType: serializer.fromJson<String>(json['examinationType']),
      examinationDate: serializer.fromJson<DateTime>(json['examinationDate']),
      doctorNotes: serializer.fromJson<String?>(json['doctorNotes']),
      previousDataRange: serializer.fromJson<String>(json['previousDataRange']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'examinationType': serializer.toJson<String>(examinationType),
      'examinationDate': serializer.toJson<DateTime>(examinationDate),
      'doctorNotes': serializer.toJson<String?>(doctorNotes),
      'previousDataRange': serializer.toJson<String>(previousDataRange),
      'status': serializer.toJson<String>(status),
    };
  }

  Examination copyWith({
    String? id,
    String? patientId,
    String? examinationType,
    DateTime? examinationDate,
    Value<String?> doctorNotes = const Value.absent(),
    String? previousDataRange,
    String? status,
  }) => Examination(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    examinationType: examinationType ?? this.examinationType,
    examinationDate: examinationDate ?? this.examinationDate,
    doctorNotes: doctorNotes.present ? doctorNotes.value : this.doctorNotes,
    previousDataRange: previousDataRange ?? this.previousDataRange,
    status: status ?? this.status,
  );
  Examination copyWithCompanion(ExaminationsCompanion data) {
    return Examination(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      examinationType: data.examinationType.present
          ? data.examinationType.value
          : this.examinationType,
      examinationDate: data.examinationDate.present
          ? data.examinationDate.value
          : this.examinationDate,
      doctorNotes: data.doctorNotes.present
          ? data.doctorNotes.value
          : this.doctorNotes,
      previousDataRange: data.previousDataRange.present
          ? data.previousDataRange.value
          : this.previousDataRange,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Examination(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('examinationType: $examinationType, ')
          ..write('examinationDate: $examinationDate, ')
          ..write('doctorNotes: $doctorNotes, ')
          ..write('previousDataRange: $previousDataRange, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    examinationType,
    examinationDate,
    doctorNotes,
    previousDataRange,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Examination &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.examinationType == this.examinationType &&
          other.examinationDate == this.examinationDate &&
          other.doctorNotes == this.doctorNotes &&
          other.previousDataRange == this.previousDataRange &&
          other.status == this.status);
}

class ExaminationsCompanion extends UpdateCompanion<Examination> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> examinationType;
  final Value<DateTime> examinationDate;
  final Value<String?> doctorNotes;
  final Value<String> previousDataRange;
  final Value<String> status;
  final Value<int> rowid;
  const ExaminationsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.examinationType = const Value.absent(),
    this.examinationDate = const Value.absent(),
    this.doctorNotes = const Value.absent(),
    this.previousDataRange = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExaminationsCompanion.insert({
    required String id,
    required String patientId,
    required String examinationType,
    required DateTime examinationDate,
    this.doctorNotes = const Value.absent(),
    required String previousDataRange,
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       patientId = Value(patientId),
       examinationType = Value(examinationType),
       examinationDate = Value(examinationDate),
       previousDataRange = Value(previousDataRange),
       status = Value(status);
  static Insertable<Examination> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? examinationType,
    Expression<DateTime>? examinationDate,
    Expression<String>? doctorNotes,
    Expression<String>? previousDataRange,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (examinationType != null) 'examination_type': examinationType,
      if (examinationDate != null) 'examination_date': examinationDate,
      if (doctorNotes != null) 'doctor_notes': doctorNotes,
      if (previousDataRange != null) 'previous_data_range': previousDataRange,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExaminationsCompanion copyWith({
    Value<String>? id,
    Value<String>? patientId,
    Value<String>? examinationType,
    Value<DateTime>? examinationDate,
    Value<String?>? doctorNotes,
    Value<String>? previousDataRange,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return ExaminationsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      examinationType: examinationType ?? this.examinationType,
      examinationDate: examinationDate ?? this.examinationDate,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      previousDataRange: previousDataRange ?? this.previousDataRange,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (examinationType.present) {
      map['examination_type'] = Variable<String>(examinationType.value);
    }
    if (examinationDate.present) {
      map['examination_date'] = Variable<DateTime>(examinationDate.value);
    }
    if (doctorNotes.present) {
      map['doctor_notes'] = Variable<String>(doctorNotes.value);
    }
    if (previousDataRange.present) {
      map['previous_data_range'] = Variable<String>(previousDataRange.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExaminationsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('examinationType: $examinationType, ')
          ..write('examinationDate: $examinationDate, ')
          ..write('doctorNotes: $doctorNotes, ')
          ..write('previousDataRange: $previousDataRange, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicalImagesTable extends MedicalImages
    with TableInfo<$MedicalImagesTable, MedicalImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examinationIdMeta = const VerificationMeta(
    'examinationId',
  );
  @override
  late final GeneratedColumn<String> examinationId = GeneratedColumn<String>(
    'examination_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES examinations (id)',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalFileNameMeta = const VerificationMeta(
    'originalFileName',
  );
  @override
  late final GeneratedColumn<String> originalFileName = GeneratedColumn<String>(
    'original_file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileFormatMeta = const VerificationMeta(
    'fileFormat',
  );
  @override
  late final GeneratedColumn<String> fileFormat = GeneratedColumn<String>(
    'file_format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modalityMeta = const VerificationMeta(
    'modality',
  );
  @override
  late final GeneratedColumn<String> modality = GeneratedColumn<String>(
    'modality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clinicalDateMeta = const VerificationMeta(
    'clinicalDate',
  );
  @override
  late final GeneratedColumn<DateTime> clinicalDate = GeneratedColumn<DateTime>(
    'clinical_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examinationId,
    filePath,
    originalFileName,
    fileFormat,
    modality,
    clinicalDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('examination_id')) {
      context.handle(
        _examinationIdMeta,
        examinationId.isAcceptableOrUnknown(
          data['examination_id']!,
          _examinationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('original_file_name')) {
      context.handle(
        _originalFileNameMeta,
        originalFileName.isAcceptableOrUnknown(
          data['original_file_name']!,
          _originalFileNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalFileNameMeta);
    }
    if (data.containsKey('file_format')) {
      context.handle(
        _fileFormatMeta,
        fileFormat.isAcceptableOrUnknown(data['file_format']!, _fileFormatMeta),
      );
    } else if (isInserting) {
      context.missing(_fileFormatMeta);
    }
    if (data.containsKey('modality')) {
      context.handle(
        _modalityMeta,
        modality.isAcceptableOrUnknown(data['modality']!, _modalityMeta),
      );
    } else if (isInserting) {
      context.missing(_modalityMeta);
    }
    if (data.containsKey('clinical_date')) {
      context.handle(
        _clinicalDateMeta,
        clinicalDate.isAcceptableOrUnknown(
          data['clinical_date']!,
          _clinicalDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clinicalDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicalImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      examinationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examination_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      originalFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_file_name'],
      )!,
      fileFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_format'],
      )!,
      modality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modality'],
      )!,
      clinicalDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}clinical_date'],
      )!,
    );
  }

  @override
  $MedicalImagesTable createAlias(String alias) {
    return $MedicalImagesTable(attachedDatabase, alias);
  }
}

class MedicalImage extends DataClass implements Insertable<MedicalImage> {
  final String id;
  final String examinationId;
  final String filePath;
  final String originalFileName;
  final String fileFormat;
  final String modality;
  final DateTime clinicalDate;
  const MedicalImage({
    required this.id,
    required this.examinationId,
    required this.filePath,
    required this.originalFileName,
    required this.fileFormat,
    required this.modality,
    required this.clinicalDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['examination_id'] = Variable<String>(examinationId);
    map['file_path'] = Variable<String>(filePath);
    map['original_file_name'] = Variable<String>(originalFileName);
    map['file_format'] = Variable<String>(fileFormat);
    map['modality'] = Variable<String>(modality);
    map['clinical_date'] = Variable<DateTime>(clinicalDate);
    return map;
  }

  MedicalImagesCompanion toCompanion(bool nullToAbsent) {
    return MedicalImagesCompanion(
      id: Value(id),
      examinationId: Value(examinationId),
      filePath: Value(filePath),
      originalFileName: Value(originalFileName),
      fileFormat: Value(fileFormat),
      modality: Value(modality),
      clinicalDate: Value(clinicalDate),
    );
  }

  factory MedicalImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalImage(
      id: serializer.fromJson<String>(json['id']),
      examinationId: serializer.fromJson<String>(json['examinationId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      originalFileName: serializer.fromJson<String>(json['originalFileName']),
      fileFormat: serializer.fromJson<String>(json['fileFormat']),
      modality: serializer.fromJson<String>(json['modality']),
      clinicalDate: serializer.fromJson<DateTime>(json['clinicalDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examinationId': serializer.toJson<String>(examinationId),
      'filePath': serializer.toJson<String>(filePath),
      'originalFileName': serializer.toJson<String>(originalFileName),
      'fileFormat': serializer.toJson<String>(fileFormat),
      'modality': serializer.toJson<String>(modality),
      'clinicalDate': serializer.toJson<DateTime>(clinicalDate),
    };
  }

  MedicalImage copyWith({
    String? id,
    String? examinationId,
    String? filePath,
    String? originalFileName,
    String? fileFormat,
    String? modality,
    DateTime? clinicalDate,
  }) => MedicalImage(
    id: id ?? this.id,
    examinationId: examinationId ?? this.examinationId,
    filePath: filePath ?? this.filePath,
    originalFileName: originalFileName ?? this.originalFileName,
    fileFormat: fileFormat ?? this.fileFormat,
    modality: modality ?? this.modality,
    clinicalDate: clinicalDate ?? this.clinicalDate,
  );
  MedicalImage copyWithCompanion(MedicalImagesCompanion data) {
    return MedicalImage(
      id: data.id.present ? data.id.value : this.id,
      examinationId: data.examinationId.present
          ? data.examinationId.value
          : this.examinationId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      originalFileName: data.originalFileName.present
          ? data.originalFileName.value
          : this.originalFileName,
      fileFormat: data.fileFormat.present
          ? data.fileFormat.value
          : this.fileFormat,
      modality: data.modality.present ? data.modality.value : this.modality,
      clinicalDate: data.clinicalDate.present
          ? data.clinicalDate.value
          : this.clinicalDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalImage(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('filePath: $filePath, ')
          ..write('originalFileName: $originalFileName, ')
          ..write('fileFormat: $fileFormat, ')
          ..write('modality: $modality, ')
          ..write('clinicalDate: $clinicalDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examinationId,
    filePath,
    originalFileName,
    fileFormat,
    modality,
    clinicalDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalImage &&
          other.id == this.id &&
          other.examinationId == this.examinationId &&
          other.filePath == this.filePath &&
          other.originalFileName == this.originalFileName &&
          other.fileFormat == this.fileFormat &&
          other.modality == this.modality &&
          other.clinicalDate == this.clinicalDate);
}

class MedicalImagesCompanion extends UpdateCompanion<MedicalImage> {
  final Value<String> id;
  final Value<String> examinationId;
  final Value<String> filePath;
  final Value<String> originalFileName;
  final Value<String> fileFormat;
  final Value<String> modality;
  final Value<DateTime> clinicalDate;
  final Value<int> rowid;
  const MedicalImagesCompanion({
    this.id = const Value.absent(),
    this.examinationId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.originalFileName = const Value.absent(),
    this.fileFormat = const Value.absent(),
    this.modality = const Value.absent(),
    this.clinicalDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicalImagesCompanion.insert({
    required String id,
    required String examinationId,
    required String filePath,
    required String originalFileName,
    required String fileFormat,
    required String modality,
    required DateTime clinicalDate,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       examinationId = Value(examinationId),
       filePath = Value(filePath),
       originalFileName = Value(originalFileName),
       fileFormat = Value(fileFormat),
       modality = Value(modality),
       clinicalDate = Value(clinicalDate);
  static Insertable<MedicalImage> custom({
    Expression<String>? id,
    Expression<String>? examinationId,
    Expression<String>? filePath,
    Expression<String>? originalFileName,
    Expression<String>? fileFormat,
    Expression<String>? modality,
    Expression<DateTime>? clinicalDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examinationId != null) 'examination_id': examinationId,
      if (filePath != null) 'file_path': filePath,
      if (originalFileName != null) 'original_file_name': originalFileName,
      if (fileFormat != null) 'file_format': fileFormat,
      if (modality != null) 'modality': modality,
      if (clinicalDate != null) 'clinical_date': clinicalDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicalImagesCompanion copyWith({
    Value<String>? id,
    Value<String>? examinationId,
    Value<String>? filePath,
    Value<String>? originalFileName,
    Value<String>? fileFormat,
    Value<String>? modality,
    Value<DateTime>? clinicalDate,
    Value<int>? rowid,
  }) {
    return MedicalImagesCompanion(
      id: id ?? this.id,
      examinationId: examinationId ?? this.examinationId,
      filePath: filePath ?? this.filePath,
      originalFileName: originalFileName ?? this.originalFileName,
      fileFormat: fileFormat ?? this.fileFormat,
      modality: modality ?? this.modality,
      clinicalDate: clinicalDate ?? this.clinicalDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examinationId.present) {
      map['examination_id'] = Variable<String>(examinationId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (originalFileName.present) {
      map['original_file_name'] = Variable<String>(originalFileName.value);
    }
    if (fileFormat.present) {
      map['file_format'] = Variable<String>(fileFormat.value);
    }
    if (modality.present) {
      map['modality'] = Variable<String>(modality.value);
    }
    if (clinicalDate.present) {
      map['clinical_date'] = Variable<DateTime>(clinicalDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalImagesCompanion(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('filePath: $filePath, ')
          ..write('originalFileName: $originalFileName, ')
          ..write('fileFormat: $fileFormat, ')
          ..write('modality: $modality, ')
          ..write('clinicalDate: $clinicalDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicalModelsTable extends MedicalModels
    with TableInfo<$MedicalModelsTable, MedicalModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalModelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskMeta = const VerificationMeta('task');
  @override
  late final GeneratedColumn<String> task = GeneratedColumn<String>(
    'task',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modalityMeta = const VerificationMeta(
    'modality',
  );
  @override
  late final GeneratedColumn<String> modality = GeneratedColumn<String>(
    'modality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _runtimeMeta = const VerificationMeta(
    'runtime',
  );
  @override
  late final GeneratedColumn<String> runtime = GeneratedColumn<String>(
    'runtime',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    task,
    modality,
    runtime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_models';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('task')) {
      context.handle(
        _taskMeta,
        task.isAcceptableOrUnknown(data['task']!, _taskMeta),
      );
    } else if (isInserting) {
      context.missing(_taskMeta);
    }
    if (data.containsKey('modality')) {
      context.handle(
        _modalityMeta,
        modality.isAcceptableOrUnknown(data['modality']!, _modalityMeta),
      );
    } else if (isInserting) {
      context.missing(_modalityMeta);
    }
    if (data.containsKey('runtime')) {
      context.handle(
        _runtimeMeta,
        runtime.isAcceptableOrUnknown(data['runtime']!, _runtimeMeta),
      );
    } else if (isInserting) {
      context.missing(_runtimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicalModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      task: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task'],
      )!,
      modality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modality'],
      )!,
      runtime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}runtime'],
      )!,
    );
  }

  @override
  $MedicalModelsTable createAlias(String alias) {
    return $MedicalModelsTable(attachedDatabase, alias);
  }
}

class MedicalModel extends DataClass implements Insertable<MedicalModel> {
  final String id;
  final String name;
  final String? description;
  final String task;
  final String modality;
  final String runtime;
  const MedicalModel({
    required this.id,
    required this.name,
    this.description,
    required this.task,
    required this.modality,
    required this.runtime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['task'] = Variable<String>(task);
    map['modality'] = Variable<String>(modality);
    map['runtime'] = Variable<String>(runtime);
    return map;
  }

  MedicalModelsCompanion toCompanion(bool nullToAbsent) {
    return MedicalModelsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      task: Value(task),
      modality: Value(modality),
      runtime: Value(runtime),
    );
  }

  factory MedicalModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalModel(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      task: serializer.fromJson<String>(json['task']),
      modality: serializer.fromJson<String>(json['modality']),
      runtime: serializer.fromJson<String>(json['runtime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'task': serializer.toJson<String>(task),
      'modality': serializer.toJson<String>(modality),
      'runtime': serializer.toJson<String>(runtime),
    };
  }

  MedicalModel copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? task,
    String? modality,
    String? runtime,
  }) => MedicalModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    task: task ?? this.task,
    modality: modality ?? this.modality,
    runtime: runtime ?? this.runtime,
  );
  MedicalModel copyWithCompanion(MedicalModelsCompanion data) {
    return MedicalModel(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      task: data.task.present ? data.task.value : this.task,
      modality: data.modality.present ? data.modality.value : this.modality,
      runtime: data.runtime.present ? data.runtime.value : this.runtime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalModel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('task: $task, ')
          ..write('modality: $modality, ')
          ..write('runtime: $runtime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, task, modality, runtime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalModel &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.task == this.task &&
          other.modality == this.modality &&
          other.runtime == this.runtime);
}

class MedicalModelsCompanion extends UpdateCompanion<MedicalModel> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> task;
  final Value<String> modality;
  final Value<String> runtime;
  final Value<int> rowid;
  const MedicalModelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.task = const Value.absent(),
    this.modality = const Value.absent(),
    this.runtime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicalModelsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String task,
    required String modality,
    required String runtime,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       task = Value(task),
       modality = Value(modality),
       runtime = Value(runtime);
  static Insertable<MedicalModel> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? task,
    Expression<String>? modality,
    Expression<String>? runtime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (task != null) 'task': task,
      if (modality != null) 'modality': modality,
      if (runtime != null) 'runtime': runtime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicalModelsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? task,
    Value<String>? modality,
    Value<String>? runtime,
    Value<int>? rowid,
  }) {
    return MedicalModelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      task: task ?? this.task,
      modality: modality ?? this.modality,
      runtime: runtime ?? this.runtime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (task.present) {
      map['task'] = Variable<String>(task.value);
    }
    if (modality.present) {
      map['modality'] = Variable<String>(modality.value);
    }
    if (runtime.present) {
      map['runtime'] = Variable<String>(runtime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalModelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('task: $task, ')
          ..write('modality: $modality, ')
          ..write('runtime: $runtime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModelVersionsTable extends ModelVersions
    with TableInfo<$ModelVersionsTable, ModelVersion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_models (id)',
    ),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checksumMeta = const VerificationMeta(
    'checksum',
  );
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
    'checksum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _compatibilityMeta = const VerificationMeta(
    'compatibility',
  );
  @override
  late final GeneratedColumn<String> compatibility = GeneratedColumn<String>(
    'compatibility',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _installationStatusMeta =
      const VerificationMeta('installationStatus');
  @override
  late final GeneratedColumn<String> installationStatus =
      GeneratedColumn<String>(
        'installation_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    modelId,
    version,
    filePath,
    checksum,
    compatibility,
    installationStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'model_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModelVersion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('checksum')) {
      context.handle(
        _checksumMeta,
        checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta),
      );
    } else if (isInserting) {
      context.missing(_checksumMeta);
    }
    if (data.containsKey('compatibility')) {
      context.handle(
        _compatibilityMeta,
        compatibility.isAcceptableOrUnknown(
          data['compatibility']!,
          _compatibilityMeta,
        ),
      );
    }
    if (data.containsKey('installation_status')) {
      context.handle(
        _installationStatusMeta,
        installationStatus.isAcceptableOrUnknown(
          data['installation_status']!,
          _installationStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installationStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModelVersion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModelVersion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      checksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum'],
      )!,
      compatibility: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}compatibility'],
      ),
      installationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}installation_status'],
      )!,
    );
  }

  @override
  $ModelVersionsTable createAlias(String alias) {
    return $ModelVersionsTable(attachedDatabase, alias);
  }
}

class ModelVersion extends DataClass implements Insertable<ModelVersion> {
  final String id;
  final String modelId;
  final String version;
  final String filePath;
  final String checksum;
  final String? compatibility;
  final String installationStatus;
  const ModelVersion({
    required this.id,
    required this.modelId,
    required this.version,
    required this.filePath,
    required this.checksum,
    this.compatibility,
    required this.installationStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['model_id'] = Variable<String>(modelId);
    map['version'] = Variable<String>(version);
    map['file_path'] = Variable<String>(filePath);
    map['checksum'] = Variable<String>(checksum);
    if (!nullToAbsent || compatibility != null) {
      map['compatibility'] = Variable<String>(compatibility);
    }
    map['installation_status'] = Variable<String>(installationStatus);
    return map;
  }

  ModelVersionsCompanion toCompanion(bool nullToAbsent) {
    return ModelVersionsCompanion(
      id: Value(id),
      modelId: Value(modelId),
      version: Value(version),
      filePath: Value(filePath),
      checksum: Value(checksum),
      compatibility: compatibility == null && nullToAbsent
          ? const Value.absent()
          : Value(compatibility),
      installationStatus: Value(installationStatus),
    );
  }

  factory ModelVersion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModelVersion(
      id: serializer.fromJson<String>(json['id']),
      modelId: serializer.fromJson<String>(json['modelId']),
      version: serializer.fromJson<String>(json['version']),
      filePath: serializer.fromJson<String>(json['filePath']),
      checksum: serializer.fromJson<String>(json['checksum']),
      compatibility: serializer.fromJson<String?>(json['compatibility']),
      installationStatus: serializer.fromJson<String>(
        json['installationStatus'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'modelId': serializer.toJson<String>(modelId),
      'version': serializer.toJson<String>(version),
      'filePath': serializer.toJson<String>(filePath),
      'checksum': serializer.toJson<String>(checksum),
      'compatibility': serializer.toJson<String?>(compatibility),
      'installationStatus': serializer.toJson<String>(installationStatus),
    };
  }

  ModelVersion copyWith({
    String? id,
    String? modelId,
    String? version,
    String? filePath,
    String? checksum,
    Value<String?> compatibility = const Value.absent(),
    String? installationStatus,
  }) => ModelVersion(
    id: id ?? this.id,
    modelId: modelId ?? this.modelId,
    version: version ?? this.version,
    filePath: filePath ?? this.filePath,
    checksum: checksum ?? this.checksum,
    compatibility: compatibility.present
        ? compatibility.value
        : this.compatibility,
    installationStatus: installationStatus ?? this.installationStatus,
  );
  ModelVersion copyWithCompanion(ModelVersionsCompanion data) {
    return ModelVersion(
      id: data.id.present ? data.id.value : this.id,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      version: data.version.present ? data.version.value : this.version,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      compatibility: data.compatibility.present
          ? data.compatibility.value
          : this.compatibility,
      installationStatus: data.installationStatus.present
          ? data.installationStatus.value
          : this.installationStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModelVersion(')
          ..write('id: $id, ')
          ..write('modelId: $modelId, ')
          ..write('version: $version, ')
          ..write('filePath: $filePath, ')
          ..write('checksum: $checksum, ')
          ..write('compatibility: $compatibility, ')
          ..write('installationStatus: $installationStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    modelId,
    version,
    filePath,
    checksum,
    compatibility,
    installationStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModelVersion &&
          other.id == this.id &&
          other.modelId == this.modelId &&
          other.version == this.version &&
          other.filePath == this.filePath &&
          other.checksum == this.checksum &&
          other.compatibility == this.compatibility &&
          other.installationStatus == this.installationStatus);
}

class ModelVersionsCompanion extends UpdateCompanion<ModelVersion> {
  final Value<String> id;
  final Value<String> modelId;
  final Value<String> version;
  final Value<String> filePath;
  final Value<String> checksum;
  final Value<String?> compatibility;
  final Value<String> installationStatus;
  final Value<int> rowid;
  const ModelVersionsCompanion({
    this.id = const Value.absent(),
    this.modelId = const Value.absent(),
    this.version = const Value.absent(),
    this.filePath = const Value.absent(),
    this.checksum = const Value.absent(),
    this.compatibility = const Value.absent(),
    this.installationStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModelVersionsCompanion.insert({
    required String id,
    required String modelId,
    required String version,
    required String filePath,
    required String checksum,
    this.compatibility = const Value.absent(),
    required String installationStatus,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       modelId = Value(modelId),
       version = Value(version),
       filePath = Value(filePath),
       checksum = Value(checksum),
       installationStatus = Value(installationStatus);
  static Insertable<ModelVersion> custom({
    Expression<String>? id,
    Expression<String>? modelId,
    Expression<String>? version,
    Expression<String>? filePath,
    Expression<String>? checksum,
    Expression<String>? compatibility,
    Expression<String>? installationStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modelId != null) 'model_id': modelId,
      if (version != null) 'version': version,
      if (filePath != null) 'file_path': filePath,
      if (checksum != null) 'checksum': checksum,
      if (compatibility != null) 'compatibility': compatibility,
      if (installationStatus != null) 'installation_status': installationStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModelVersionsCompanion copyWith({
    Value<String>? id,
    Value<String>? modelId,
    Value<String>? version,
    Value<String>? filePath,
    Value<String>? checksum,
    Value<String?>? compatibility,
    Value<String>? installationStatus,
    Value<int>? rowid,
  }) {
    return ModelVersionsCompanion(
      id: id ?? this.id,
      modelId: modelId ?? this.modelId,
      version: version ?? this.version,
      filePath: filePath ?? this.filePath,
      checksum: checksum ?? this.checksum,
      compatibility: compatibility ?? this.compatibility,
      installationStatus: installationStatus ?? this.installationStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (compatibility.present) {
      map['compatibility'] = Variable<String>(compatibility.value);
    }
    if (installationStatus.present) {
      map['installation_status'] = Variable<String>(installationStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelVersionsCompanion(')
          ..write('id: $id, ')
          ..write('modelId: $modelId, ')
          ..write('version: $version, ')
          ..write('filePath: $filePath, ')
          ..write('checksum: $checksum, ')
          ..write('compatibility: $compatibility, ')
          ..write('installationStatus: $installationStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModelRunsTable extends ModelRuns
    with TableInfo<$ModelRunsTable, ModelRun> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examinationIdMeta = const VerificationMeta(
    'examinationId',
  );
  @override
  late final GeneratedColumn<String> examinationId = GeneratedColumn<String>(
    'examination_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES examinations (id)',
    ),
  );
  static const VerificationMeta _modelIdMeta = const VerificationMeta(
    'modelId',
  );
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
    'model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_models (id)',
    ),
  );
  static const VerificationMeta _modelVersionIdMeta = const VerificationMeta(
    'modelVersionId',
  );
  @override
  late final GeneratedColumn<String> modelVersionId = GeneratedColumn<String>(
    'model_version_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES model_versions (id)',
    ),
  );
  static const VerificationMeta _inputImageIdMeta = const VerificationMeta(
    'inputImageId',
  );
  @override
  late final GeneratedColumn<String> inputImageId = GeneratedColumn<String>(
    'input_image_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_images (id)',
    ),
  );
  static const VerificationMeta _inputImageDateMeta = const VerificationMeta(
    'inputImageDate',
  );
  @override
  late final GeneratedColumn<DateTime> inputImageDate =
      GeneratedColumn<DateTime>(
        'input_image_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _executionTimestampMeta =
      const VerificationMeta('executionTimestamp');
  @override
  late final GeneratedColumn<DateTime> executionTimestamp =
      GeneratedColumn<DateTime>(
        'execution_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examinationId,
    modelId,
    modelVersionId,
    inputImageId,
    inputImageDate,
    executionTimestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'model_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModelRun> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('examination_id')) {
      context.handle(
        _examinationIdMeta,
        examinationId.isAcceptableOrUnknown(
          data['examination_id']!,
          _examinationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationIdMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(
        _modelIdMeta,
        modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('model_version_id')) {
      context.handle(
        _modelVersionIdMeta,
        modelVersionId.isAcceptableOrUnknown(
          data['model_version_id']!,
          _modelVersionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modelVersionIdMeta);
    }
    if (data.containsKey('input_image_id')) {
      context.handle(
        _inputImageIdMeta,
        inputImageId.isAcceptableOrUnknown(
          data['input_image_id']!,
          _inputImageIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inputImageIdMeta);
    }
    if (data.containsKey('input_image_date')) {
      context.handle(
        _inputImageDateMeta,
        inputImageDate.isAcceptableOrUnknown(
          data['input_image_date']!,
          _inputImageDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inputImageDateMeta);
    }
    if (data.containsKey('execution_timestamp')) {
      context.handle(
        _executionTimestampMeta,
        executionTimestamp.isAcceptableOrUnknown(
          data['execution_timestamp']!,
          _executionTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_executionTimestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModelRun map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModelRun(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      examinationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examination_id'],
      )!,
      modelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_id'],
      )!,
      modelVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_version_id'],
      )!,
      inputImageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_image_id'],
      )!,
      inputImageDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}input_image_date'],
      )!,
      executionTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}execution_timestamp'],
      )!,
    );
  }

  @override
  $ModelRunsTable createAlias(String alias) {
    return $ModelRunsTable(attachedDatabase, alias);
  }
}

class ModelRun extends DataClass implements Insertable<ModelRun> {
  final String id;
  final String examinationId;
  final String modelId;
  final String modelVersionId;
  final String inputImageId;
  final DateTime inputImageDate;
  final DateTime executionTimestamp;
  const ModelRun({
    required this.id,
    required this.examinationId,
    required this.modelId,
    required this.modelVersionId,
    required this.inputImageId,
    required this.inputImageDate,
    required this.executionTimestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['examination_id'] = Variable<String>(examinationId);
    map['model_id'] = Variable<String>(modelId);
    map['model_version_id'] = Variable<String>(modelVersionId);
    map['input_image_id'] = Variable<String>(inputImageId);
    map['input_image_date'] = Variable<DateTime>(inputImageDate);
    map['execution_timestamp'] = Variable<DateTime>(executionTimestamp);
    return map;
  }

  ModelRunsCompanion toCompanion(bool nullToAbsent) {
    return ModelRunsCompanion(
      id: Value(id),
      examinationId: Value(examinationId),
      modelId: Value(modelId),
      modelVersionId: Value(modelVersionId),
      inputImageId: Value(inputImageId),
      inputImageDate: Value(inputImageDate),
      executionTimestamp: Value(executionTimestamp),
    );
  }

  factory ModelRun.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModelRun(
      id: serializer.fromJson<String>(json['id']),
      examinationId: serializer.fromJson<String>(json['examinationId']),
      modelId: serializer.fromJson<String>(json['modelId']),
      modelVersionId: serializer.fromJson<String>(json['modelVersionId']),
      inputImageId: serializer.fromJson<String>(json['inputImageId']),
      inputImageDate: serializer.fromJson<DateTime>(json['inputImageDate']),
      executionTimestamp: serializer.fromJson<DateTime>(
        json['executionTimestamp'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examinationId': serializer.toJson<String>(examinationId),
      'modelId': serializer.toJson<String>(modelId),
      'modelVersionId': serializer.toJson<String>(modelVersionId),
      'inputImageId': serializer.toJson<String>(inputImageId),
      'inputImageDate': serializer.toJson<DateTime>(inputImageDate),
      'executionTimestamp': serializer.toJson<DateTime>(executionTimestamp),
    };
  }

  ModelRun copyWith({
    String? id,
    String? examinationId,
    String? modelId,
    String? modelVersionId,
    String? inputImageId,
    DateTime? inputImageDate,
    DateTime? executionTimestamp,
  }) => ModelRun(
    id: id ?? this.id,
    examinationId: examinationId ?? this.examinationId,
    modelId: modelId ?? this.modelId,
    modelVersionId: modelVersionId ?? this.modelVersionId,
    inputImageId: inputImageId ?? this.inputImageId,
    inputImageDate: inputImageDate ?? this.inputImageDate,
    executionTimestamp: executionTimestamp ?? this.executionTimestamp,
  );
  ModelRun copyWithCompanion(ModelRunsCompanion data) {
    return ModelRun(
      id: data.id.present ? data.id.value : this.id,
      examinationId: data.examinationId.present
          ? data.examinationId.value
          : this.examinationId,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      modelVersionId: data.modelVersionId.present
          ? data.modelVersionId.value
          : this.modelVersionId,
      inputImageId: data.inputImageId.present
          ? data.inputImageId.value
          : this.inputImageId,
      inputImageDate: data.inputImageDate.present
          ? data.inputImageDate.value
          : this.inputImageDate,
      executionTimestamp: data.executionTimestamp.present
          ? data.executionTimestamp.value
          : this.executionTimestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModelRun(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('modelId: $modelId, ')
          ..write('modelVersionId: $modelVersionId, ')
          ..write('inputImageId: $inputImageId, ')
          ..write('inputImageDate: $inputImageDate, ')
          ..write('executionTimestamp: $executionTimestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examinationId,
    modelId,
    modelVersionId,
    inputImageId,
    inputImageDate,
    executionTimestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModelRun &&
          other.id == this.id &&
          other.examinationId == this.examinationId &&
          other.modelId == this.modelId &&
          other.modelVersionId == this.modelVersionId &&
          other.inputImageId == this.inputImageId &&
          other.inputImageDate == this.inputImageDate &&
          other.executionTimestamp == this.executionTimestamp);
}

class ModelRunsCompanion extends UpdateCompanion<ModelRun> {
  final Value<String> id;
  final Value<String> examinationId;
  final Value<String> modelId;
  final Value<String> modelVersionId;
  final Value<String> inputImageId;
  final Value<DateTime> inputImageDate;
  final Value<DateTime> executionTimestamp;
  final Value<int> rowid;
  const ModelRunsCompanion({
    this.id = const Value.absent(),
    this.examinationId = const Value.absent(),
    this.modelId = const Value.absent(),
    this.modelVersionId = const Value.absent(),
    this.inputImageId = const Value.absent(),
    this.inputImageDate = const Value.absent(),
    this.executionTimestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModelRunsCompanion.insert({
    required String id,
    required String examinationId,
    required String modelId,
    required String modelVersionId,
    required String inputImageId,
    required DateTime inputImageDate,
    required DateTime executionTimestamp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       examinationId = Value(examinationId),
       modelId = Value(modelId),
       modelVersionId = Value(modelVersionId),
       inputImageId = Value(inputImageId),
       inputImageDate = Value(inputImageDate),
       executionTimestamp = Value(executionTimestamp);
  static Insertable<ModelRun> custom({
    Expression<String>? id,
    Expression<String>? examinationId,
    Expression<String>? modelId,
    Expression<String>? modelVersionId,
    Expression<String>? inputImageId,
    Expression<DateTime>? inputImageDate,
    Expression<DateTime>? executionTimestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examinationId != null) 'examination_id': examinationId,
      if (modelId != null) 'model_id': modelId,
      if (modelVersionId != null) 'model_version_id': modelVersionId,
      if (inputImageId != null) 'input_image_id': inputImageId,
      if (inputImageDate != null) 'input_image_date': inputImageDate,
      if (executionTimestamp != null) 'execution_timestamp': executionTimestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModelRunsCompanion copyWith({
    Value<String>? id,
    Value<String>? examinationId,
    Value<String>? modelId,
    Value<String>? modelVersionId,
    Value<String>? inputImageId,
    Value<DateTime>? inputImageDate,
    Value<DateTime>? executionTimestamp,
    Value<int>? rowid,
  }) {
    return ModelRunsCompanion(
      id: id ?? this.id,
      examinationId: examinationId ?? this.examinationId,
      modelId: modelId ?? this.modelId,
      modelVersionId: modelVersionId ?? this.modelVersionId,
      inputImageId: inputImageId ?? this.inputImageId,
      inputImageDate: inputImageDate ?? this.inputImageDate,
      executionTimestamp: executionTimestamp ?? this.executionTimestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examinationId.present) {
      map['examination_id'] = Variable<String>(examinationId.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (modelVersionId.present) {
      map['model_version_id'] = Variable<String>(modelVersionId.value);
    }
    if (inputImageId.present) {
      map['input_image_id'] = Variable<String>(inputImageId.value);
    }
    if (inputImageDate.present) {
      map['input_image_date'] = Variable<DateTime>(inputImageDate.value);
    }
    if (executionTimestamp.present) {
      map['execution_timestamp'] = Variable<DateTime>(executionTimestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelRunsCompanion(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('modelId: $modelId, ')
          ..write('modelVersionId: $modelVersionId, ')
          ..write('inputImageId: $inputImageId, ')
          ..write('inputImageDate: $inputImageDate, ')
          ..write('executionTimestamp: $executionTimestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModelRunResultsTable extends ModelRunResults
    with TableInfo<$ModelRunResultsTable, ModelRunResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelRunResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelRunIdMeta = const VerificationMeta(
    'modelRunId',
  );
  @override
  late final GeneratedColumn<String> modelRunId = GeneratedColumn<String>(
    'model_run_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES model_runs (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uncertaintyMeta = const VerificationMeta(
    'uncertainty',
  );
  @override
  late final GeneratedColumn<String> uncertainty = GeneratedColumn<String>(
    'uncertainty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawModelOutputMeta = const VerificationMeta(
    'rawModelOutput',
  );
  @override
  late final GeneratedColumn<String> rawModelOutput = GeneratedColumn<String>(
    'raw_model_output',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    modelRunId,
    status,
    confidence,
    uncertainty,
    rawModelOutput,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'model_run_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModelRunResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('model_run_id')) {
      context.handle(
        _modelRunIdMeta,
        modelRunId.isAcceptableOrUnknown(
          data['model_run_id']!,
          _modelRunIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modelRunIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('uncertainty')) {
      context.handle(
        _uncertaintyMeta,
        uncertainty.isAcceptableOrUnknown(
          data['uncertainty']!,
          _uncertaintyMeta,
        ),
      );
    }
    if (data.containsKey('raw_model_output')) {
      context.handle(
        _rawModelOutputMeta,
        rawModelOutput.isAcceptableOrUnknown(
          data['raw_model_output']!,
          _rawModelOutputMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModelRunResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModelRunResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      modelRunId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_run_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      ),
      uncertainty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uncertainty'],
      ),
      rawModelOutput: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_model_output'],
      ),
    );
  }

  @override
  $ModelRunResultsTable createAlias(String alias) {
    return $ModelRunResultsTable(attachedDatabase, alias);
  }
}

class ModelRunResult extends DataClass implements Insertable<ModelRunResult> {
  final String id;
  final String modelRunId;
  final String status;
  final String? confidence;
  final String? uncertainty;
  final String? rawModelOutput;
  const ModelRunResult({
    required this.id,
    required this.modelRunId,
    required this.status,
    this.confidence,
    this.uncertainty,
    this.rawModelOutput,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['model_run_id'] = Variable<String>(modelRunId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<String>(confidence);
    }
    if (!nullToAbsent || uncertainty != null) {
      map['uncertainty'] = Variable<String>(uncertainty);
    }
    if (!nullToAbsent || rawModelOutput != null) {
      map['raw_model_output'] = Variable<String>(rawModelOutput);
    }
    return map;
  }

  ModelRunResultsCompanion toCompanion(bool nullToAbsent) {
    return ModelRunResultsCompanion(
      id: Value(id),
      modelRunId: Value(modelRunId),
      status: Value(status),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      uncertainty: uncertainty == null && nullToAbsent
          ? const Value.absent()
          : Value(uncertainty),
      rawModelOutput: rawModelOutput == null && nullToAbsent
          ? const Value.absent()
          : Value(rawModelOutput),
    );
  }

  factory ModelRunResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModelRunResult(
      id: serializer.fromJson<String>(json['id']),
      modelRunId: serializer.fromJson<String>(json['modelRunId']),
      status: serializer.fromJson<String>(json['status']),
      confidence: serializer.fromJson<String?>(json['confidence']),
      uncertainty: serializer.fromJson<String?>(json['uncertainty']),
      rawModelOutput: serializer.fromJson<String?>(json['rawModelOutput']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'modelRunId': serializer.toJson<String>(modelRunId),
      'status': serializer.toJson<String>(status),
      'confidence': serializer.toJson<String?>(confidence),
      'uncertainty': serializer.toJson<String?>(uncertainty),
      'rawModelOutput': serializer.toJson<String?>(rawModelOutput),
    };
  }

  ModelRunResult copyWith({
    String? id,
    String? modelRunId,
    String? status,
    Value<String?> confidence = const Value.absent(),
    Value<String?> uncertainty = const Value.absent(),
    Value<String?> rawModelOutput = const Value.absent(),
  }) => ModelRunResult(
    id: id ?? this.id,
    modelRunId: modelRunId ?? this.modelRunId,
    status: status ?? this.status,
    confidence: confidence.present ? confidence.value : this.confidence,
    uncertainty: uncertainty.present ? uncertainty.value : this.uncertainty,
    rawModelOutput: rawModelOutput.present
        ? rawModelOutput.value
        : this.rawModelOutput,
  );
  ModelRunResult copyWithCompanion(ModelRunResultsCompanion data) {
    return ModelRunResult(
      id: data.id.present ? data.id.value : this.id,
      modelRunId: data.modelRunId.present
          ? data.modelRunId.value
          : this.modelRunId,
      status: data.status.present ? data.status.value : this.status,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      uncertainty: data.uncertainty.present
          ? data.uncertainty.value
          : this.uncertainty,
      rawModelOutput: data.rawModelOutput.present
          ? data.rawModelOutput.value
          : this.rawModelOutput,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModelRunResult(')
          ..write('id: $id, ')
          ..write('modelRunId: $modelRunId, ')
          ..write('status: $status, ')
          ..write('confidence: $confidence, ')
          ..write('uncertainty: $uncertainty, ')
          ..write('rawModelOutput: $rawModelOutput')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    modelRunId,
    status,
    confidence,
    uncertainty,
    rawModelOutput,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModelRunResult &&
          other.id == this.id &&
          other.modelRunId == this.modelRunId &&
          other.status == this.status &&
          other.confidence == this.confidence &&
          other.uncertainty == this.uncertainty &&
          other.rawModelOutput == this.rawModelOutput);
}

class ModelRunResultsCompanion extends UpdateCompanion<ModelRunResult> {
  final Value<String> id;
  final Value<String> modelRunId;
  final Value<String> status;
  final Value<String?> confidence;
  final Value<String?> uncertainty;
  final Value<String?> rawModelOutput;
  final Value<int> rowid;
  const ModelRunResultsCompanion({
    this.id = const Value.absent(),
    this.modelRunId = const Value.absent(),
    this.status = const Value.absent(),
    this.confidence = const Value.absent(),
    this.uncertainty = const Value.absent(),
    this.rawModelOutput = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModelRunResultsCompanion.insert({
    required String id,
    required String modelRunId,
    required String status,
    this.confidence = const Value.absent(),
    this.uncertainty = const Value.absent(),
    this.rawModelOutput = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       modelRunId = Value(modelRunId),
       status = Value(status);
  static Insertable<ModelRunResult> custom({
    Expression<String>? id,
    Expression<String>? modelRunId,
    Expression<String>? status,
    Expression<String>? confidence,
    Expression<String>? uncertainty,
    Expression<String>? rawModelOutput,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modelRunId != null) 'model_run_id': modelRunId,
      if (status != null) 'status': status,
      if (confidence != null) 'confidence': confidence,
      if (uncertainty != null) 'uncertainty': uncertainty,
      if (rawModelOutput != null) 'raw_model_output': rawModelOutput,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModelRunResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? modelRunId,
    Value<String>? status,
    Value<String?>? confidence,
    Value<String?>? uncertainty,
    Value<String?>? rawModelOutput,
    Value<int>? rowid,
  }) {
    return ModelRunResultsCompanion(
      id: id ?? this.id,
      modelRunId: modelRunId ?? this.modelRunId,
      status: status ?? this.status,
      confidence: confidence ?? this.confidence,
      uncertainty: uncertainty ?? this.uncertainty,
      rawModelOutput: rawModelOutput ?? this.rawModelOutput,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (modelRunId.present) {
      map['model_run_id'] = Variable<String>(modelRunId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (uncertainty.present) {
      map['uncertainty'] = Variable<String>(uncertainty.value);
    }
    if (rawModelOutput.present) {
      map['raw_model_output'] = Variable<String>(rawModelOutput.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelRunResultsCompanion(')
          ..write('id: $id, ')
          ..write('modelRunId: $modelRunId, ')
          ..write('status: $status, ')
          ..write('confidence: $confidence, ')
          ..write('uncertainty: $uncertainty, ')
          ..write('rawModelOutput: $rawModelOutput, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModelFindingsTable extends ModelFindings
    with TableInfo<$ModelFindingsTable, ModelFinding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelFindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelRunResultIdMeta = const VerificationMeta(
    'modelRunResultId',
  );
  @override
  late final GeneratedColumn<String> modelRunResultId = GeneratedColumn<String>(
    'model_run_result_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES model_run_results (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    modelRunResultId,
    label,
    value,
    confidence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'model_findings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModelFinding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('model_run_result_id')) {
      context.handle(
        _modelRunResultIdMeta,
        modelRunResultId.isAcceptableOrUnknown(
          data['model_run_result_id']!,
          _modelRunResultIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modelRunResultIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModelFinding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModelFinding(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      modelRunResultId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_run_result_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      ),
    );
  }

  @override
  $ModelFindingsTable createAlias(String alias) {
    return $ModelFindingsTable(attachedDatabase, alias);
  }
}

class ModelFinding extends DataClass implements Insertable<ModelFinding> {
  final String id;
  final String modelRunResultId;
  final String label;
  final String value;
  final String? confidence;
  const ModelFinding({
    required this.id,
    required this.modelRunResultId,
    required this.label,
    required this.value,
    this.confidence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['model_run_result_id'] = Variable<String>(modelRunResultId);
    map['label'] = Variable<String>(label);
    map['value'] = Variable<String>(value);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<String>(confidence);
    }
    return map;
  }

  ModelFindingsCompanion toCompanion(bool nullToAbsent) {
    return ModelFindingsCompanion(
      id: Value(id),
      modelRunResultId: Value(modelRunResultId),
      label: Value(label),
      value: Value(value),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
    );
  }

  factory ModelFinding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModelFinding(
      id: serializer.fromJson<String>(json['id']),
      modelRunResultId: serializer.fromJson<String>(json['modelRunResultId']),
      label: serializer.fromJson<String>(json['label']),
      value: serializer.fromJson<String>(json['value']),
      confidence: serializer.fromJson<String?>(json['confidence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'modelRunResultId': serializer.toJson<String>(modelRunResultId),
      'label': serializer.toJson<String>(label),
      'value': serializer.toJson<String>(value),
      'confidence': serializer.toJson<String?>(confidence),
    };
  }

  ModelFinding copyWith({
    String? id,
    String? modelRunResultId,
    String? label,
    String? value,
    Value<String?> confidence = const Value.absent(),
  }) => ModelFinding(
    id: id ?? this.id,
    modelRunResultId: modelRunResultId ?? this.modelRunResultId,
    label: label ?? this.label,
    value: value ?? this.value,
    confidence: confidence.present ? confidence.value : this.confidence,
  );
  ModelFinding copyWithCompanion(ModelFindingsCompanion data) {
    return ModelFinding(
      id: data.id.present ? data.id.value : this.id,
      modelRunResultId: data.modelRunResultId.present
          ? data.modelRunResultId.value
          : this.modelRunResultId,
      label: data.label.present ? data.label.value : this.label,
      value: data.value.present ? data.value.value : this.value,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModelFinding(')
          ..write('id: $id, ')
          ..write('modelRunResultId: $modelRunResultId, ')
          ..write('label: $label, ')
          ..write('value: $value, ')
          ..write('confidence: $confidence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, modelRunResultId, label, value, confidence);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModelFinding &&
          other.id == this.id &&
          other.modelRunResultId == this.modelRunResultId &&
          other.label == this.label &&
          other.value == this.value &&
          other.confidence == this.confidence);
}

class ModelFindingsCompanion extends UpdateCompanion<ModelFinding> {
  final Value<String> id;
  final Value<String> modelRunResultId;
  final Value<String> label;
  final Value<String> value;
  final Value<String?> confidence;
  final Value<int> rowid;
  const ModelFindingsCompanion({
    this.id = const Value.absent(),
    this.modelRunResultId = const Value.absent(),
    this.label = const Value.absent(),
    this.value = const Value.absent(),
    this.confidence = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModelFindingsCompanion.insert({
    required String id,
    required String modelRunResultId,
    required String label,
    required String value,
    this.confidence = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       modelRunResultId = Value(modelRunResultId),
       label = Value(label),
       value = Value(value);
  static Insertable<ModelFinding> custom({
    Expression<String>? id,
    Expression<String>? modelRunResultId,
    Expression<String>? label,
    Expression<String>? value,
    Expression<String>? confidence,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modelRunResultId != null) 'model_run_result_id': modelRunResultId,
      if (label != null) 'label': label,
      if (value != null) 'value': value,
      if (confidence != null) 'confidence': confidence,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModelFindingsCompanion copyWith({
    Value<String>? id,
    Value<String>? modelRunResultId,
    Value<String>? label,
    Value<String>? value,
    Value<String?>? confidence,
    Value<int>? rowid,
  }) {
    return ModelFindingsCompanion(
      id: id ?? this.id,
      modelRunResultId: modelRunResultId ?? this.modelRunResultId,
      label: label ?? this.label,
      value: value ?? this.value,
      confidence: confidence ?? this.confidence,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (modelRunResultId.present) {
      map['model_run_result_id'] = Variable<String>(modelRunResultId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelFindingsCompanion(')
          ..write('id: $id, ')
          ..write('modelRunResultId: $modelRunResultId, ')
          ..write('label: $label, ')
          ..write('value: $value, ')
          ..write('confidence: $confidence, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiAnalysesTable extends AiAnalyses
    with TableInfo<$AiAnalysesTable, AiAnalyse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiAnalysesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examinationIdMeta = const VerificationMeta(
    'examinationId',
  );
  @override
  late final GeneratedColumn<String> examinationId = GeneratedColumn<String>(
    'examination_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES examinations (id)',
    ),
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ollamaModelMeta = const VerificationMeta(
    'ollamaModel',
  );
  @override
  late final GeneratedColumn<String> ollamaModel = GeneratedColumn<String>(
    'ollama_model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextWindowMeta = const VerificationMeta(
    'contextWindow',
  );
  @override
  late final GeneratedColumn<String> contextWindow = GeneratedColumn<String>(
    'context_window',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uncertaintyMeta = const VerificationMeta(
    'uncertainty',
  );
  @override
  late final GeneratedColumn<String> uncertainty = GeneratedColumn<String>(
    'uncertainty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examinationId,
    generatedAt,
    ollamaModel,
    contextWindow,
    summary,
    uncertainty,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_analyses';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiAnalyse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('examination_id')) {
      context.handle(
        _examinationIdMeta,
        examinationId.isAcceptableOrUnknown(
          data['examination_id']!,
          _examinationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationIdMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('ollama_model')) {
      context.handle(
        _ollamaModelMeta,
        ollamaModel.isAcceptableOrUnknown(
          data['ollama_model']!,
          _ollamaModelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ollamaModelMeta);
    }
    if (data.containsKey('context_window')) {
      context.handle(
        _contextWindowMeta,
        contextWindow.isAcceptableOrUnknown(
          data['context_window']!,
          _contextWindowMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contextWindowMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('uncertainty')) {
      context.handle(
        _uncertaintyMeta,
        uncertainty.isAcceptableOrUnknown(
          data['uncertainty']!,
          _uncertaintyMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiAnalyse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiAnalyse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      examinationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examination_id'],
      )!,
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      )!,
      ollamaModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ollama_model'],
      )!,
      contextWindow: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_window'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      uncertainty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uncertainty'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $AiAnalysesTable createAlias(String alias) {
    return $AiAnalysesTable(attachedDatabase, alias);
  }
}

class AiAnalyse extends DataClass implements Insertable<AiAnalyse> {
  final String id;
  final String examinationId;
  final DateTime generatedAt;
  final String ollamaModel;
  final String contextWindow;
  final String? summary;
  final String? uncertainty;
  final String status;
  const AiAnalyse({
    required this.id,
    required this.examinationId,
    required this.generatedAt,
    required this.ollamaModel,
    required this.contextWindow,
    this.summary,
    this.uncertainty,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['examination_id'] = Variable<String>(examinationId);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['ollama_model'] = Variable<String>(ollamaModel);
    map['context_window'] = Variable<String>(contextWindow);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || uncertainty != null) {
      map['uncertainty'] = Variable<String>(uncertainty);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  AiAnalysesCompanion toCompanion(bool nullToAbsent) {
    return AiAnalysesCompanion(
      id: Value(id),
      examinationId: Value(examinationId),
      generatedAt: Value(generatedAt),
      ollamaModel: Value(ollamaModel),
      contextWindow: Value(contextWindow),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      uncertainty: uncertainty == null && nullToAbsent
          ? const Value.absent()
          : Value(uncertainty),
      status: Value(status),
    );
  }

  factory AiAnalyse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiAnalyse(
      id: serializer.fromJson<String>(json['id']),
      examinationId: serializer.fromJson<String>(json['examinationId']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      ollamaModel: serializer.fromJson<String>(json['ollamaModel']),
      contextWindow: serializer.fromJson<String>(json['contextWindow']),
      summary: serializer.fromJson<String?>(json['summary']),
      uncertainty: serializer.fromJson<String?>(json['uncertainty']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examinationId': serializer.toJson<String>(examinationId),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'ollamaModel': serializer.toJson<String>(ollamaModel),
      'contextWindow': serializer.toJson<String>(contextWindow),
      'summary': serializer.toJson<String?>(summary),
      'uncertainty': serializer.toJson<String?>(uncertainty),
      'status': serializer.toJson<String>(status),
    };
  }

  AiAnalyse copyWith({
    String? id,
    String? examinationId,
    DateTime? generatedAt,
    String? ollamaModel,
    String? contextWindow,
    Value<String?> summary = const Value.absent(),
    Value<String?> uncertainty = const Value.absent(),
    String? status,
  }) => AiAnalyse(
    id: id ?? this.id,
    examinationId: examinationId ?? this.examinationId,
    generatedAt: generatedAt ?? this.generatedAt,
    ollamaModel: ollamaModel ?? this.ollamaModel,
    contextWindow: contextWindow ?? this.contextWindow,
    summary: summary.present ? summary.value : this.summary,
    uncertainty: uncertainty.present ? uncertainty.value : this.uncertainty,
    status: status ?? this.status,
  );
  AiAnalyse copyWithCompanion(AiAnalysesCompanion data) {
    return AiAnalyse(
      id: data.id.present ? data.id.value : this.id,
      examinationId: data.examinationId.present
          ? data.examinationId.value
          : this.examinationId,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      ollamaModel: data.ollamaModel.present
          ? data.ollamaModel.value
          : this.ollamaModel,
      contextWindow: data.contextWindow.present
          ? data.contextWindow.value
          : this.contextWindow,
      summary: data.summary.present ? data.summary.value : this.summary,
      uncertainty: data.uncertainty.present
          ? data.uncertainty.value
          : this.uncertainty,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiAnalyse(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('ollamaModel: $ollamaModel, ')
          ..write('contextWindow: $contextWindow, ')
          ..write('summary: $summary, ')
          ..write('uncertainty: $uncertainty, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examinationId,
    generatedAt,
    ollamaModel,
    contextWindow,
    summary,
    uncertainty,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiAnalyse &&
          other.id == this.id &&
          other.examinationId == this.examinationId &&
          other.generatedAt == this.generatedAt &&
          other.ollamaModel == this.ollamaModel &&
          other.contextWindow == this.contextWindow &&
          other.summary == this.summary &&
          other.uncertainty == this.uncertainty &&
          other.status == this.status);
}

class AiAnalysesCompanion extends UpdateCompanion<AiAnalyse> {
  final Value<String> id;
  final Value<String> examinationId;
  final Value<DateTime> generatedAt;
  final Value<String> ollamaModel;
  final Value<String> contextWindow;
  final Value<String?> summary;
  final Value<String?> uncertainty;
  final Value<String> status;
  final Value<int> rowid;
  const AiAnalysesCompanion({
    this.id = const Value.absent(),
    this.examinationId = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.ollamaModel = const Value.absent(),
    this.contextWindow = const Value.absent(),
    this.summary = const Value.absent(),
    this.uncertainty = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiAnalysesCompanion.insert({
    required String id,
    required String examinationId,
    required DateTime generatedAt,
    required String ollamaModel,
    required String contextWindow,
    this.summary = const Value.absent(),
    this.uncertainty = const Value.absent(),
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       examinationId = Value(examinationId),
       generatedAt = Value(generatedAt),
       ollamaModel = Value(ollamaModel),
       contextWindow = Value(contextWindow),
       status = Value(status);
  static Insertable<AiAnalyse> custom({
    Expression<String>? id,
    Expression<String>? examinationId,
    Expression<DateTime>? generatedAt,
    Expression<String>? ollamaModel,
    Expression<String>? contextWindow,
    Expression<String>? summary,
    Expression<String>? uncertainty,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examinationId != null) 'examination_id': examinationId,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (ollamaModel != null) 'ollama_model': ollamaModel,
      if (contextWindow != null) 'context_window': contextWindow,
      if (summary != null) 'summary': summary,
      if (uncertainty != null) 'uncertainty': uncertainty,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiAnalysesCompanion copyWith({
    Value<String>? id,
    Value<String>? examinationId,
    Value<DateTime>? generatedAt,
    Value<String>? ollamaModel,
    Value<String>? contextWindow,
    Value<String?>? summary,
    Value<String?>? uncertainty,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return AiAnalysesCompanion(
      id: id ?? this.id,
      examinationId: examinationId ?? this.examinationId,
      generatedAt: generatedAt ?? this.generatedAt,
      ollamaModel: ollamaModel ?? this.ollamaModel,
      contextWindow: contextWindow ?? this.contextWindow,
      summary: summary ?? this.summary,
      uncertainty: uncertainty ?? this.uncertainty,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examinationId.present) {
      map['examination_id'] = Variable<String>(examinationId.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (ollamaModel.present) {
      map['ollama_model'] = Variable<String>(ollamaModel.value);
    }
    if (contextWindow.present) {
      map['context_window'] = Variable<String>(contextWindow.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (uncertainty.present) {
      map['uncertainty'] = Variable<String>(uncertainty.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiAnalysesCompanion(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('ollamaModel: $ollamaModel, ')
          ..write('contextWindow: $contextWindow, ')
          ..write('summary: $summary, ')
          ..write('uncertainty: $uncertainty, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EvidenceTable extends Evidence
    with TableInfo<$EvidenceTable, EvidenceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvidenceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ai_analyses (id)',
    ),
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceDateMeta = const VerificationMeta(
    'sourceDate',
  );
  @override
  late final GeneratedColumn<DateTime> sourceDate = GeneratedColumn<DateTime>(
    'source_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relevanceMeta = const VerificationMeta(
    'relevance',
  );
  @override
  late final GeneratedColumn<String> relevance = GeneratedColumn<String>(
    'relevance',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    analysisId,
    sourceType,
    sourceId,
    sourceDate,
    content,
    relevance,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evidence';
  @override
  VerificationContext validateIntegrity(
    Insertable<EvidenceData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('source_date')) {
      context.handle(
        _sourceDateMeta,
        sourceDate.isAcceptableOrUnknown(data['source_date']!, _sourceDateMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('relevance')) {
      context.handle(
        _relevanceMeta,
        relevance.isAcceptableOrUnknown(data['relevance']!, _relevanceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EvidenceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EvidenceData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      sourceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}source_date'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      relevance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relevance'],
      ),
    );
  }

  @override
  $EvidenceTable createAlias(String alias) {
    return $EvidenceTable(attachedDatabase, alias);
  }
}

class EvidenceData extends DataClass implements Insertable<EvidenceData> {
  final String id;
  final String analysisId;
  final String sourceType;
  final String sourceId;
  final DateTime? sourceDate;
  final String content;
  final String? relevance;
  const EvidenceData({
    required this.id,
    required this.analysisId,
    required this.sourceType,
    required this.sourceId,
    this.sourceDate,
    required this.content,
    this.relevance,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_id'] = Variable<String>(analysisId);
    map['source_type'] = Variable<String>(sourceType);
    map['source_id'] = Variable<String>(sourceId);
    if (!nullToAbsent || sourceDate != null) {
      map['source_date'] = Variable<DateTime>(sourceDate);
    }
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || relevance != null) {
      map['relevance'] = Variable<String>(relevance);
    }
    return map;
  }

  EvidenceCompanion toCompanion(bool nullToAbsent) {
    return EvidenceCompanion(
      id: Value(id),
      analysisId: Value(analysisId),
      sourceType: Value(sourceType),
      sourceId: Value(sourceId),
      sourceDate: sourceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDate),
      content: Value(content),
      relevance: relevance == null && nullToAbsent
          ? const Value.absent()
          : Value(relevance),
    );
  }

  factory EvidenceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EvidenceData(
      id: serializer.fromJson<String>(json['id']),
      analysisId: serializer.fromJson<String>(json['analysisId']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      sourceDate: serializer.fromJson<DateTime?>(json['sourceDate']),
      content: serializer.fromJson<String>(json['content']),
      relevance: serializer.fromJson<String?>(json['relevance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisId': serializer.toJson<String>(analysisId),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String>(sourceId),
      'sourceDate': serializer.toJson<DateTime?>(sourceDate),
      'content': serializer.toJson<String>(content),
      'relevance': serializer.toJson<String?>(relevance),
    };
  }

  EvidenceData copyWith({
    String? id,
    String? analysisId,
    String? sourceType,
    String? sourceId,
    Value<DateTime?> sourceDate = const Value.absent(),
    String? content,
    Value<String?> relevance = const Value.absent(),
  }) => EvidenceData(
    id: id ?? this.id,
    analysisId: analysisId ?? this.analysisId,
    sourceType: sourceType ?? this.sourceType,
    sourceId: sourceId ?? this.sourceId,
    sourceDate: sourceDate.present ? sourceDate.value : this.sourceDate,
    content: content ?? this.content,
    relevance: relevance.present ? relevance.value : this.relevance,
  );
  EvidenceData copyWithCompanion(EvidenceCompanion data) {
    return EvidenceData(
      id: data.id.present ? data.id.value : this.id,
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      sourceDate: data.sourceDate.present
          ? data.sourceDate.value
          : this.sourceDate,
      content: data.content.present ? data.content.value : this.content,
      relevance: data.relevance.present ? data.relevance.value : this.relevance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceData(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceDate: $sourceDate, ')
          ..write('content: $content, ')
          ..write('relevance: $relevance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    analysisId,
    sourceType,
    sourceId,
    sourceDate,
    content,
    relevance,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EvidenceData &&
          other.id == this.id &&
          other.analysisId == this.analysisId &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.sourceDate == this.sourceDate &&
          other.content == this.content &&
          other.relevance == this.relevance);
}

class EvidenceCompanion extends UpdateCompanion<EvidenceData> {
  final Value<String> id;
  final Value<String> analysisId;
  final Value<String> sourceType;
  final Value<String> sourceId;
  final Value<DateTime?> sourceDate;
  final Value<String> content;
  final Value<String?> relevance;
  final Value<int> rowid;
  const EvidenceCompanion({
    this.id = const Value.absent(),
    this.analysisId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.sourceDate = const Value.absent(),
    this.content = const Value.absent(),
    this.relevance = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EvidenceCompanion.insert({
    required String id,
    required String analysisId,
    required String sourceType,
    required String sourceId,
    this.sourceDate = const Value.absent(),
    required String content,
    this.relevance = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisId = Value(analysisId),
       sourceType = Value(sourceType),
       sourceId = Value(sourceId),
       content = Value(content);
  static Insertable<EvidenceData> custom({
    Expression<String>? id,
    Expression<String>? analysisId,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<DateTime>? sourceDate,
    Expression<String>? content,
    Expression<String>? relevance,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisId != null) 'analysis_id': analysisId,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (sourceDate != null) 'source_date': sourceDate,
      if (content != null) 'content': content,
      if (relevance != null) 'relevance': relevance,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EvidenceCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisId,
    Value<String>? sourceType,
    Value<String>? sourceId,
    Value<DateTime?>? sourceDate,
    Value<String>? content,
    Value<String?>? relevance,
    Value<int>? rowid,
  }) {
    return EvidenceCompanion(
      id: id ?? this.id,
      analysisId: analysisId ?? this.analysisId,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      sourceDate: sourceDate ?? this.sourceDate,
      content: content ?? this.content,
      relevance: relevance ?? this.relevance,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (sourceDate.present) {
      map['source_date'] = Variable<DateTime>(sourceDate.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (relevance.present) {
      map['relevance'] = Variable<String>(relevance.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceCompanion(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceDate: $sourceDate, ')
          ..write('content: $content, ')
          ..write('relevance: $relevance, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoctorReviewsTable extends DoctorReviews
    with TableInfo<$DoctorReviewsTable, DoctorReview> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoctorReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examinationIdMeta = const VerificationMeta(
    'examinationId',
  );
  @override
  late final GeneratedColumn<String> examinationId = GeneratedColumn<String>(
    'examination_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES examinations (id)',
    ),
  );
  static const VerificationMeta _reviewStatusMeta = const VerificationMeta(
    'reviewStatus',
  );
  @override
  late final GeneratedColumn<String> reviewStatus = GeneratedColumn<String>(
    'review_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
    'reviewed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finalizedAnalysisMeta = const VerificationMeta(
    'finalizedAnalysis',
  );
  @override
  late final GeneratedColumn<String> finalizedAnalysis =
      GeneratedColumn<String>(
        'finalized_analysis',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examinationId,
    reviewStatus,
    reviewedAt,
    finalizedAnalysis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doctor_reviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoctorReview> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('examination_id')) {
      context.handle(
        _examinationIdMeta,
        examinationId.isAcceptableOrUnknown(
          data['examination_id']!,
          _examinationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationIdMeta);
    }
    if (data.containsKey('review_status')) {
      context.handle(
        _reviewStatusMeta,
        reviewStatus.isAcceptableOrUnknown(
          data['review_status']!,
          _reviewStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reviewStatusMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    if (data.containsKey('finalized_analysis')) {
      context.handle(
        _finalizedAnalysisMeta,
        finalizedAnalysis.isAcceptableOrUnknown(
          data['finalized_analysis']!,
          _finalizedAnalysisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_finalizedAnalysisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoctorReview map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoctorReview(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      examinationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examination_id'],
      )!,
      reviewStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_status'],
      )!,
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reviewed_at'],
      )!,
      finalizedAnalysis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}finalized_analysis'],
      )!,
    );
  }

  @override
  $DoctorReviewsTable createAlias(String alias) {
    return $DoctorReviewsTable(attachedDatabase, alias);
  }
}

class DoctorReview extends DataClass implements Insertable<DoctorReview> {
  final String id;
  final String examinationId;
  final String reviewStatus;
  final DateTime reviewedAt;
  final String finalizedAnalysis;
  const DoctorReview({
    required this.id,
    required this.examinationId,
    required this.reviewStatus,
    required this.reviewedAt,
    required this.finalizedAnalysis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['examination_id'] = Variable<String>(examinationId);
    map['review_status'] = Variable<String>(reviewStatus);
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    map['finalized_analysis'] = Variable<String>(finalizedAnalysis);
    return map;
  }

  DoctorReviewsCompanion toCompanion(bool nullToAbsent) {
    return DoctorReviewsCompanion(
      id: Value(id),
      examinationId: Value(examinationId),
      reviewStatus: Value(reviewStatus),
      reviewedAt: Value(reviewedAt),
      finalizedAnalysis: Value(finalizedAnalysis),
    );
  }

  factory DoctorReview.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoctorReview(
      id: serializer.fromJson<String>(json['id']),
      examinationId: serializer.fromJson<String>(json['examinationId']),
      reviewStatus: serializer.fromJson<String>(json['reviewStatus']),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
      finalizedAnalysis: serializer.fromJson<String>(json['finalizedAnalysis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examinationId': serializer.toJson<String>(examinationId),
      'reviewStatus': serializer.toJson<String>(reviewStatus),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
      'finalizedAnalysis': serializer.toJson<String>(finalizedAnalysis),
    };
  }

  DoctorReview copyWith({
    String? id,
    String? examinationId,
    String? reviewStatus,
    DateTime? reviewedAt,
    String? finalizedAnalysis,
  }) => DoctorReview(
    id: id ?? this.id,
    examinationId: examinationId ?? this.examinationId,
    reviewStatus: reviewStatus ?? this.reviewStatus,
    reviewedAt: reviewedAt ?? this.reviewedAt,
    finalizedAnalysis: finalizedAnalysis ?? this.finalizedAnalysis,
  );
  DoctorReview copyWithCompanion(DoctorReviewsCompanion data) {
    return DoctorReview(
      id: data.id.present ? data.id.value : this.id,
      examinationId: data.examinationId.present
          ? data.examinationId.value
          : this.examinationId,
      reviewStatus: data.reviewStatus.present
          ? data.reviewStatus.value
          : this.reviewStatus,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
      finalizedAnalysis: data.finalizedAnalysis.present
          ? data.finalizedAnalysis.value
          : this.finalizedAnalysis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoctorReview(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('finalizedAnalysis: $finalizedAnalysis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examinationId,
    reviewStatus,
    reviewedAt,
    finalizedAnalysis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoctorReview &&
          other.id == this.id &&
          other.examinationId == this.examinationId &&
          other.reviewStatus == this.reviewStatus &&
          other.reviewedAt == this.reviewedAt &&
          other.finalizedAnalysis == this.finalizedAnalysis);
}

class DoctorReviewsCompanion extends UpdateCompanion<DoctorReview> {
  final Value<String> id;
  final Value<String> examinationId;
  final Value<String> reviewStatus;
  final Value<DateTime> reviewedAt;
  final Value<String> finalizedAnalysis;
  final Value<int> rowid;
  const DoctorReviewsCompanion({
    this.id = const Value.absent(),
    this.examinationId = const Value.absent(),
    this.reviewStatus = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.finalizedAnalysis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoctorReviewsCompanion.insert({
    required String id,
    required String examinationId,
    required String reviewStatus,
    required DateTime reviewedAt,
    required String finalizedAnalysis,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       examinationId = Value(examinationId),
       reviewStatus = Value(reviewStatus),
       reviewedAt = Value(reviewedAt),
       finalizedAnalysis = Value(finalizedAnalysis);
  static Insertable<DoctorReview> custom({
    Expression<String>? id,
    Expression<String>? examinationId,
    Expression<String>? reviewStatus,
    Expression<DateTime>? reviewedAt,
    Expression<String>? finalizedAnalysis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examinationId != null) 'examination_id': examinationId,
      if (reviewStatus != null) 'review_status': reviewStatus,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (finalizedAnalysis != null) 'finalized_analysis': finalizedAnalysis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoctorReviewsCompanion copyWith({
    Value<String>? id,
    Value<String>? examinationId,
    Value<String>? reviewStatus,
    Value<DateTime>? reviewedAt,
    Value<String>? finalizedAnalysis,
    Value<int>? rowid,
  }) {
    return DoctorReviewsCompanion(
      id: id ?? this.id,
      examinationId: examinationId ?? this.examinationId,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      finalizedAnalysis: finalizedAnalysis ?? this.finalizedAnalysis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examinationId.present) {
      map['examination_id'] = Variable<String>(examinationId.value);
    }
    if (reviewStatus.present) {
      map['review_status'] = Variable<String>(reviewStatus.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (finalizedAnalysis.present) {
      map['finalized_analysis'] = Variable<String>(finalizedAnalysis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoctorReviewsCompanion(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('reviewStatus: $reviewStatus, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('finalizedAnalysis: $finalizedAnalysis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinalReportsTable extends FinalReports
    with TableInfo<$FinalReportsTable, FinalReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinalReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examinationIdMeta = const VerificationMeta(
    'examinationId',
  );
  @override
  late final GeneratedColumn<String> examinationId = GeneratedColumn<String>(
    'examination_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES examinations (id)',
    ),
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finalizedAnalysisMeta = const VerificationMeta(
    'finalizedAnalysis',
  );
  @override
  late final GeneratedColumn<String> finalizedAnalysis =
      GeneratedColumn<String>(
        'finalized_analysis',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examinationId,
    generatedAt,
    filePath,
    finalizedAnalysis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'final_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinalReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('examination_id')) {
      context.handle(
        _examinationIdMeta,
        examinationId.isAcceptableOrUnknown(
          data['examination_id']!,
          _examinationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationIdMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('finalized_analysis')) {
      context.handle(
        _finalizedAnalysisMeta,
        finalizedAnalysis.isAcceptableOrUnknown(
          data['finalized_analysis']!,
          _finalizedAnalysisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_finalizedAnalysisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinalReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinalReport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      examinationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examination_id'],
      )!,
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      finalizedAnalysis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}finalized_analysis'],
      )!,
    );
  }

  @override
  $FinalReportsTable createAlias(String alias) {
    return $FinalReportsTable(attachedDatabase, alias);
  }
}

class FinalReport extends DataClass implements Insertable<FinalReport> {
  final String id;
  final String examinationId;
  final DateTime generatedAt;
  final String filePath;
  final String finalizedAnalysis;
  const FinalReport({
    required this.id,
    required this.examinationId,
    required this.generatedAt,
    required this.filePath,
    required this.finalizedAnalysis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['examination_id'] = Variable<String>(examinationId);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['file_path'] = Variable<String>(filePath);
    map['finalized_analysis'] = Variable<String>(finalizedAnalysis);
    return map;
  }

  FinalReportsCompanion toCompanion(bool nullToAbsent) {
    return FinalReportsCompanion(
      id: Value(id),
      examinationId: Value(examinationId),
      generatedAt: Value(generatedAt),
      filePath: Value(filePath),
      finalizedAnalysis: Value(finalizedAnalysis),
    );
  }

  factory FinalReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinalReport(
      id: serializer.fromJson<String>(json['id']),
      examinationId: serializer.fromJson<String>(json['examinationId']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      filePath: serializer.fromJson<String>(json['filePath']),
      finalizedAnalysis: serializer.fromJson<String>(json['finalizedAnalysis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examinationId': serializer.toJson<String>(examinationId),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'filePath': serializer.toJson<String>(filePath),
      'finalizedAnalysis': serializer.toJson<String>(finalizedAnalysis),
    };
  }

  FinalReport copyWith({
    String? id,
    String? examinationId,
    DateTime? generatedAt,
    String? filePath,
    String? finalizedAnalysis,
  }) => FinalReport(
    id: id ?? this.id,
    examinationId: examinationId ?? this.examinationId,
    generatedAt: generatedAt ?? this.generatedAt,
    filePath: filePath ?? this.filePath,
    finalizedAnalysis: finalizedAnalysis ?? this.finalizedAnalysis,
  );
  FinalReport copyWithCompanion(FinalReportsCompanion data) {
    return FinalReport(
      id: data.id.present ? data.id.value : this.id,
      examinationId: data.examinationId.present
          ? data.examinationId.value
          : this.examinationId,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      finalizedAnalysis: data.finalizedAnalysis.present
          ? data.finalizedAnalysis.value
          : this.finalizedAnalysis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinalReport(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('filePath: $filePath, ')
          ..write('finalizedAnalysis: $finalizedAnalysis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, examinationId, generatedAt, filePath, finalizedAnalysis);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinalReport &&
          other.id == this.id &&
          other.examinationId == this.examinationId &&
          other.generatedAt == this.generatedAt &&
          other.filePath == this.filePath &&
          other.finalizedAnalysis == this.finalizedAnalysis);
}

class FinalReportsCompanion extends UpdateCompanion<FinalReport> {
  final Value<String> id;
  final Value<String> examinationId;
  final Value<DateTime> generatedAt;
  final Value<String> filePath;
  final Value<String> finalizedAnalysis;
  final Value<int> rowid;
  const FinalReportsCompanion({
    this.id = const Value.absent(),
    this.examinationId = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.filePath = const Value.absent(),
    this.finalizedAnalysis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinalReportsCompanion.insert({
    required String id,
    required String examinationId,
    required DateTime generatedAt,
    required String filePath,
    required String finalizedAnalysis,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       examinationId = Value(examinationId),
       generatedAt = Value(generatedAt),
       filePath = Value(filePath),
       finalizedAnalysis = Value(finalizedAnalysis);
  static Insertable<FinalReport> custom({
    Expression<String>? id,
    Expression<String>? examinationId,
    Expression<DateTime>? generatedAt,
    Expression<String>? filePath,
    Expression<String>? finalizedAnalysis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examinationId != null) 'examination_id': examinationId,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (filePath != null) 'file_path': filePath,
      if (finalizedAnalysis != null) 'finalized_analysis': finalizedAnalysis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinalReportsCompanion copyWith({
    Value<String>? id,
    Value<String>? examinationId,
    Value<DateTime>? generatedAt,
    Value<String>? filePath,
    Value<String>? finalizedAnalysis,
    Value<int>? rowid,
  }) {
    return FinalReportsCompanion(
      id: id ?? this.id,
      examinationId: examinationId ?? this.examinationId,
      generatedAt: generatedAt ?? this.generatedAt,
      filePath: filePath ?? this.filePath,
      finalizedAnalysis: finalizedAnalysis ?? this.finalizedAnalysis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examinationId.present) {
      map['examination_id'] = Variable<String>(examinationId.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (finalizedAnalysis.present) {
      map['finalized_analysis'] = Variable<String>(finalizedAnalysis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinalReportsCompanion(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('filePath: $filePath, ')
          ..write('finalizedAnalysis: $finalizedAnalysis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncItemsTable extends SyncItems
    with TableInfo<$SyncItemsTable, SyncItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localVersionMeta = const VerificationMeta(
    'localVersion',
  );
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
    'local_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cloudVersionMeta = const VerificationMeta(
    'cloudVersion',
  );
  @override
  late final GeneratedColumn<int> cloudVersion = GeneratedColumn<int>(
    'cloud_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityId,
    entityType,
    localVersion,
    cloudVersion,
    syncStatus,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('local_version')) {
      context.handle(
        _localVersionMeta,
        localVersion.isAcceptableOrUnknown(
          data['local_version']!,
          _localVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localVersionMeta);
    }
    if (data.containsKey('cloud_version')) {
      context.handle(
        _cloudVersionMeta,
        cloudVersion.isAcceptableOrUnknown(
          data['cloud_version']!,
          _cloudVersionMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      localVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_version'],
      )!,
      cloudVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cloud_version'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncItemsTable createAlias(String alias) {
    return $SyncItemsTable(attachedDatabase, alias);
  }
}

class SyncItem extends DataClass implements Insertable<SyncItem> {
  final String id;
  final String entityId;
  final String entityType;
  final int localVersion;
  final int? cloudVersion;
  final String syncStatus;
  final DateTime updatedAt;
  const SyncItem({
    required this.id,
    required this.entityId,
    required this.entityType,
    required this.localVersion,
    this.cloudVersion,
    required this.syncStatus,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_id'] = Variable<String>(entityId);
    map['entity_type'] = Variable<String>(entityType);
    map['local_version'] = Variable<int>(localVersion);
    if (!nullToAbsent || cloudVersion != null) {
      map['cloud_version'] = Variable<int>(cloudVersion);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncItemsCompanion toCompanion(bool nullToAbsent) {
    return SyncItemsCompanion(
      id: Value(id),
      entityId: Value(entityId),
      entityType: Value(entityType),
      localVersion: Value(localVersion),
      cloudVersion: cloudVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudVersion),
      syncStatus: Value(syncStatus),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncItem(
      id: serializer.fromJson<String>(json['id']),
      entityId: serializer.fromJson<String>(json['entityId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      cloudVersion: serializer.fromJson<int?>(json['cloudVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityId': serializer.toJson<String>(entityId),
      'entityType': serializer.toJson<String>(entityType),
      'localVersion': serializer.toJson<int>(localVersion),
      'cloudVersion': serializer.toJson<int?>(cloudVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncItem copyWith({
    String? id,
    String? entityId,
    String? entityType,
    int? localVersion,
    Value<int?> cloudVersion = const Value.absent(),
    String? syncStatus,
    DateTime? updatedAt,
  }) => SyncItem(
    id: id ?? this.id,
    entityId: entityId ?? this.entityId,
    entityType: entityType ?? this.entityType,
    localVersion: localVersion ?? this.localVersion,
    cloudVersion: cloudVersion.present ? cloudVersion.value : this.cloudVersion,
    syncStatus: syncStatus ?? this.syncStatus,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncItem copyWithCompanion(SyncItemsCompanion data) {
    return SyncItem(
      id: data.id.present ? data.id.value : this.id,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      cloudVersion: data.cloudVersion.present
          ? data.cloudVersion.value
          : this.cloudVersion,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncItem(')
          ..write('id: $id, ')
          ..write('entityId: $entityId, ')
          ..write('entityType: $entityType, ')
          ..write('localVersion: $localVersion, ')
          ..write('cloudVersion: $cloudVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityId,
    entityType,
    localVersion,
    cloudVersion,
    syncStatus,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncItem &&
          other.id == this.id &&
          other.entityId == this.entityId &&
          other.entityType == this.entityType &&
          other.localVersion == this.localVersion &&
          other.cloudVersion == this.cloudVersion &&
          other.syncStatus == this.syncStatus &&
          other.updatedAt == this.updatedAt);
}

class SyncItemsCompanion extends UpdateCompanion<SyncItem> {
  final Value<String> id;
  final Value<String> entityId;
  final Value<String> entityType;
  final Value<int> localVersion;
  final Value<int?> cloudVersion;
  final Value<String> syncStatus;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncItemsCompanion({
    this.id = const Value.absent(),
    this.entityId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.cloudVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncItemsCompanion.insert({
    required String id,
    required String entityId,
    required String entityType,
    required int localVersion,
    this.cloudVersion = const Value.absent(),
    required String syncStatus,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityId = Value(entityId),
       entityType = Value(entityType),
       localVersion = Value(localVersion),
       syncStatus = Value(syncStatus),
       updatedAt = Value(updatedAt);
  static Insertable<SyncItem> custom({
    Expression<String>? id,
    Expression<String>? entityId,
    Expression<String>? entityType,
    Expression<int>? localVersion,
    Expression<int>? cloudVersion,
    Expression<String>? syncStatus,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityId != null) 'entity_id': entityId,
      if (entityType != null) 'entity_type': entityType,
      if (localVersion != null) 'local_version': localVersion,
      if (cloudVersion != null) 'cloud_version': cloudVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? entityId,
    Value<String>? entityType,
    Value<int>? localVersion,
    Value<int?>? cloudVersion,
    Value<String>? syncStatus,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncItemsCompanion(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      localVersion: localVersion ?? this.localVersion,
      cloudVersion: cloudVersion ?? this.cloudVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (cloudVersion.present) {
      map['cloud_version'] = Variable<int>(cloudVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncItemsCompanion(')
          ..write('id: $id, ')
          ..write('entityId: $entityId, ')
          ..write('entityType: $entityType, ')
          ..write('localVersion: $localVersion, ')
          ..write('cloudVersion: $cloudVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$WisteriaDatabase extends GeneratedDatabase {
  _$WisteriaDatabase(QueryExecutor e) : super(e);
  $WisteriaDatabaseManager get managers => $WisteriaDatabaseManager(this);
  late final $DoctorProfilesTable doctorProfiles = $DoctorProfilesTable(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $PreviousMedicalInformationsTable previousMedicalInformations =
      $PreviousMedicalInformationsTable(this);
  late final $PreviousMedicationsTable previousMedications =
      $PreviousMedicationsTable(this);
  late final $PreviousTestResultsTable previousTestResults =
      $PreviousTestResultsTable(this);
  late final $ExaminationsTable examinations = $ExaminationsTable(this);
  late final $MedicalImagesTable medicalImages = $MedicalImagesTable(this);
  late final $MedicalModelsTable medicalModels = $MedicalModelsTable(this);
  late final $ModelVersionsTable modelVersions = $ModelVersionsTable(this);
  late final $ModelRunsTable modelRuns = $ModelRunsTable(this);
  late final $ModelRunResultsTable modelRunResults = $ModelRunResultsTable(
    this,
  );
  late final $ModelFindingsTable modelFindings = $ModelFindingsTable(this);
  late final $AiAnalysesTable aiAnalyses = $AiAnalysesTable(this);
  late final $EvidenceTable evidence = $EvidenceTable(this);
  late final $DoctorReviewsTable doctorReviews = $DoctorReviewsTable(this);
  late final $FinalReportsTable finalReports = $FinalReportsTable(this);
  late final $SyncItemsTable syncItems = $SyncItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    doctorProfiles,
    patients,
    previousMedicalInformations,
    previousMedications,
    previousTestResults,
    examinations,
    medicalImages,
    medicalModels,
    modelVersions,
    modelRuns,
    modelRunResults,
    modelFindings,
    aiAnalyses,
    evidence,
    doctorReviews,
    finalReports,
    syncItems,
  ];
}

typedef $$DoctorProfilesTableCreateCompanionBuilder =
    DoctorProfilesCompanion Function({
      required String id,
      required String doctorName,
      Value<String?> specialization,
      Value<String?> clinicName,
      Value<String?> clinicAddress,
      Value<String?> clinicPhoneNumber,
      Value<String?> email,
      Value<String?> signature,
      Value<String?> documentPath,
      Value<String?> documentFileName,
      Value<int> rowid,
    });
typedef $$DoctorProfilesTableUpdateCompanionBuilder =
    DoctorProfilesCompanion Function({
      Value<String> id,
      Value<String> doctorName,
      Value<String?> specialization,
      Value<String?> clinicName,
      Value<String?> clinicAddress,
      Value<String?> clinicPhoneNumber,
      Value<String?> email,
      Value<String?> signature,
      Value<String?> documentPath,
      Value<String?> documentFileName,
      Value<int> rowid,
    });

class $$DoctorProfilesTableFilterComposer
    extends Composer<_$WisteriaDatabase, $DoctorProfilesTable> {
  $$DoctorProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialization => $composableBuilder(
    column: $table.specialization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clinicName => $composableBuilder(
    column: $table.clinicName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clinicAddress => $composableBuilder(
    column: $table.clinicAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clinicPhoneNumber => $composableBuilder(
    column: $table.clinicPhoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentPath => $composableBuilder(
    column: $table.documentPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentFileName => $composableBuilder(
    column: $table.documentFileName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DoctorProfilesTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $DoctorProfilesTable> {
  $$DoctorProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialization => $composableBuilder(
    column: $table.specialization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clinicName => $composableBuilder(
    column: $table.clinicName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clinicAddress => $composableBuilder(
    column: $table.clinicAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clinicPhoneNumber => $composableBuilder(
    column: $table.clinicPhoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentPath => $composableBuilder(
    column: $table.documentPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentFileName => $composableBuilder(
    column: $table.documentFileName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DoctorProfilesTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $DoctorProfilesTable> {
  $$DoctorProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get doctorName => $composableBuilder(
    column: $table.doctorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get specialization => $composableBuilder(
    column: $table.specialization,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clinicName => $composableBuilder(
    column: $table.clinicName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clinicAddress => $composableBuilder(
    column: $table.clinicAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clinicPhoneNumber => $composableBuilder(
    column: $table.clinicPhoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get signature =>
      $composableBuilder(column: $table.signature, builder: (column) => column);

  GeneratedColumn<String> get documentPath => $composableBuilder(
    column: $table.documentPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get documentFileName => $composableBuilder(
    column: $table.documentFileName,
    builder: (column) => column,
  );
}

class $$DoctorProfilesTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $DoctorProfilesTable,
          DoctorProfile,
          $$DoctorProfilesTableFilterComposer,
          $$DoctorProfilesTableOrderingComposer,
          $$DoctorProfilesTableAnnotationComposer,
          $$DoctorProfilesTableCreateCompanionBuilder,
          $$DoctorProfilesTableUpdateCompanionBuilder,
          (
            DoctorProfile,
            BaseReferences<
              _$WisteriaDatabase,
              $DoctorProfilesTable,
              DoctorProfile
            >,
          ),
          DoctorProfile,
          PrefetchHooks Function()
        > {
  $$DoctorProfilesTableTableManager(
    _$WisteriaDatabase db,
    $DoctorProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoctorProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoctorProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoctorProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> doctorName = const Value.absent(),
                Value<String?> specialization = const Value.absent(),
                Value<String?> clinicName = const Value.absent(),
                Value<String?> clinicAddress = const Value.absent(),
                Value<String?> clinicPhoneNumber = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> signature = const Value.absent(),
                Value<String?> documentPath = const Value.absent(),
                Value<String?> documentFileName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoctorProfilesCompanion(
                id: id,
                doctorName: doctorName,
                specialization: specialization,
                clinicName: clinicName,
                clinicAddress: clinicAddress,
                clinicPhoneNumber: clinicPhoneNumber,
                email: email,
                signature: signature,
                documentPath: documentPath,
                documentFileName: documentFileName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String doctorName,
                Value<String?> specialization = const Value.absent(),
                Value<String?> clinicName = const Value.absent(),
                Value<String?> clinicAddress = const Value.absent(),
                Value<String?> clinicPhoneNumber = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> signature = const Value.absent(),
                Value<String?> documentPath = const Value.absent(),
                Value<String?> documentFileName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoctorProfilesCompanion.insert(
                id: id,
                doctorName: doctorName,
                specialization: specialization,
                clinicName: clinicName,
                clinicAddress: clinicAddress,
                clinicPhoneNumber: clinicPhoneNumber,
                email: email,
                signature: signature,
                documentPath: documentPath,
                documentFileName: documentFileName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DoctorProfilesTable, DoctorProfile>(table),
                  BaseReferences<
                    _$WisteriaDatabase,
                    $DoctorProfilesTable,
                    DoctorProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DoctorProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $DoctorProfilesTable,
      DoctorProfile,
      $$DoctorProfilesTableFilterComposer,
      $$DoctorProfilesTableOrderingComposer,
      $$DoctorProfilesTableAnnotationComposer,
      $$DoctorProfilesTableCreateCompanionBuilder,
      $$DoctorProfilesTableUpdateCompanionBuilder,
      (
        DoctorProfile,
        BaseReferences<_$WisteriaDatabase, $DoctorProfilesTable, DoctorProfile>,
      ),
      DoctorProfile,
      PrefetchHooks Function()
    >;
typedef $$PatientsTableCreateCompanionBuilder =
    PatientsCompanion Function({
      required String id,
      required String name,
      Value<String?> phoneNumber,
      Value<int?> age,
      Value<String?> bloodGroup,
      Value<String?> gender,
      Value<String?> otherContact,
      Value<String?> address,
      Value<int> rowid,
    });
typedef $$PatientsTableUpdateCompanionBuilder =
    PatientsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> phoneNumber,
      Value<int?> age,
      Value<String?> bloodGroup,
      Value<String?> gender,
      Value<String?> otherContact,
      Value<String?> address,
      Value<int> rowid,
    });

final class $$PatientsTableReferences
    extends BaseReferences<_$WisteriaDatabase, $PatientsTable, Patient> {
  $$PatientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $PreviousMedicalInformationsTable,
    List<PreviousMedicalInformation>
  >
  _previousMedicalInformationsRefsTable(_$WisteriaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.previousMedicalInformations,
        aliasName: 'patients__id__previous_medical_informations__patient_id',
      );

  $$PreviousMedicalInformationsTableProcessedTableManager
  get previousMedicalInformationsRefs {
    final manager = $$PreviousMedicalInformationsTableTableManager(
      $_db,
      $_db.previousMedicalInformations,
    ).filter((f) => f.patientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _previousMedicalInformationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PreviousMedicationsTable,
    List<PreviousMedication>
  >
  _previousMedicationsRefsTable(_$WisteriaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.previousMedications,
        aliasName: 'patients__id__previous_medications__patient_id',
      );

  $$PreviousMedicationsTableProcessedTableManager get previousMedicationsRefs {
    final manager = $$PreviousMedicationsTableTableManager(
      $_db,
      $_db.previousMedications,
    ).filter((f) => f.patientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _previousMedicationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PreviousTestResultsTable,
    List<PreviousTestResult>
  >
  _previousTestResultsRefsTable(_$WisteriaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.previousTestResults,
        aliasName: 'patients__id__previous_test_results__patient_id',
      );

  $$PreviousTestResultsTableProcessedTableManager get previousTestResultsRefs {
    final manager = $$PreviousTestResultsTableTableManager(
      $_db,
      $_db.previousTestResults,
    ).filter((f) => f.patientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _previousTestResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExaminationsTable, List<Examination>>
  _examinationsRefsTable(_$WisteriaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.examinations,
        aliasName: 'patients__id__examinations__patient_id',
      );

  $$ExaminationsTableProcessedTableManager get examinationsRefs {
    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.patientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_examinationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PatientsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get otherContact => $composableBuilder(
    column: $table.otherContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> previousMedicalInformationsRefs(
    Expression<bool> Function(
      $$PreviousMedicalInformationsTableFilterComposer f,
    )
    f,
  ) {
    final $$PreviousMedicalInformationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.previousMedicalInformations,
          getReferencedColumn: (t) => t.patientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PreviousMedicalInformationsTableFilterComposer(
                $db: $db,
                $table: $db.previousMedicalInformations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> previousMedicationsRefs(
    Expression<bool> Function($$PreviousMedicationsTableFilterComposer f) f,
  ) {
    final $$PreviousMedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.previousMedications,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreviousMedicationsTableFilterComposer(
            $db: $db,
            $table: $db.previousMedications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> previousTestResultsRefs(
    Expression<bool> Function($$PreviousTestResultsTableFilterComposer f) f,
  ) {
    final $$PreviousTestResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.previousTestResults,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreviousTestResultsTableFilterComposer(
            $db: $db,
            $table: $db.previousTestResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> examinationsRefs(
    Expression<bool> Function($$ExaminationsTableFilterComposer f) f,
  ) {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PatientsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $PatientsTable> {
  $$PatientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get otherContact => $composableBuilder(
    column: $table.otherContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatientsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $PatientsTable> {
  $$PatientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get otherContact => $composableBuilder(
    column: $table.otherContact,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  Expression<T> previousMedicalInformationsRefs<T extends Object>(
    Expression<T> Function(
      $$PreviousMedicalInformationsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$PreviousMedicalInformationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.previousMedicalInformations,
          getReferencedColumn: (t) => t.patientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PreviousMedicalInformationsTableAnnotationComposer(
                $db: $db,
                $table: $db.previousMedicalInformations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> previousMedicationsRefs<T extends Object>(
    Expression<T> Function($$PreviousMedicationsTableAnnotationComposer a) f,
  ) {
    final $$PreviousMedicationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.previousMedications,
          getReferencedColumn: (t) => t.patientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PreviousMedicationsTableAnnotationComposer(
                $db: $db,
                $table: $db.previousMedications,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> previousTestResultsRefs<T extends Object>(
    Expression<T> Function($$PreviousTestResultsTableAnnotationComposer a) f,
  ) {
    final $$PreviousTestResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.previousTestResults,
          getReferencedColumn: (t) => t.patientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PreviousTestResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.previousTestResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> examinationsRefs<T extends Object>(
    Expression<T> Function($$ExaminationsTableAnnotationComposer a) f,
  ) {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PatientsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $PatientsTable,
          Patient,
          $$PatientsTableFilterComposer,
          $$PatientsTableOrderingComposer,
          $$PatientsTableAnnotationComposer,
          $$PatientsTableCreateCompanionBuilder,
          $$PatientsTableUpdateCompanionBuilder,
          (Patient, $$PatientsTableReferences),
          Patient,
          PrefetchHooks Function({
            bool previousMedicalInformationsRefs,
            bool previousMedicationsRefs,
            bool previousTestResultsRefs,
            bool examinationsRefs,
          })
        > {
  $$PatientsTableTableManager(_$WisteriaDatabase db, $PatientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> bloodGroup = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> otherContact = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatientsCompanion(
                id: id,
                name: name,
                phoneNumber: phoneNumber,
                age: age,
                bloodGroup: bloodGroup,
                gender: gender,
                otherContact: otherContact,
                address: address,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> phoneNumber = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> bloodGroup = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> otherContact = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatientsCompanion.insert(
                id: id,
                name: name,
                phoneNumber: phoneNumber,
                age: age,
                bloodGroup: bloodGroup,
                gender: gender,
                otherContact: otherContact,
                address: address,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PatientsTable, Patient>(table),
                  $$PatientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                previousMedicalInformationsRefs = false,
                previousMedicationsRefs = false,
                previousTestResultsRefs = false,
                examinationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (previousMedicalInformationsRefs)
                      db.previousMedicalInformations,
                    if (previousMedicationsRefs) db.previousMedications,
                    if (previousTestResultsRefs) db.previousTestResults,
                    if (examinationsRefs) db.examinations,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (previousMedicalInformationsRefs)
                        await $_getPrefetchedData<
                          Patient,
                          $PatientsTable,
                          PreviousMedicalInformation
                        >(
                          currentTable: table,
                          referencedTable: $$PatientsTableReferences
                              ._previousMedicalInformationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PatientsTableReferences(
                                db,
                                table,
                                p0,
                              ).previousMedicalInformationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (previousMedicationsRefs)
                        await $_getPrefetchedData<
                          Patient,
                          $PatientsTable,
                          PreviousMedication
                        >(
                          currentTable: table,
                          referencedTable: $$PatientsTableReferences
                              ._previousMedicationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PatientsTableReferences(
                                db,
                                table,
                                p0,
                              ).previousMedicationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (previousTestResultsRefs)
                        await $_getPrefetchedData<
                          Patient,
                          $PatientsTable,
                          PreviousTestResult
                        >(
                          currentTable: table,
                          referencedTable: $$PatientsTableReferences
                              ._previousTestResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PatientsTableReferences(
                                db,
                                table,
                                p0,
                              ).previousTestResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (examinationsRefs)
                        await $_getPrefetchedData<
                          Patient,
                          $PatientsTable,
                          Examination
                        >(
                          currentTable: table,
                          referencedTable: $$PatientsTableReferences
                              ._examinationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PatientsTableReferences(
                                db,
                                table,
                                p0,
                              ).examinationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.patientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PatientsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $PatientsTable,
      Patient,
      $$PatientsTableFilterComposer,
      $$PatientsTableOrderingComposer,
      $$PatientsTableAnnotationComposer,
      $$PatientsTableCreateCompanionBuilder,
      $$PatientsTableUpdateCompanionBuilder,
      (Patient, $$PatientsTableReferences),
      Patient,
      PrefetchHooks Function({
        bool previousMedicalInformationsRefs,
        bool previousMedicationsRefs,
        bool previousTestResultsRefs,
        bool examinationsRefs,
      })
    >;
typedef $$PreviousMedicalInformationsTableCreateCompanionBuilder =
    PreviousMedicalInformationsCompanion Function({
      required String id,
      required String patientId,
      required String title,
      required String description,
      Value<String?> source,
      Value<DateTime?> dateOrPeriod,
      Value<int> rowid,
    });
typedef $$PreviousMedicalInformationsTableUpdateCompanionBuilder =
    PreviousMedicalInformationsCompanion Function({
      Value<String> id,
      Value<String> patientId,
      Value<String> title,
      Value<String> description,
      Value<String?> source,
      Value<DateTime?> dateOrPeriod,
      Value<int> rowid,
    });

final class $$PreviousMedicalInformationsTableReferences
    extends
        BaseReferences<
          _$WisteriaDatabase,
          $PreviousMedicalInformationsTable,
          PreviousMedicalInformation
        > {
  $$PreviousMedicalInformationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PatientsTable _patientIdTable(_$WisteriaDatabase db) => db.patients
      .createAlias('previous_medical_informations__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<String>('patient_id')!;

    final manager = $$PatientsTableTableManager(
      $_db,
      $_db.patients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PreviousMedicalInformationsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $PreviousMedicalInformationsTable> {
  $$PreviousMedicalInformationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOrPeriod => $composableBuilder(
    column: $table.dateOrPeriod,
    builder: (column) => ColumnFilters(column),
  );

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableFilterComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreviousMedicalInformationsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $PreviousMedicalInformationsTable> {
  $$PreviousMedicalInformationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOrPeriod => $composableBuilder(
    column: $table.dateOrPeriod,
    builder: (column) => ColumnOrderings(column),
  );

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableOrderingComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreviousMedicalInformationsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $PreviousMedicalInformationsTable> {
  $$PreviousMedicalInformationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOrPeriod => $composableBuilder(
    column: $table.dateOrPeriod,
    builder: (column) => column,
  );

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableAnnotationComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreviousMedicalInformationsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $PreviousMedicalInformationsTable,
          PreviousMedicalInformation,
          $$PreviousMedicalInformationsTableFilterComposer,
          $$PreviousMedicalInformationsTableOrderingComposer,
          $$PreviousMedicalInformationsTableAnnotationComposer,
          $$PreviousMedicalInformationsTableCreateCompanionBuilder,
          $$PreviousMedicalInformationsTableUpdateCompanionBuilder,
          (
            PreviousMedicalInformation,
            $$PreviousMedicalInformationsTableReferences,
          ),
          PreviousMedicalInformation,
          PrefetchHooks Function({bool patientId})
        > {
  $$PreviousMedicalInformationsTableTableManager(
    _$WisteriaDatabase db,
    $PreviousMedicalInformationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreviousMedicalInformationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PreviousMedicalInformationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PreviousMedicalInformationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<DateTime?> dateOrPeriod = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreviousMedicalInformationsCompanion(
                id: id,
                patientId: patientId,
                title: title,
                description: description,
                source: source,
                dateOrPeriod: dateOrPeriod,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patientId,
                required String title,
                required String description,
                Value<String?> source = const Value.absent(),
                Value<DateTime?> dateOrPeriod = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreviousMedicalInformationsCompanion.insert(
                id: id,
                patientId: patientId,
                title: title,
                description: description,
                source: source,
                dateOrPeriod: dateOrPeriod,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $PreviousMedicalInformationsTable,
                    PreviousMedicalInformation
                  >(table),
                  $$PreviousMedicalInformationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (patientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.patientId,
                                referencedTable:
                                    $$PreviousMedicalInformationsTableReferences
                                        ._patientIdTable(db),
                                referencedColumn:
                                    $$PreviousMedicalInformationsTableReferences
                                        ._patientIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PreviousMedicalInformationsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $PreviousMedicalInformationsTable,
      PreviousMedicalInformation,
      $$PreviousMedicalInformationsTableFilterComposer,
      $$PreviousMedicalInformationsTableOrderingComposer,
      $$PreviousMedicalInformationsTableAnnotationComposer,
      $$PreviousMedicalInformationsTableCreateCompanionBuilder,
      $$PreviousMedicalInformationsTableUpdateCompanionBuilder,
      (
        PreviousMedicalInformation,
        $$PreviousMedicalInformationsTableReferences,
      ),
      PreviousMedicalInformation,
      PrefetchHooks Function({bool patientId})
    >;
typedef $$PreviousMedicationsTableCreateCompanionBuilder =
    PreviousMedicationsCompanion Function({
      required String id,
      required String patientId,
      required String medicineName,
      Value<String?> dosage,
      Value<String?> duration,
      Value<String?> reasonOrCondition,
      Value<String?> source,
      Value<DateTime?> dateOrPeriod,
      Value<int> rowid,
    });
typedef $$PreviousMedicationsTableUpdateCompanionBuilder =
    PreviousMedicationsCompanion Function({
      Value<String> id,
      Value<String> patientId,
      Value<String> medicineName,
      Value<String?> dosage,
      Value<String?> duration,
      Value<String?> reasonOrCondition,
      Value<String?> source,
      Value<DateTime?> dateOrPeriod,
      Value<int> rowid,
    });

final class $$PreviousMedicationsTableReferences
    extends
        BaseReferences<
          _$WisteriaDatabase,
          $PreviousMedicationsTable,
          PreviousMedication
        > {
  $$PreviousMedicationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PatientsTable _patientIdTable(_$WisteriaDatabase db) =>
      db.patients.createAlias('previous_medications__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<String>('patient_id')!;

    final manager = $$PatientsTableTableManager(
      $_db,
      $_db.patients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PreviousMedicationsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $PreviousMedicationsTable> {
  $$PreviousMedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicineName => $composableBuilder(
    column: $table.medicineName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonOrCondition => $composableBuilder(
    column: $table.reasonOrCondition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOrPeriod => $composableBuilder(
    column: $table.dateOrPeriod,
    builder: (column) => ColumnFilters(column),
  );

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableFilterComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreviousMedicationsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $PreviousMedicationsTable> {
  $$PreviousMedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicineName => $composableBuilder(
    column: $table.medicineName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonOrCondition => $composableBuilder(
    column: $table.reasonOrCondition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOrPeriod => $composableBuilder(
    column: $table.dateOrPeriod,
    builder: (column) => ColumnOrderings(column),
  );

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableOrderingComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreviousMedicationsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $PreviousMedicationsTable> {
  $$PreviousMedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get medicineName => $composableBuilder(
    column: $table.medicineName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get reasonOrCondition => $composableBuilder(
    column: $table.reasonOrCondition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOrPeriod => $composableBuilder(
    column: $table.dateOrPeriod,
    builder: (column) => column,
  );

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableAnnotationComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreviousMedicationsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $PreviousMedicationsTable,
          PreviousMedication,
          $$PreviousMedicationsTableFilterComposer,
          $$PreviousMedicationsTableOrderingComposer,
          $$PreviousMedicationsTableAnnotationComposer,
          $$PreviousMedicationsTableCreateCompanionBuilder,
          $$PreviousMedicationsTableUpdateCompanionBuilder,
          (PreviousMedication, $$PreviousMedicationsTableReferences),
          PreviousMedication,
          PrefetchHooks Function({bool patientId})
        > {
  $$PreviousMedicationsTableTableManager(
    _$WisteriaDatabase db,
    $PreviousMedicationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreviousMedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreviousMedicationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PreviousMedicationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<String> medicineName = const Value.absent(),
                Value<String?> dosage = const Value.absent(),
                Value<String?> duration = const Value.absent(),
                Value<String?> reasonOrCondition = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<DateTime?> dateOrPeriod = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreviousMedicationsCompanion(
                id: id,
                patientId: patientId,
                medicineName: medicineName,
                dosage: dosage,
                duration: duration,
                reasonOrCondition: reasonOrCondition,
                source: source,
                dateOrPeriod: dateOrPeriod,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patientId,
                required String medicineName,
                Value<String?> dosage = const Value.absent(),
                Value<String?> duration = const Value.absent(),
                Value<String?> reasonOrCondition = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<DateTime?> dateOrPeriod = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreviousMedicationsCompanion.insert(
                id: id,
                patientId: patientId,
                medicineName: medicineName,
                dosage: dosage,
                duration: duration,
                reasonOrCondition: reasonOrCondition,
                source: source,
                dateOrPeriod: dateOrPeriod,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreviousMedicationsTable, PreviousMedication>(
                    table,
                  ),
                  $$PreviousMedicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (patientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.patientId,
                                referencedTable:
                                    $$PreviousMedicationsTableReferences
                                        ._patientIdTable(db),
                                referencedColumn:
                                    $$PreviousMedicationsTableReferences
                                        ._patientIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PreviousMedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $PreviousMedicationsTable,
      PreviousMedication,
      $$PreviousMedicationsTableFilterComposer,
      $$PreviousMedicationsTableOrderingComposer,
      $$PreviousMedicationsTableAnnotationComposer,
      $$PreviousMedicationsTableCreateCompanionBuilder,
      $$PreviousMedicationsTableUpdateCompanionBuilder,
      (PreviousMedication, $$PreviousMedicationsTableReferences),
      PreviousMedication,
      PrefetchHooks Function({bool patientId})
    >;
typedef $$PreviousTestResultsTableCreateCompanionBuilder =
    PreviousTestResultsCompanion Function({
      required String id,
      required String patientId,
      required String testName,
      Value<String?> category,
      Value<DateTime?> dateTaken,
      Value<String?> hospitalOrClinic,
      Value<String?> summary,
      Value<String?> keyFindings,
      Value<int> rowid,
    });
typedef $$PreviousTestResultsTableUpdateCompanionBuilder =
    PreviousTestResultsCompanion Function({
      Value<String> id,
      Value<String> patientId,
      Value<String> testName,
      Value<String?> category,
      Value<DateTime?> dateTaken,
      Value<String?> hospitalOrClinic,
      Value<String?> summary,
      Value<String?> keyFindings,
      Value<int> rowid,
    });

final class $$PreviousTestResultsTableReferences
    extends
        BaseReferences<
          _$WisteriaDatabase,
          $PreviousTestResultsTable,
          PreviousTestResult
        > {
  $$PreviousTestResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PatientsTable _patientIdTable(_$WisteriaDatabase db) => db.patients
      .createAlias('previous_test_results__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<String>('patient_id')!;

    final manager = $$PatientsTableTableManager(
      $_db,
      $_db.patients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PreviousTestResultsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $PreviousTestResultsTable> {
  $$PreviousTestResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get testName => $composableBuilder(
    column: $table.testName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateTaken => $composableBuilder(
    column: $table.dateTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hospitalOrClinic => $composableBuilder(
    column: $table.hospitalOrClinic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyFindings => $composableBuilder(
    column: $table.keyFindings,
    builder: (column) => ColumnFilters(column),
  );

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableFilterComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreviousTestResultsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $PreviousTestResultsTable> {
  $$PreviousTestResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get testName => $composableBuilder(
    column: $table.testName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateTaken => $composableBuilder(
    column: $table.dateTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hospitalOrClinic => $composableBuilder(
    column: $table.hospitalOrClinic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyFindings => $composableBuilder(
    column: $table.keyFindings,
    builder: (column) => ColumnOrderings(column),
  );

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableOrderingComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreviousTestResultsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $PreviousTestResultsTable> {
  $$PreviousTestResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get testName =>
      $composableBuilder(column: $table.testName, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get dateTaken =>
      $composableBuilder(column: $table.dateTaken, builder: (column) => column);

  GeneratedColumn<String> get hospitalOrClinic => $composableBuilder(
    column: $table.hospitalOrClinic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get keyFindings => $composableBuilder(
    column: $table.keyFindings,
    builder: (column) => column,
  );

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableAnnotationComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreviousTestResultsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $PreviousTestResultsTable,
          PreviousTestResult,
          $$PreviousTestResultsTableFilterComposer,
          $$PreviousTestResultsTableOrderingComposer,
          $$PreviousTestResultsTableAnnotationComposer,
          $$PreviousTestResultsTableCreateCompanionBuilder,
          $$PreviousTestResultsTableUpdateCompanionBuilder,
          (PreviousTestResult, $$PreviousTestResultsTableReferences),
          PreviousTestResult,
          PrefetchHooks Function({bool patientId})
        > {
  $$PreviousTestResultsTableTableManager(
    _$WisteriaDatabase db,
    $PreviousTestResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreviousTestResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreviousTestResultsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PreviousTestResultsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<String> testName = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime?> dateTaken = const Value.absent(),
                Value<String?> hospitalOrClinic = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String?> keyFindings = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreviousTestResultsCompanion(
                id: id,
                patientId: patientId,
                testName: testName,
                category: category,
                dateTaken: dateTaken,
                hospitalOrClinic: hospitalOrClinic,
                summary: summary,
                keyFindings: keyFindings,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patientId,
                required String testName,
                Value<String?> category = const Value.absent(),
                Value<DateTime?> dateTaken = const Value.absent(),
                Value<String?> hospitalOrClinic = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String?> keyFindings = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreviousTestResultsCompanion.insert(
                id: id,
                patientId: patientId,
                testName: testName,
                category: category,
                dateTaken: dateTaken,
                hospitalOrClinic: hospitalOrClinic,
                summary: summary,
                keyFindings: keyFindings,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreviousTestResultsTable, PreviousTestResult>(
                    table,
                  ),
                  $$PreviousTestResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({patientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (patientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.patientId,
                                referencedTable:
                                    $$PreviousTestResultsTableReferences
                                        ._patientIdTable(db),
                                referencedColumn:
                                    $$PreviousTestResultsTableReferences
                                        ._patientIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PreviousTestResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $PreviousTestResultsTable,
      PreviousTestResult,
      $$PreviousTestResultsTableFilterComposer,
      $$PreviousTestResultsTableOrderingComposer,
      $$PreviousTestResultsTableAnnotationComposer,
      $$PreviousTestResultsTableCreateCompanionBuilder,
      $$PreviousTestResultsTableUpdateCompanionBuilder,
      (PreviousTestResult, $$PreviousTestResultsTableReferences),
      PreviousTestResult,
      PrefetchHooks Function({bool patientId})
    >;
typedef $$ExaminationsTableCreateCompanionBuilder =
    ExaminationsCompanion Function({
      required String id,
      required String patientId,
      required String examinationType,
      required DateTime examinationDate,
      Value<String?> doctorNotes,
      required String previousDataRange,
      required String status,
      Value<int> rowid,
    });
typedef $$ExaminationsTableUpdateCompanionBuilder =
    ExaminationsCompanion Function({
      Value<String> id,
      Value<String> patientId,
      Value<String> examinationType,
      Value<DateTime> examinationDate,
      Value<String?> doctorNotes,
      Value<String> previousDataRange,
      Value<String> status,
      Value<int> rowid,
    });

final class $$ExaminationsTableReferences
    extends
        BaseReferences<_$WisteriaDatabase, $ExaminationsTable, Examination> {
  $$ExaminationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$WisteriaDatabase db) =>
      db.patients.createAlias('examinations__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<String>('patient_id')!;

    final manager = $$PatientsTableTableManager(
      $_db,
      $_db.patients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MedicalImagesTable, List<MedicalImage>>
  _medicalImagesRefsTable(_$WisteriaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.medicalImages,
        aliasName: 'examinations__id__medical_images__examination_id',
      );

  $$MedicalImagesTableProcessedTableManager get medicalImagesRefs {
    final manager = $$MedicalImagesTableTableManager(
      $_db,
      $_db.medicalImages,
    ).filter((f) => f.examinationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicalImagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ModelRunsTable, List<ModelRun>>
  _modelRunsRefsTable(_$WisteriaDatabase db) => MultiTypedResultKey.fromTable(
    db.modelRuns,
    aliasName: 'examinations__id__model_runs__examination_id',
  );

  $$ModelRunsTableProcessedTableManager get modelRunsRefs {
    final manager = $$ModelRunsTableTableManager(
      $_db,
      $_db.modelRuns,
    ).filter((f) => f.examinationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_modelRunsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AiAnalysesTable, List<AiAnalyse>>
  _aiAnalysesRefsTable(_$WisteriaDatabase db) => MultiTypedResultKey.fromTable(
    db.aiAnalyses,
    aliasName: 'examinations__id__ai_analyses__examination_id',
  );

  $$AiAnalysesTableProcessedTableManager get aiAnalysesRefs {
    final manager = $$AiAnalysesTableTableManager(
      $_db,
      $_db.aiAnalyses,
    ).filter((f) => f.examinationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_aiAnalysesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DoctorReviewsTable, List<DoctorReview>>
  _doctorReviewsRefsTable(_$WisteriaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.doctorReviews,
        aliasName: 'examinations__id__doctor_reviews__examination_id',
      );

  $$DoctorReviewsTableProcessedTableManager get doctorReviewsRefs {
    final manager = $$DoctorReviewsTableTableManager(
      $_db,
      $_db.doctorReviews,
    ).filter((f) => f.examinationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_doctorReviewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FinalReportsTable, List<FinalReport>>
  _finalReportsRefsTable(_$WisteriaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.finalReports,
        aliasName: 'examinations__id__final_reports__examination_id',
      );

  $$FinalReportsTableProcessedTableManager get finalReportsRefs {
    final manager = $$FinalReportsTableTableManager(
      $_db,
      $_db.finalReports,
    ).filter((f) => f.examinationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_finalReportsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExaminationsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $ExaminationsTable> {
  $$ExaminationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examinationType => $composableBuilder(
    column: $table.examinationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get examinationDate => $composableBuilder(
    column: $table.examinationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorNotes => $composableBuilder(
    column: $table.doctorNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousDataRange => $composableBuilder(
    column: $table.previousDataRange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableFilterComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> medicalImagesRefs(
    Expression<bool> Function($$MedicalImagesTableFilterComposer f) f,
  ) {
    final $$MedicalImagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicalImages,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalImagesTableFilterComposer(
            $db: $db,
            $table: $db.medicalImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> modelRunsRefs(
    Expression<bool> Function($$ModelRunsTableFilterComposer f) f,
  ) {
    final $$ModelRunsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelRuns,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunsTableFilterComposer(
            $db: $db,
            $table: $db.modelRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> aiAnalysesRefs(
    Expression<bool> Function($$AiAnalysesTableFilterComposer f) f,
  ) {
    final $$AiAnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiAnalyses,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiAnalysesTableFilterComposer(
            $db: $db,
            $table: $db.aiAnalyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> doctorReviewsRefs(
    Expression<bool> Function($$DoctorReviewsTableFilterComposer f) f,
  ) {
    final $$DoctorReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doctorReviews,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoctorReviewsTableFilterComposer(
            $db: $db,
            $table: $db.doctorReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> finalReportsRefs(
    Expression<bool> Function($$FinalReportsTableFilterComposer f) f,
  ) {
    final $$FinalReportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finalReports,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinalReportsTableFilterComposer(
            $db: $db,
            $table: $db.finalReports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExaminationsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $ExaminationsTable> {
  $$ExaminationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examinationType => $composableBuilder(
    column: $table.examinationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get examinationDate => $composableBuilder(
    column: $table.examinationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorNotes => $composableBuilder(
    column: $table.doctorNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousDataRange => $composableBuilder(
    column: $table.previousDataRange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableOrderingComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExaminationsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $ExaminationsTable> {
  $$ExaminationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get examinationType => $composableBuilder(
    column: $table.examinationType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get examinationDate => $composableBuilder(
    column: $table.examinationDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctorNotes => $composableBuilder(
    column: $table.doctorNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get previousDataRange => $composableBuilder(
    column: $table.previousDataRange,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableAnnotationComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> medicalImagesRefs<T extends Object>(
    Expression<T> Function($$MedicalImagesTableAnnotationComposer a) f,
  ) {
    final $$MedicalImagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicalImages,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalImagesTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> modelRunsRefs<T extends Object>(
    Expression<T> Function($$ModelRunsTableAnnotationComposer a) f,
  ) {
    final $$ModelRunsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelRuns,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunsTableAnnotationComposer(
            $db: $db,
            $table: $db.modelRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> aiAnalysesRefs<T extends Object>(
    Expression<T> Function($$AiAnalysesTableAnnotationComposer a) f,
  ) {
    final $$AiAnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiAnalyses,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiAnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.aiAnalyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> doctorReviewsRefs<T extends Object>(
    Expression<T> Function($$DoctorReviewsTableAnnotationComposer a) f,
  ) {
    final $$DoctorReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doctorReviews,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoctorReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.doctorReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> finalReportsRefs<T extends Object>(
    Expression<T> Function($$FinalReportsTableAnnotationComposer a) f,
  ) {
    final $$FinalReportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finalReports,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinalReportsTableAnnotationComposer(
            $db: $db,
            $table: $db.finalReports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExaminationsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $ExaminationsTable,
          Examination,
          $$ExaminationsTableFilterComposer,
          $$ExaminationsTableOrderingComposer,
          $$ExaminationsTableAnnotationComposer,
          $$ExaminationsTableCreateCompanionBuilder,
          $$ExaminationsTableUpdateCompanionBuilder,
          (Examination, $$ExaminationsTableReferences),
          Examination,
          PrefetchHooks Function({
            bool patientId,
            bool medicalImagesRefs,
            bool modelRunsRefs,
            bool aiAnalysesRefs,
            bool doctorReviewsRefs,
            bool finalReportsRefs,
          })
        > {
  $$ExaminationsTableTableManager(
    _$WisteriaDatabase db,
    $ExaminationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExaminationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExaminationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExaminationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<String> examinationType = const Value.absent(),
                Value<DateTime> examinationDate = const Value.absent(),
                Value<String?> doctorNotes = const Value.absent(),
                Value<String> previousDataRange = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExaminationsCompanion(
                id: id,
                patientId: patientId,
                examinationType: examinationType,
                examinationDate: examinationDate,
                doctorNotes: doctorNotes,
                previousDataRange: previousDataRange,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String patientId,
                required String examinationType,
                required DateTime examinationDate,
                Value<String?> doctorNotes = const Value.absent(),
                required String previousDataRange,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => ExaminationsCompanion.insert(
                id: id,
                patientId: patientId,
                examinationType: examinationType,
                examinationDate: examinationDate,
                doctorNotes: doctorNotes,
                previousDataRange: previousDataRange,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExaminationsTable, Examination>(table),
                  $$ExaminationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                patientId = false,
                medicalImagesRefs = false,
                modelRunsRefs = false,
                aiAnalysesRefs = false,
                doctorReviewsRefs = false,
                finalReportsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (medicalImagesRefs) db.medicalImages,
                    if (modelRunsRefs) db.modelRuns,
                    if (aiAnalysesRefs) db.aiAnalyses,
                    if (doctorReviewsRefs) db.doctorReviews,
                    if (finalReportsRefs) db.finalReports,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (patientId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.patientId,
                                    referencedTable:
                                        $$ExaminationsTableReferences
                                            ._patientIdTable(db),
                                    referencedColumn:
                                        $$ExaminationsTableReferences
                                            ._patientIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (medicalImagesRefs)
                        await $_getPrefetchedData<
                          Examination,
                          $ExaminationsTable,
                          MedicalImage
                        >(
                          currentTable: table,
                          referencedTable: $$ExaminationsTableReferences
                              ._medicalImagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExaminationsTableReferences(
                                db,
                                table,
                                p0,
                              ).medicalImagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examinationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (modelRunsRefs)
                        await $_getPrefetchedData<
                          Examination,
                          $ExaminationsTable,
                          ModelRun
                        >(
                          currentTable: table,
                          referencedTable: $$ExaminationsTableReferences
                              ._modelRunsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExaminationsTableReferences(
                                db,
                                table,
                                p0,
                              ).modelRunsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examinationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (aiAnalysesRefs)
                        await $_getPrefetchedData<
                          Examination,
                          $ExaminationsTable,
                          AiAnalyse
                        >(
                          currentTable: table,
                          referencedTable: $$ExaminationsTableReferences
                              ._aiAnalysesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExaminationsTableReferences(
                                db,
                                table,
                                p0,
                              ).aiAnalysesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examinationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (doctorReviewsRefs)
                        await $_getPrefetchedData<
                          Examination,
                          $ExaminationsTable,
                          DoctorReview
                        >(
                          currentTable: table,
                          referencedTable: $$ExaminationsTableReferences
                              ._doctorReviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExaminationsTableReferences(
                                db,
                                table,
                                p0,
                              ).doctorReviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examinationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (finalReportsRefs)
                        await $_getPrefetchedData<
                          Examination,
                          $ExaminationsTable,
                          FinalReport
                        >(
                          currentTable: table,
                          referencedTable: $$ExaminationsTableReferences
                              ._finalReportsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExaminationsTableReferences(
                                db,
                                table,
                                p0,
                              ).finalReportsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examinationId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExaminationsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $ExaminationsTable,
      Examination,
      $$ExaminationsTableFilterComposer,
      $$ExaminationsTableOrderingComposer,
      $$ExaminationsTableAnnotationComposer,
      $$ExaminationsTableCreateCompanionBuilder,
      $$ExaminationsTableUpdateCompanionBuilder,
      (Examination, $$ExaminationsTableReferences),
      Examination,
      PrefetchHooks Function({
        bool patientId,
        bool medicalImagesRefs,
        bool modelRunsRefs,
        bool aiAnalysesRefs,
        bool doctorReviewsRefs,
        bool finalReportsRefs,
      })
    >;
typedef $$MedicalImagesTableCreateCompanionBuilder =
    MedicalImagesCompanion Function({
      required String id,
      required String examinationId,
      required String filePath,
      required String originalFileName,
      required String fileFormat,
      required String modality,
      required DateTime clinicalDate,
      Value<int> rowid,
    });
typedef $$MedicalImagesTableUpdateCompanionBuilder =
    MedicalImagesCompanion Function({
      Value<String> id,
      Value<String> examinationId,
      Value<String> filePath,
      Value<String> originalFileName,
      Value<String> fileFormat,
      Value<String> modality,
      Value<DateTime> clinicalDate,
      Value<int> rowid,
    });

final class $$MedicalImagesTableReferences
    extends
        BaseReferences<_$WisteriaDatabase, $MedicalImagesTable, MedicalImage> {
  $$MedicalImagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExaminationsTable _examinationIdTable(_$WisteriaDatabase db) => db
      .examinations
      .createAlias('medical_images__examination_id__examinations__id');

  $$ExaminationsTableProcessedTableManager get examinationId {
    final $_column = $_itemColumn<String>('examination_id')!;

    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examinationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ModelRunsTable, List<ModelRun>>
  _modelRunsRefsTable(_$WisteriaDatabase db) => MultiTypedResultKey.fromTable(
    db.modelRuns,
    aliasName: 'medical_images__id__model_runs__input_image_id',
  );

  $$ModelRunsTableProcessedTableManager get modelRunsRefs {
    final manager = $$ModelRunsTableTableManager(
      $_db,
      $_db.modelRuns,
    ).filter((f) => f.inputImageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_modelRunsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicalImagesTableFilterComposer
    extends Composer<_$WisteriaDatabase, $MedicalImagesTable> {
  $$MedicalImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalFileName => $composableBuilder(
    column: $table.originalFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileFormat => $composableBuilder(
    column: $table.fileFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modality => $composableBuilder(
    column: $table.modality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clinicalDate => $composableBuilder(
    column: $table.clinicalDate,
    builder: (column) => ColumnFilters(column),
  );

  $$ExaminationsTableFilterComposer get examinationId {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> modelRunsRefs(
    Expression<bool> Function($$ModelRunsTableFilterComposer f) f,
  ) {
    final $$ModelRunsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelRuns,
      getReferencedColumn: (t) => t.inputImageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunsTableFilterComposer(
            $db: $db,
            $table: $db.modelRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicalImagesTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $MedicalImagesTable> {
  $$MedicalImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalFileName => $composableBuilder(
    column: $table.originalFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileFormat => $composableBuilder(
    column: $table.fileFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modality => $composableBuilder(
    column: $table.modality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clinicalDate => $composableBuilder(
    column: $table.clinicalDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExaminationsTableOrderingComposer get examinationId {
    final $$ExaminationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableOrderingComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalImagesTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $MedicalImagesTable> {
  $$MedicalImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get originalFileName => $composableBuilder(
    column: $table.originalFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileFormat => $composableBuilder(
    column: $table.fileFormat,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modality =>
      $composableBuilder(column: $table.modality, builder: (column) => column);

  GeneratedColumn<DateTime> get clinicalDate => $composableBuilder(
    column: $table.clinicalDate,
    builder: (column) => column,
  );

  $$ExaminationsTableAnnotationComposer get examinationId {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> modelRunsRefs<T extends Object>(
    Expression<T> Function($$ModelRunsTableAnnotationComposer a) f,
  ) {
    final $$ModelRunsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelRuns,
      getReferencedColumn: (t) => t.inputImageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunsTableAnnotationComposer(
            $db: $db,
            $table: $db.modelRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicalImagesTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $MedicalImagesTable,
          MedicalImage,
          $$MedicalImagesTableFilterComposer,
          $$MedicalImagesTableOrderingComposer,
          $$MedicalImagesTableAnnotationComposer,
          $$MedicalImagesTableCreateCompanionBuilder,
          $$MedicalImagesTableUpdateCompanionBuilder,
          (MedicalImage, $$MedicalImagesTableReferences),
          MedicalImage,
          PrefetchHooks Function({bool examinationId, bool modelRunsRefs})
        > {
  $$MedicalImagesTableTableManager(
    _$WisteriaDatabase db,
    $MedicalImagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> examinationId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> originalFileName = const Value.absent(),
                Value<String> fileFormat = const Value.absent(),
                Value<String> modality = const Value.absent(),
                Value<DateTime> clinicalDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicalImagesCompanion(
                id: id,
                examinationId: examinationId,
                filePath: filePath,
                originalFileName: originalFileName,
                fileFormat: fileFormat,
                modality: modality,
                clinicalDate: clinicalDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String examinationId,
                required String filePath,
                required String originalFileName,
                required String fileFormat,
                required String modality,
                required DateTime clinicalDate,
                Value<int> rowid = const Value.absent(),
              }) => MedicalImagesCompanion.insert(
                id: id,
                examinationId: examinationId,
                filePath: filePath,
                originalFileName: originalFileName,
                fileFormat: fileFormat,
                modality: modality,
                clinicalDate: clinicalDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicalImagesTable, MedicalImage>(table),
                  $$MedicalImagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({examinationId = false, modelRunsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (modelRunsRefs) db.modelRuns],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (examinationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.examinationId,
                                    referencedTable:
                                        $$MedicalImagesTableReferences
                                            ._examinationIdTable(db),
                                    referencedColumn:
                                        $$MedicalImagesTableReferences
                                            ._examinationIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (modelRunsRefs)
                        await $_getPrefetchedData<
                          MedicalImage,
                          $MedicalImagesTable,
                          ModelRun
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalImagesTableReferences
                              ._modelRunsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalImagesTableReferences(
                                db,
                                table,
                                p0,
                              ).modelRunsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.inputImageId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicalImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $MedicalImagesTable,
      MedicalImage,
      $$MedicalImagesTableFilterComposer,
      $$MedicalImagesTableOrderingComposer,
      $$MedicalImagesTableAnnotationComposer,
      $$MedicalImagesTableCreateCompanionBuilder,
      $$MedicalImagesTableUpdateCompanionBuilder,
      (MedicalImage, $$MedicalImagesTableReferences),
      MedicalImage,
      PrefetchHooks Function({bool examinationId, bool modelRunsRefs})
    >;
typedef $$MedicalModelsTableCreateCompanionBuilder =
    MedicalModelsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      required String task,
      required String modality,
      required String runtime,
      Value<int> rowid,
    });
typedef $$MedicalModelsTableUpdateCompanionBuilder =
    MedicalModelsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String> task,
      Value<String> modality,
      Value<String> runtime,
      Value<int> rowid,
    });

final class $$MedicalModelsTableReferences
    extends
        BaseReferences<_$WisteriaDatabase, $MedicalModelsTable, MedicalModel> {
  $$MedicalModelsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ModelVersionsTable, List<ModelVersion>>
  _modelVersionsRefsTable(_$WisteriaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.modelVersions,
        aliasName: 'medical_models__id__model_versions__model_id',
      );

  $$ModelVersionsTableProcessedTableManager get modelVersionsRefs {
    final manager = $$ModelVersionsTableTableManager(
      $_db,
      $_db.modelVersions,
    ).filter((f) => f.modelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_modelVersionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ModelRunsTable, List<ModelRun>>
  _modelRunsRefsTable(_$WisteriaDatabase db) => MultiTypedResultKey.fromTable(
    db.modelRuns,
    aliasName: 'medical_models__id__model_runs__model_id',
  );

  $$ModelRunsTableProcessedTableManager get modelRunsRefs {
    final manager = $$ModelRunsTableTableManager(
      $_db,
      $_db.modelRuns,
    ).filter((f) => f.modelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_modelRunsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicalModelsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $MedicalModelsTable> {
  $$MedicalModelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get task => $composableBuilder(
    column: $table.task,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modality => $composableBuilder(
    column: $table.modality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get runtime => $composableBuilder(
    column: $table.runtime,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> modelVersionsRefs(
    Expression<bool> Function($$ModelVersionsTableFilterComposer f) f,
  ) {
    final $$ModelVersionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelVersions,
      getReferencedColumn: (t) => t.modelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelVersionsTableFilterComposer(
            $db: $db,
            $table: $db.modelVersions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> modelRunsRefs(
    Expression<bool> Function($$ModelRunsTableFilterComposer f) f,
  ) {
    final $$ModelRunsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelRuns,
      getReferencedColumn: (t) => t.modelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunsTableFilterComposer(
            $db: $db,
            $table: $db.modelRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicalModelsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $MedicalModelsTable> {
  $$MedicalModelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get task => $composableBuilder(
    column: $table.task,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modality => $composableBuilder(
    column: $table.modality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get runtime => $composableBuilder(
    column: $table.runtime,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicalModelsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $MedicalModelsTable> {
  $$MedicalModelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get task =>
      $composableBuilder(column: $table.task, builder: (column) => column);

  GeneratedColumn<String> get modality =>
      $composableBuilder(column: $table.modality, builder: (column) => column);

  GeneratedColumn<String> get runtime =>
      $composableBuilder(column: $table.runtime, builder: (column) => column);

  Expression<T> modelVersionsRefs<T extends Object>(
    Expression<T> Function($$ModelVersionsTableAnnotationComposer a) f,
  ) {
    final $$ModelVersionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelVersions,
      getReferencedColumn: (t) => t.modelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelVersionsTableAnnotationComposer(
            $db: $db,
            $table: $db.modelVersions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> modelRunsRefs<T extends Object>(
    Expression<T> Function($$ModelRunsTableAnnotationComposer a) f,
  ) {
    final $$ModelRunsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelRuns,
      getReferencedColumn: (t) => t.modelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunsTableAnnotationComposer(
            $db: $db,
            $table: $db.modelRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicalModelsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $MedicalModelsTable,
          MedicalModel,
          $$MedicalModelsTableFilterComposer,
          $$MedicalModelsTableOrderingComposer,
          $$MedicalModelsTableAnnotationComposer,
          $$MedicalModelsTableCreateCompanionBuilder,
          $$MedicalModelsTableUpdateCompanionBuilder,
          (MedicalModel, $$MedicalModelsTableReferences),
          MedicalModel,
          PrefetchHooks Function({bool modelVersionsRefs, bool modelRunsRefs})
        > {
  $$MedicalModelsTableTableManager(
    _$WisteriaDatabase db,
    $MedicalModelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalModelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalModelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalModelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> task = const Value.absent(),
                Value<String> modality = const Value.absent(),
                Value<String> runtime = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicalModelsCompanion(
                id: id,
                name: name,
                description: description,
                task: task,
                modality: modality,
                runtime: runtime,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required String task,
                required String modality,
                required String runtime,
                Value<int> rowid = const Value.absent(),
              }) => MedicalModelsCompanion.insert(
                id: id,
                name: name,
                description: description,
                task: task,
                modality: modality,
                runtime: runtime,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicalModelsTable, MedicalModel>(table),
                  $$MedicalModelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({modelVersionsRefs = false, modelRunsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (modelVersionsRefs) db.modelVersions,
                    if (modelRunsRefs) db.modelRuns,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (modelVersionsRefs)
                        await $_getPrefetchedData<
                          MedicalModel,
                          $MedicalModelsTable,
                          ModelVersion
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalModelsTableReferences
                              ._modelVersionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalModelsTableReferences(
                                db,
                                table,
                                p0,
                              ).modelVersionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modelId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (modelRunsRefs)
                        await $_getPrefetchedData<
                          MedicalModel,
                          $MedicalModelsTable,
                          ModelRun
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalModelsTableReferences
                              ._modelRunsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalModelsTableReferences(
                                db,
                                table,
                                p0,
                              ).modelRunsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modelId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicalModelsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $MedicalModelsTable,
      MedicalModel,
      $$MedicalModelsTableFilterComposer,
      $$MedicalModelsTableOrderingComposer,
      $$MedicalModelsTableAnnotationComposer,
      $$MedicalModelsTableCreateCompanionBuilder,
      $$MedicalModelsTableUpdateCompanionBuilder,
      (MedicalModel, $$MedicalModelsTableReferences),
      MedicalModel,
      PrefetchHooks Function({bool modelVersionsRefs, bool modelRunsRefs})
    >;
typedef $$ModelVersionsTableCreateCompanionBuilder =
    ModelVersionsCompanion Function({
      required String id,
      required String modelId,
      required String version,
      required String filePath,
      required String checksum,
      Value<String?> compatibility,
      required String installationStatus,
      Value<int> rowid,
    });
typedef $$ModelVersionsTableUpdateCompanionBuilder =
    ModelVersionsCompanion Function({
      Value<String> id,
      Value<String> modelId,
      Value<String> version,
      Value<String> filePath,
      Value<String> checksum,
      Value<String?> compatibility,
      Value<String> installationStatus,
      Value<int> rowid,
    });

final class $$ModelVersionsTableReferences
    extends
        BaseReferences<_$WisteriaDatabase, $ModelVersionsTable, ModelVersion> {
  $$ModelVersionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicalModelsTable _modelIdTable(_$WisteriaDatabase db) => db
      .medicalModels
      .createAlias('model_versions__model_id__medical_models__id');

  $$MedicalModelsTableProcessedTableManager get modelId {
    final $_column = $_itemColumn<String>('model_id')!;

    final manager = $$MedicalModelsTableTableManager(
      $_db,
      $_db.medicalModels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ModelRunsTable, List<ModelRun>>
  _modelRunsRefsTable(_$WisteriaDatabase db) => MultiTypedResultKey.fromTable(
    db.modelRuns,
    aliasName: 'model_versions__id__model_runs__model_version_id',
  );

  $$ModelRunsTableProcessedTableManager get modelRunsRefs {
    final manager = $$ModelRunsTableTableManager(
      $_db,
      $_db.modelRuns,
    ).filter((f) => f.modelVersionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_modelRunsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ModelVersionsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $ModelVersionsTable> {
  $$ModelVersionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get compatibility => $composableBuilder(
    column: $table.compatibility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get installationStatus => $composableBuilder(
    column: $table.installationStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalModelsTableFilterComposer get modelId {
    final $$MedicalModelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelId,
      referencedTable: $db.medicalModels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalModelsTableFilterComposer(
            $db: $db,
            $table: $db.medicalModels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> modelRunsRefs(
    Expression<bool> Function($$ModelRunsTableFilterComposer f) f,
  ) {
    final $$ModelRunsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelRuns,
      getReferencedColumn: (t) => t.modelVersionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunsTableFilterComposer(
            $db: $db,
            $table: $db.modelRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModelVersionsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $ModelVersionsTable> {
  $$ModelVersionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get compatibility => $composableBuilder(
    column: $table.compatibility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get installationStatus => $composableBuilder(
    column: $table.installationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalModelsTableOrderingComposer get modelId {
    final $$MedicalModelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelId,
      referencedTable: $db.medicalModels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalModelsTableOrderingComposer(
            $db: $db,
            $table: $db.medicalModels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModelVersionsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $ModelVersionsTable> {
  $$ModelVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<String> get compatibility => $composableBuilder(
    column: $table.compatibility,
    builder: (column) => column,
  );

  GeneratedColumn<String> get installationStatus => $composableBuilder(
    column: $table.installationStatus,
    builder: (column) => column,
  );

  $$MedicalModelsTableAnnotationComposer get modelId {
    final $$MedicalModelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelId,
      referencedTable: $db.medicalModels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalModelsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalModels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> modelRunsRefs<T extends Object>(
    Expression<T> Function($$ModelRunsTableAnnotationComposer a) f,
  ) {
    final $$ModelRunsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelRuns,
      getReferencedColumn: (t) => t.modelVersionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunsTableAnnotationComposer(
            $db: $db,
            $table: $db.modelRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModelVersionsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $ModelVersionsTable,
          ModelVersion,
          $$ModelVersionsTableFilterComposer,
          $$ModelVersionsTableOrderingComposer,
          $$ModelVersionsTableAnnotationComposer,
          $$ModelVersionsTableCreateCompanionBuilder,
          $$ModelVersionsTableUpdateCompanionBuilder,
          (ModelVersion, $$ModelVersionsTableReferences),
          ModelVersion,
          PrefetchHooks Function({bool modelId, bool modelRunsRefs})
        > {
  $$ModelVersionsTableTableManager(
    _$WisteriaDatabase db,
    $ModelVersionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelVersionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelVersionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelVersionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> modelId = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> checksum = const Value.absent(),
                Value<String?> compatibility = const Value.absent(),
                Value<String> installationStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModelVersionsCompanion(
                id: id,
                modelId: modelId,
                version: version,
                filePath: filePath,
                checksum: checksum,
                compatibility: compatibility,
                installationStatus: installationStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String modelId,
                required String version,
                required String filePath,
                required String checksum,
                Value<String?> compatibility = const Value.absent(),
                required String installationStatus,
                Value<int> rowid = const Value.absent(),
              }) => ModelVersionsCompanion.insert(
                id: id,
                modelId: modelId,
                version: version,
                filePath: filePath,
                checksum: checksum,
                compatibility: compatibility,
                installationStatus: installationStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ModelVersionsTable, ModelVersion>(table),
                  $$ModelVersionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({modelId = false, modelRunsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (modelRunsRefs) db.modelRuns],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (modelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.modelId,
                                referencedTable: $$ModelVersionsTableReferences
                                    ._modelIdTable(db),
                                referencedColumn: $$ModelVersionsTableReferences
                                    ._modelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (modelRunsRefs)
                    await $_getPrefetchedData<
                      ModelVersion,
                      $ModelVersionsTable,
                      ModelRun
                    >(
                      currentTable: table,
                      referencedTable: $$ModelVersionsTableReferences
                          ._modelRunsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ModelVersionsTableReferences(
                            db,
                            table,
                            p0,
                          ).modelRunsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.modelVersionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ModelVersionsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $ModelVersionsTable,
      ModelVersion,
      $$ModelVersionsTableFilterComposer,
      $$ModelVersionsTableOrderingComposer,
      $$ModelVersionsTableAnnotationComposer,
      $$ModelVersionsTableCreateCompanionBuilder,
      $$ModelVersionsTableUpdateCompanionBuilder,
      (ModelVersion, $$ModelVersionsTableReferences),
      ModelVersion,
      PrefetchHooks Function({bool modelId, bool modelRunsRefs})
    >;
typedef $$ModelRunsTableCreateCompanionBuilder =
    ModelRunsCompanion Function({
      required String id,
      required String examinationId,
      required String modelId,
      required String modelVersionId,
      required String inputImageId,
      required DateTime inputImageDate,
      required DateTime executionTimestamp,
      Value<int> rowid,
    });
typedef $$ModelRunsTableUpdateCompanionBuilder =
    ModelRunsCompanion Function({
      Value<String> id,
      Value<String> examinationId,
      Value<String> modelId,
      Value<String> modelVersionId,
      Value<String> inputImageId,
      Value<DateTime> inputImageDate,
      Value<DateTime> executionTimestamp,
      Value<int> rowid,
    });

final class $$ModelRunsTableReferences
    extends BaseReferences<_$WisteriaDatabase, $ModelRunsTable, ModelRun> {
  $$ModelRunsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExaminationsTable _examinationIdTable(_$WisteriaDatabase db) => db
      .examinations
      .createAlias('model_runs__examination_id__examinations__id');

  $$ExaminationsTableProcessedTableManager get examinationId {
    final $_column = $_itemColumn<String>('examination_id')!;

    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examinationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MedicalModelsTable _modelIdTable(_$WisteriaDatabase db) =>
      db.medicalModels.createAlias('model_runs__model_id__medical_models__id');

  $$MedicalModelsTableProcessedTableManager get modelId {
    final $_column = $_itemColumn<String>('model_id')!;

    final manager = $$MedicalModelsTableTableManager(
      $_db,
      $_db.medicalModels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ModelVersionsTable _modelVersionIdTable(_$WisteriaDatabase db) => db
      .modelVersions
      .createAlias('model_runs__model_version_id__model_versions__id');

  $$ModelVersionsTableProcessedTableManager get modelVersionId {
    final $_column = $_itemColumn<String>('model_version_id')!;

    final manager = $$ModelVersionsTableTableManager(
      $_db,
      $_db.modelVersions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modelVersionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MedicalImagesTable _inputImageIdTable(_$WisteriaDatabase db) => db
      .medicalImages
      .createAlias('model_runs__input_image_id__medical_images__id');

  $$MedicalImagesTableProcessedTableManager get inputImageId {
    final $_column = $_itemColumn<String>('input_image_id')!;

    final manager = $$MedicalImagesTableTableManager(
      $_db,
      $_db.medicalImages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inputImageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ModelRunResultsTable, List<ModelRunResult>>
  _modelRunResultsRefsTable(_$WisteriaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.modelRunResults,
        aliasName: 'model_runs__id__model_run_results__model_run_id',
      );

  $$ModelRunResultsTableProcessedTableManager get modelRunResultsRefs {
    final manager = $$ModelRunResultsTableTableManager(
      $_db,
      $_db.modelRunResults,
    ).filter((f) => f.modelRunId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _modelRunResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ModelRunsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $ModelRunsTable> {
  $$ModelRunsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get inputImageDate => $composableBuilder(
    column: $table.inputImageDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get executionTimestamp => $composableBuilder(
    column: $table.executionTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$ExaminationsTableFilterComposer get examinationId {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicalModelsTableFilterComposer get modelId {
    final $$MedicalModelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelId,
      referencedTable: $db.medicalModels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalModelsTableFilterComposer(
            $db: $db,
            $table: $db.medicalModels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelVersionsTableFilterComposer get modelVersionId {
    final $$ModelVersionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelVersionId,
      referencedTable: $db.modelVersions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelVersionsTableFilterComposer(
            $db: $db,
            $table: $db.modelVersions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicalImagesTableFilterComposer get inputImageId {
    final $$MedicalImagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inputImageId,
      referencedTable: $db.medicalImages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalImagesTableFilterComposer(
            $db: $db,
            $table: $db.medicalImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> modelRunResultsRefs(
    Expression<bool> Function($$ModelRunResultsTableFilterComposer f) f,
  ) {
    final $$ModelRunResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelRunResults,
      getReferencedColumn: (t) => t.modelRunId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunResultsTableFilterComposer(
            $db: $db,
            $table: $db.modelRunResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModelRunsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $ModelRunsTable> {
  $$ModelRunsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get inputImageDate => $composableBuilder(
    column: $table.inputImageDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get executionTimestamp => $composableBuilder(
    column: $table.executionTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExaminationsTableOrderingComposer get examinationId {
    final $$ExaminationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableOrderingComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicalModelsTableOrderingComposer get modelId {
    final $$MedicalModelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelId,
      referencedTable: $db.medicalModels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalModelsTableOrderingComposer(
            $db: $db,
            $table: $db.medicalModels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelVersionsTableOrderingComposer get modelVersionId {
    final $$ModelVersionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelVersionId,
      referencedTable: $db.modelVersions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelVersionsTableOrderingComposer(
            $db: $db,
            $table: $db.modelVersions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicalImagesTableOrderingComposer get inputImageId {
    final $$MedicalImagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inputImageId,
      referencedTable: $db.medicalImages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalImagesTableOrderingComposer(
            $db: $db,
            $table: $db.medicalImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModelRunsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $ModelRunsTable> {
  $$ModelRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get inputImageDate => $composableBuilder(
    column: $table.inputImageDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get executionTimestamp => $composableBuilder(
    column: $table.executionTimestamp,
    builder: (column) => column,
  );

  $$ExaminationsTableAnnotationComposer get examinationId {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicalModelsTableAnnotationComposer get modelId {
    final $$MedicalModelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelId,
      referencedTable: $db.medicalModels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalModelsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalModels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelVersionsTableAnnotationComposer get modelVersionId {
    final $$ModelVersionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelVersionId,
      referencedTable: $db.modelVersions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelVersionsTableAnnotationComposer(
            $db: $db,
            $table: $db.modelVersions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicalImagesTableAnnotationComposer get inputImageId {
    final $$MedicalImagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inputImageId,
      referencedTable: $db.medicalImages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalImagesTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> modelRunResultsRefs<T extends Object>(
    Expression<T> Function($$ModelRunResultsTableAnnotationComposer a) f,
  ) {
    final $$ModelRunResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelRunResults,
      getReferencedColumn: (t) => t.modelRunId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.modelRunResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModelRunsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $ModelRunsTable,
          ModelRun,
          $$ModelRunsTableFilterComposer,
          $$ModelRunsTableOrderingComposer,
          $$ModelRunsTableAnnotationComposer,
          $$ModelRunsTableCreateCompanionBuilder,
          $$ModelRunsTableUpdateCompanionBuilder,
          (ModelRun, $$ModelRunsTableReferences),
          ModelRun,
          PrefetchHooks Function({
            bool examinationId,
            bool modelId,
            bool modelVersionId,
            bool inputImageId,
            bool modelRunResultsRefs,
          })
        > {
  $$ModelRunsTableTableManager(_$WisteriaDatabase db, $ModelRunsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> examinationId = const Value.absent(),
                Value<String> modelId = const Value.absent(),
                Value<String> modelVersionId = const Value.absent(),
                Value<String> inputImageId = const Value.absent(),
                Value<DateTime> inputImageDate = const Value.absent(),
                Value<DateTime> executionTimestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModelRunsCompanion(
                id: id,
                examinationId: examinationId,
                modelId: modelId,
                modelVersionId: modelVersionId,
                inputImageId: inputImageId,
                inputImageDate: inputImageDate,
                executionTimestamp: executionTimestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String examinationId,
                required String modelId,
                required String modelVersionId,
                required String inputImageId,
                required DateTime inputImageDate,
                required DateTime executionTimestamp,
                Value<int> rowid = const Value.absent(),
              }) => ModelRunsCompanion.insert(
                id: id,
                examinationId: examinationId,
                modelId: modelId,
                modelVersionId: modelVersionId,
                inputImageId: inputImageId,
                inputImageDate: inputImageDate,
                executionTimestamp: executionTimestamp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ModelRunsTable, ModelRun>(table),
                  $$ModelRunsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                examinationId = false,
                modelId = false,
                modelVersionId = false,
                inputImageId = false,
                modelRunResultsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (modelRunResultsRefs) db.modelRunResults,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (examinationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.examinationId,
                                    referencedTable: $$ModelRunsTableReferences
                                        ._examinationIdTable(db),
                                    referencedColumn: $$ModelRunsTableReferences
                                        ._examinationIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (modelId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.modelId,
                                    referencedTable: $$ModelRunsTableReferences
                                        ._modelIdTable(db),
                                    referencedColumn: $$ModelRunsTableReferences
                                        ._modelIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (modelVersionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.modelVersionId,
                                    referencedTable: $$ModelRunsTableReferences
                                        ._modelVersionIdTable(db),
                                    referencedColumn: $$ModelRunsTableReferences
                                        ._modelVersionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (inputImageId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.inputImageId,
                                    referencedTable: $$ModelRunsTableReferences
                                        ._inputImageIdTable(db),
                                    referencedColumn: $$ModelRunsTableReferences
                                        ._inputImageIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (modelRunResultsRefs)
                        await $_getPrefetchedData<
                          ModelRun,
                          $ModelRunsTable,
                          ModelRunResult
                        >(
                          currentTable: table,
                          referencedTable: $$ModelRunsTableReferences
                              ._modelRunResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModelRunsTableReferences(
                                db,
                                table,
                                p0,
                              ).modelRunResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modelRunId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ModelRunsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $ModelRunsTable,
      ModelRun,
      $$ModelRunsTableFilterComposer,
      $$ModelRunsTableOrderingComposer,
      $$ModelRunsTableAnnotationComposer,
      $$ModelRunsTableCreateCompanionBuilder,
      $$ModelRunsTableUpdateCompanionBuilder,
      (ModelRun, $$ModelRunsTableReferences),
      ModelRun,
      PrefetchHooks Function({
        bool examinationId,
        bool modelId,
        bool modelVersionId,
        bool inputImageId,
        bool modelRunResultsRefs,
      })
    >;
typedef $$ModelRunResultsTableCreateCompanionBuilder =
    ModelRunResultsCompanion Function({
      required String id,
      required String modelRunId,
      required String status,
      Value<String?> confidence,
      Value<String?> uncertainty,
      Value<String?> rawModelOutput,
      Value<int> rowid,
    });
typedef $$ModelRunResultsTableUpdateCompanionBuilder =
    ModelRunResultsCompanion Function({
      Value<String> id,
      Value<String> modelRunId,
      Value<String> status,
      Value<String?> confidence,
      Value<String?> uncertainty,
      Value<String?> rawModelOutput,
      Value<int> rowid,
    });

final class $$ModelRunResultsTableReferences
    extends
        BaseReferences<
          _$WisteriaDatabase,
          $ModelRunResultsTable,
          ModelRunResult
        > {
  $$ModelRunResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ModelRunsTable _modelRunIdTable(_$WisteriaDatabase db) => db.modelRuns
      .createAlias('model_run_results__model_run_id__model_runs__id');

  $$ModelRunsTableProcessedTableManager get modelRunId {
    final $_column = $_itemColumn<String>('model_run_id')!;

    final manager = $$ModelRunsTableTableManager(
      $_db,
      $_db.modelRuns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modelRunIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ModelFindingsTable, List<ModelFinding>>
  _modelFindingsRefsTable(_$WisteriaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.modelFindings,
        aliasName: 'model_run_results__id__model_findings__model_run_result_id',
      );

  $$ModelFindingsTableProcessedTableManager get modelFindingsRefs {
    final manager = $$ModelFindingsTableTableManager($_db, $_db.modelFindings)
        .filter(
          (f) => f.modelRunResultId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_modelFindingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ModelRunResultsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $ModelRunResultsTable> {
  $$ModelRunResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uncertainty => $composableBuilder(
    column: $table.uncertainty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawModelOutput => $composableBuilder(
    column: $table.rawModelOutput,
    builder: (column) => ColumnFilters(column),
  );

  $$ModelRunsTableFilterComposer get modelRunId {
    final $$ModelRunsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelRunId,
      referencedTable: $db.modelRuns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunsTableFilterComposer(
            $db: $db,
            $table: $db.modelRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> modelFindingsRefs(
    Expression<bool> Function($$ModelFindingsTableFilterComposer f) f,
  ) {
    final $$ModelFindingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelFindings,
      getReferencedColumn: (t) => t.modelRunResultId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelFindingsTableFilterComposer(
            $db: $db,
            $table: $db.modelFindings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModelRunResultsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $ModelRunResultsTable> {
  $$ModelRunResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uncertainty => $composableBuilder(
    column: $table.uncertainty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawModelOutput => $composableBuilder(
    column: $table.rawModelOutput,
    builder: (column) => ColumnOrderings(column),
  );

  $$ModelRunsTableOrderingComposer get modelRunId {
    final $$ModelRunsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelRunId,
      referencedTable: $db.modelRuns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunsTableOrderingComposer(
            $db: $db,
            $table: $db.modelRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModelRunResultsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $ModelRunResultsTable> {
  $$ModelRunResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uncertainty => $composableBuilder(
    column: $table.uncertainty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawModelOutput => $composableBuilder(
    column: $table.rawModelOutput,
    builder: (column) => column,
  );

  $$ModelRunsTableAnnotationComposer get modelRunId {
    final $$ModelRunsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelRunId,
      referencedTable: $db.modelRuns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunsTableAnnotationComposer(
            $db: $db,
            $table: $db.modelRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> modelFindingsRefs<T extends Object>(
    Expression<T> Function($$ModelFindingsTableAnnotationComposer a) f,
  ) {
    final $$ModelFindingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modelFindings,
      getReferencedColumn: (t) => t.modelRunResultId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelFindingsTableAnnotationComposer(
            $db: $db,
            $table: $db.modelFindings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ModelRunResultsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $ModelRunResultsTable,
          ModelRunResult,
          $$ModelRunResultsTableFilterComposer,
          $$ModelRunResultsTableOrderingComposer,
          $$ModelRunResultsTableAnnotationComposer,
          $$ModelRunResultsTableCreateCompanionBuilder,
          $$ModelRunResultsTableUpdateCompanionBuilder,
          (ModelRunResult, $$ModelRunResultsTableReferences),
          ModelRunResult,
          PrefetchHooks Function({bool modelRunId, bool modelFindingsRefs})
        > {
  $$ModelRunResultsTableTableManager(
    _$WisteriaDatabase db,
    $ModelRunResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelRunResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelRunResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelRunResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> modelRunId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<String?> uncertainty = const Value.absent(),
                Value<String?> rawModelOutput = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModelRunResultsCompanion(
                id: id,
                modelRunId: modelRunId,
                status: status,
                confidence: confidence,
                uncertainty: uncertainty,
                rawModelOutput: rawModelOutput,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String modelRunId,
                required String status,
                Value<String?> confidence = const Value.absent(),
                Value<String?> uncertainty = const Value.absent(),
                Value<String?> rawModelOutput = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModelRunResultsCompanion.insert(
                id: id,
                modelRunId: modelRunId,
                status: status,
                confidence: confidence,
                uncertainty: uncertainty,
                rawModelOutput: rawModelOutput,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ModelRunResultsTable, ModelRunResult>(table),
                  $$ModelRunResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({modelRunId = false, modelFindingsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (modelFindingsRefs) db.modelFindings,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (modelRunId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.modelRunId,
                                    referencedTable:
                                        $$ModelRunResultsTableReferences
                                            ._modelRunIdTable(db),
                                    referencedColumn:
                                        $$ModelRunResultsTableReferences
                                            ._modelRunIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (modelFindingsRefs)
                        await $_getPrefetchedData<
                          ModelRunResult,
                          $ModelRunResultsTable,
                          ModelFinding
                        >(
                          currentTable: table,
                          referencedTable: $$ModelRunResultsTableReferences
                              ._modelFindingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModelRunResultsTableReferences(
                                db,
                                table,
                                p0,
                              ).modelFindingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modelRunResultId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ModelRunResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $ModelRunResultsTable,
      ModelRunResult,
      $$ModelRunResultsTableFilterComposer,
      $$ModelRunResultsTableOrderingComposer,
      $$ModelRunResultsTableAnnotationComposer,
      $$ModelRunResultsTableCreateCompanionBuilder,
      $$ModelRunResultsTableUpdateCompanionBuilder,
      (ModelRunResult, $$ModelRunResultsTableReferences),
      ModelRunResult,
      PrefetchHooks Function({bool modelRunId, bool modelFindingsRefs})
    >;
typedef $$ModelFindingsTableCreateCompanionBuilder =
    ModelFindingsCompanion Function({
      required String id,
      required String modelRunResultId,
      required String label,
      required String value,
      Value<String?> confidence,
      Value<int> rowid,
    });
typedef $$ModelFindingsTableUpdateCompanionBuilder =
    ModelFindingsCompanion Function({
      Value<String> id,
      Value<String> modelRunResultId,
      Value<String> label,
      Value<String> value,
      Value<String?> confidence,
      Value<int> rowid,
    });

final class $$ModelFindingsTableReferences
    extends
        BaseReferences<_$WisteriaDatabase, $ModelFindingsTable, ModelFinding> {
  $$ModelFindingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ModelRunResultsTable _modelRunResultIdTable(_$WisteriaDatabase db) =>
      db.modelRunResults.createAlias(
        'model_findings__model_run_result_id__model_run_results__id',
      );

  $$ModelRunResultsTableProcessedTableManager get modelRunResultId {
    final $_column = $_itemColumn<String>('model_run_result_id')!;

    final manager = $$ModelRunResultsTableTableManager(
      $_db,
      $_db.modelRunResults,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modelRunResultIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ModelFindingsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $ModelFindingsTable> {
  $$ModelFindingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  $$ModelRunResultsTableFilterComposer get modelRunResultId {
    final $$ModelRunResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelRunResultId,
      referencedTable: $db.modelRunResults,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunResultsTableFilterComposer(
            $db: $db,
            $table: $db.modelRunResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModelFindingsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $ModelFindingsTable> {
  $$ModelFindingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  $$ModelRunResultsTableOrderingComposer get modelRunResultId {
    final $$ModelRunResultsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelRunResultId,
      referencedTable: $db.modelRunResults,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunResultsTableOrderingComposer(
            $db: $db,
            $table: $db.modelRunResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModelFindingsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $ModelFindingsTable> {
  $$ModelFindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  $$ModelRunResultsTableAnnotationComposer get modelRunResultId {
    final $$ModelRunResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modelRunResultId,
      referencedTable: $db.modelRunResults,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelRunResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.modelRunResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModelFindingsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $ModelFindingsTable,
          ModelFinding,
          $$ModelFindingsTableFilterComposer,
          $$ModelFindingsTableOrderingComposer,
          $$ModelFindingsTableAnnotationComposer,
          $$ModelFindingsTableCreateCompanionBuilder,
          $$ModelFindingsTableUpdateCompanionBuilder,
          (ModelFinding, $$ModelFindingsTableReferences),
          ModelFinding,
          PrefetchHooks Function({bool modelRunResultId})
        > {
  $$ModelFindingsTableTableManager(
    _$WisteriaDatabase db,
    $ModelFindingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelFindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelFindingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelFindingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> modelRunResultId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModelFindingsCompanion(
                id: id,
                modelRunResultId: modelRunResultId,
                label: label,
                value: value,
                confidence: confidence,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String modelRunResultId,
                required String label,
                required String value,
                Value<String?> confidence = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModelFindingsCompanion.insert(
                id: id,
                modelRunResultId: modelRunResultId,
                label: label,
                value: value,
                confidence: confidence,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ModelFindingsTable, ModelFinding>(table),
                  $$ModelFindingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({modelRunResultId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (modelRunResultId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.modelRunResultId,
                                referencedTable: $$ModelFindingsTableReferences
                                    ._modelRunResultIdTable(db),
                                referencedColumn: $$ModelFindingsTableReferences
                                    ._modelRunResultIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ModelFindingsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $ModelFindingsTable,
      ModelFinding,
      $$ModelFindingsTableFilterComposer,
      $$ModelFindingsTableOrderingComposer,
      $$ModelFindingsTableAnnotationComposer,
      $$ModelFindingsTableCreateCompanionBuilder,
      $$ModelFindingsTableUpdateCompanionBuilder,
      (ModelFinding, $$ModelFindingsTableReferences),
      ModelFinding,
      PrefetchHooks Function({bool modelRunResultId})
    >;
typedef $$AiAnalysesTableCreateCompanionBuilder =
    AiAnalysesCompanion Function({
      required String id,
      required String examinationId,
      required DateTime generatedAt,
      required String ollamaModel,
      required String contextWindow,
      Value<String?> summary,
      Value<String?> uncertainty,
      required String status,
      Value<int> rowid,
    });
typedef $$AiAnalysesTableUpdateCompanionBuilder =
    AiAnalysesCompanion Function({
      Value<String> id,
      Value<String> examinationId,
      Value<DateTime> generatedAt,
      Value<String> ollamaModel,
      Value<String> contextWindow,
      Value<String?> summary,
      Value<String?> uncertainty,
      Value<String> status,
      Value<int> rowid,
    });

final class $$AiAnalysesTableReferences
    extends BaseReferences<_$WisteriaDatabase, $AiAnalysesTable, AiAnalyse> {
  $$AiAnalysesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExaminationsTable _examinationIdTable(_$WisteriaDatabase db) => db
      .examinations
      .createAlias('ai_analyses__examination_id__examinations__id');

  $$ExaminationsTableProcessedTableManager get examinationId {
    final $_column = $_itemColumn<String>('examination_id')!;

    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examinationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EvidenceTable, List<EvidenceData>>
  _evidenceRefsTable(_$WisteriaDatabase db) => MultiTypedResultKey.fromTable(
    db.evidence,
    aliasName: 'ai_analyses__id__evidence__analysis_id',
  );

  $$EvidenceTableProcessedTableManager get evidenceRefs {
    final manager = $$EvidenceTableTableManager(
      $_db,
      $_db.evidence,
    ).filter((f) => f.analysisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_evidenceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AiAnalysesTableFilterComposer
    extends Composer<_$WisteriaDatabase, $AiAnalysesTable> {
  $$AiAnalysesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ollamaModel => $composableBuilder(
    column: $table.ollamaModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextWindow => $composableBuilder(
    column: $table.contextWindow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uncertainty => $composableBuilder(
    column: $table.uncertainty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$ExaminationsTableFilterComposer get examinationId {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> evidenceRefs(
    Expression<bool> Function($$EvidenceTableFilterComposer f) f,
  ) {
    final $$EvidenceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evidence,
      getReferencedColumn: (t) => t.analysisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvidenceTableFilterComposer(
            $db: $db,
            $table: $db.evidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AiAnalysesTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $AiAnalysesTable> {
  $$AiAnalysesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ollamaModel => $composableBuilder(
    column: $table.ollamaModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextWindow => $composableBuilder(
    column: $table.contextWindow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uncertainty => $composableBuilder(
    column: $table.uncertainty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExaminationsTableOrderingComposer get examinationId {
    final $$ExaminationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableOrderingComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AiAnalysesTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $AiAnalysesTable> {
  $$AiAnalysesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ollamaModel => $composableBuilder(
    column: $table.ollamaModel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contextWindow => $composableBuilder(
    column: $table.contextWindow,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get uncertainty => $composableBuilder(
    column: $table.uncertainty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$ExaminationsTableAnnotationComposer get examinationId {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> evidenceRefs<T extends Object>(
    Expression<T> Function($$EvidenceTableAnnotationComposer a) f,
  ) {
    final $$EvidenceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.evidence,
      getReferencedColumn: (t) => t.analysisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvidenceTableAnnotationComposer(
            $db: $db,
            $table: $db.evidence,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AiAnalysesTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $AiAnalysesTable,
          AiAnalyse,
          $$AiAnalysesTableFilterComposer,
          $$AiAnalysesTableOrderingComposer,
          $$AiAnalysesTableAnnotationComposer,
          $$AiAnalysesTableCreateCompanionBuilder,
          $$AiAnalysesTableUpdateCompanionBuilder,
          (AiAnalyse, $$AiAnalysesTableReferences),
          AiAnalyse,
          PrefetchHooks Function({bool examinationId, bool evidenceRefs})
        > {
  $$AiAnalysesTableTableManager(_$WisteriaDatabase db, $AiAnalysesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiAnalysesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiAnalysesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiAnalysesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> examinationId = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<String> ollamaModel = const Value.absent(),
                Value<String> contextWindow = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String?> uncertainty = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiAnalysesCompanion(
                id: id,
                examinationId: examinationId,
                generatedAt: generatedAt,
                ollamaModel: ollamaModel,
                contextWindow: contextWindow,
                summary: summary,
                uncertainty: uncertainty,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String examinationId,
                required DateTime generatedAt,
                required String ollamaModel,
                required String contextWindow,
                Value<String?> summary = const Value.absent(),
                Value<String?> uncertainty = const Value.absent(),
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => AiAnalysesCompanion.insert(
                id: id,
                examinationId: examinationId,
                generatedAt: generatedAt,
                ollamaModel: ollamaModel,
                contextWindow: contextWindow,
                summary: summary,
                uncertainty: uncertainty,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AiAnalysesTable, AiAnalyse>(table),
                  $$AiAnalysesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({examinationId = false, evidenceRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (evidenceRefs) db.evidence],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (examinationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.examinationId,
                                    referencedTable: $$AiAnalysesTableReferences
                                        ._examinationIdTable(db),
                                    referencedColumn:
                                        $$AiAnalysesTableReferences
                                            ._examinationIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (evidenceRefs)
                        await $_getPrefetchedData<
                          AiAnalyse,
                          $AiAnalysesTable,
                          EvidenceData
                        >(
                          currentTable: table,
                          referencedTable: $$AiAnalysesTableReferences
                              ._evidenceRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AiAnalysesTableReferences(
                                db,
                                table,
                                p0,
                              ).evidenceRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.analysisId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AiAnalysesTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $AiAnalysesTable,
      AiAnalyse,
      $$AiAnalysesTableFilterComposer,
      $$AiAnalysesTableOrderingComposer,
      $$AiAnalysesTableAnnotationComposer,
      $$AiAnalysesTableCreateCompanionBuilder,
      $$AiAnalysesTableUpdateCompanionBuilder,
      (AiAnalyse, $$AiAnalysesTableReferences),
      AiAnalyse,
      PrefetchHooks Function({bool examinationId, bool evidenceRefs})
    >;
typedef $$EvidenceTableCreateCompanionBuilder =
    EvidenceCompanion Function({
      required String id,
      required String analysisId,
      required String sourceType,
      required String sourceId,
      Value<DateTime?> sourceDate,
      required String content,
      Value<String?> relevance,
      Value<int> rowid,
    });
typedef $$EvidenceTableUpdateCompanionBuilder =
    EvidenceCompanion Function({
      Value<String> id,
      Value<String> analysisId,
      Value<String> sourceType,
      Value<String> sourceId,
      Value<DateTime?> sourceDate,
      Value<String> content,
      Value<String?> relevance,
      Value<int> rowid,
    });

final class $$EvidenceTableReferences
    extends BaseReferences<_$WisteriaDatabase, $EvidenceTable, EvidenceData> {
  $$EvidenceTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AiAnalysesTable _analysisIdTable(_$WisteriaDatabase db) =>
      db.aiAnalyses.createAlias('evidence__analysis_id__ai_analyses__id');

  $$AiAnalysesTableProcessedTableManager get analysisId {
    final $_column = $_itemColumn<String>('analysis_id')!;

    final manager = $$AiAnalysesTableTableManager(
      $_db,
      $_db.aiAnalyses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_analysisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EvidenceTableFilterComposer
    extends Composer<_$WisteriaDatabase, $EvidenceTable> {
  $$EvidenceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sourceDate => $composableBuilder(
    column: $table.sourceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relevance => $composableBuilder(
    column: $table.relevance,
    builder: (column) => ColumnFilters(column),
  );

  $$AiAnalysesTableFilterComposer get analysisId {
    final $$AiAnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.aiAnalyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiAnalysesTableFilterComposer(
            $db: $db,
            $table: $db.aiAnalyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvidenceTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $EvidenceTable> {
  $$EvidenceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sourceDate => $composableBuilder(
    column: $table.sourceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relevance => $composableBuilder(
    column: $table.relevance,
    builder: (column) => ColumnOrderings(column),
  );

  $$AiAnalysesTableOrderingComposer get analysisId {
    final $$AiAnalysesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.aiAnalyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiAnalysesTableOrderingComposer(
            $db: $db,
            $table: $db.aiAnalyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvidenceTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $EvidenceTable> {
  $$EvidenceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<DateTime> get sourceDate => $composableBuilder(
    column: $table.sourceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get relevance =>
      $composableBuilder(column: $table.relevance, builder: (column) => column);

  $$AiAnalysesTableAnnotationComposer get analysisId {
    final $$AiAnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.analysisId,
      referencedTable: $db.aiAnalyses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiAnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.aiAnalyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EvidenceTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $EvidenceTable,
          EvidenceData,
          $$EvidenceTableFilterComposer,
          $$EvidenceTableOrderingComposer,
          $$EvidenceTableAnnotationComposer,
          $$EvidenceTableCreateCompanionBuilder,
          $$EvidenceTableUpdateCompanionBuilder,
          (EvidenceData, $$EvidenceTableReferences),
          EvidenceData,
          PrefetchHooks Function({bool analysisId})
        > {
  $$EvidenceTableTableManager(_$WisteriaDatabase db, $EvidenceTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvidenceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvidenceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvidenceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisId = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<DateTime?> sourceDate = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> relevance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EvidenceCompanion(
                id: id,
                analysisId: analysisId,
                sourceType: sourceType,
                sourceId: sourceId,
                sourceDate: sourceDate,
                content: content,
                relevance: relevance,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisId,
                required String sourceType,
                required String sourceId,
                Value<DateTime?> sourceDate = const Value.absent(),
                required String content,
                Value<String?> relevance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EvidenceCompanion.insert(
                id: id,
                analysisId: analysisId,
                sourceType: sourceType,
                sourceId: sourceId,
                sourceDate: sourceDate,
                content: content,
                relevance: relevance,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EvidenceTable, EvidenceData>(table),
                  $$EvidenceTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({analysisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (analysisId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.analysisId,
                                referencedTable: $$EvidenceTableReferences
                                    ._analysisIdTable(db),
                                referencedColumn: $$EvidenceTableReferences
                                    ._analysisIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EvidenceTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $EvidenceTable,
      EvidenceData,
      $$EvidenceTableFilterComposer,
      $$EvidenceTableOrderingComposer,
      $$EvidenceTableAnnotationComposer,
      $$EvidenceTableCreateCompanionBuilder,
      $$EvidenceTableUpdateCompanionBuilder,
      (EvidenceData, $$EvidenceTableReferences),
      EvidenceData,
      PrefetchHooks Function({bool analysisId})
    >;
typedef $$DoctorReviewsTableCreateCompanionBuilder =
    DoctorReviewsCompanion Function({
      required String id,
      required String examinationId,
      required String reviewStatus,
      required DateTime reviewedAt,
      required String finalizedAnalysis,
      Value<int> rowid,
    });
typedef $$DoctorReviewsTableUpdateCompanionBuilder =
    DoctorReviewsCompanion Function({
      Value<String> id,
      Value<String> examinationId,
      Value<String> reviewStatus,
      Value<DateTime> reviewedAt,
      Value<String> finalizedAnalysis,
      Value<int> rowid,
    });

final class $$DoctorReviewsTableReferences
    extends
        BaseReferences<_$WisteriaDatabase, $DoctorReviewsTable, DoctorReview> {
  $$DoctorReviewsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExaminationsTable _examinationIdTable(_$WisteriaDatabase db) => db
      .examinations
      .createAlias('doctor_reviews__examination_id__examinations__id');

  $$ExaminationsTableProcessedTableManager get examinationId {
    final $_column = $_itemColumn<String>('examination_id')!;

    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examinationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DoctorReviewsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $DoctorReviewsTable> {
  $$DoctorReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get finalizedAnalysis => $composableBuilder(
    column: $table.finalizedAnalysis,
    builder: (column) => ColumnFilters(column),
  );

  $$ExaminationsTableFilterComposer get examinationId {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoctorReviewsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $DoctorReviewsTable> {
  $$DoctorReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finalizedAnalysis => $composableBuilder(
    column: $table.finalizedAnalysis,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExaminationsTableOrderingComposer get examinationId {
    final $$ExaminationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableOrderingComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoctorReviewsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $DoctorReviewsTable> {
  $$DoctorReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reviewStatus => $composableBuilder(
    column: $table.reviewStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get finalizedAnalysis => $composableBuilder(
    column: $table.finalizedAnalysis,
    builder: (column) => column,
  );

  $$ExaminationsTableAnnotationComposer get examinationId {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoctorReviewsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $DoctorReviewsTable,
          DoctorReview,
          $$DoctorReviewsTableFilterComposer,
          $$DoctorReviewsTableOrderingComposer,
          $$DoctorReviewsTableAnnotationComposer,
          $$DoctorReviewsTableCreateCompanionBuilder,
          $$DoctorReviewsTableUpdateCompanionBuilder,
          (DoctorReview, $$DoctorReviewsTableReferences),
          DoctorReview,
          PrefetchHooks Function({bool examinationId})
        > {
  $$DoctorReviewsTableTableManager(
    _$WisteriaDatabase db,
    $DoctorReviewsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoctorReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoctorReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoctorReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> examinationId = const Value.absent(),
                Value<String> reviewStatus = const Value.absent(),
                Value<DateTime> reviewedAt = const Value.absent(),
                Value<String> finalizedAnalysis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoctorReviewsCompanion(
                id: id,
                examinationId: examinationId,
                reviewStatus: reviewStatus,
                reviewedAt: reviewedAt,
                finalizedAnalysis: finalizedAnalysis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String examinationId,
                required String reviewStatus,
                required DateTime reviewedAt,
                required String finalizedAnalysis,
                Value<int> rowid = const Value.absent(),
              }) => DoctorReviewsCompanion.insert(
                id: id,
                examinationId: examinationId,
                reviewStatus: reviewStatus,
                reviewedAt: reviewedAt,
                finalizedAnalysis: finalizedAnalysis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DoctorReviewsTable, DoctorReview>(table),
                  $$DoctorReviewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examinationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (examinationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examinationId,
                                referencedTable: $$DoctorReviewsTableReferences
                                    ._examinationIdTable(db),
                                referencedColumn: $$DoctorReviewsTableReferences
                                    ._examinationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DoctorReviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $DoctorReviewsTable,
      DoctorReview,
      $$DoctorReviewsTableFilterComposer,
      $$DoctorReviewsTableOrderingComposer,
      $$DoctorReviewsTableAnnotationComposer,
      $$DoctorReviewsTableCreateCompanionBuilder,
      $$DoctorReviewsTableUpdateCompanionBuilder,
      (DoctorReview, $$DoctorReviewsTableReferences),
      DoctorReview,
      PrefetchHooks Function({bool examinationId})
    >;
typedef $$FinalReportsTableCreateCompanionBuilder =
    FinalReportsCompanion Function({
      required String id,
      required String examinationId,
      required DateTime generatedAt,
      required String filePath,
      required String finalizedAnalysis,
      Value<int> rowid,
    });
typedef $$FinalReportsTableUpdateCompanionBuilder =
    FinalReportsCompanion Function({
      Value<String> id,
      Value<String> examinationId,
      Value<DateTime> generatedAt,
      Value<String> filePath,
      Value<String> finalizedAnalysis,
      Value<int> rowid,
    });

final class $$FinalReportsTableReferences
    extends
        BaseReferences<_$WisteriaDatabase, $FinalReportsTable, FinalReport> {
  $$FinalReportsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExaminationsTable _examinationIdTable(_$WisteriaDatabase db) => db
      .examinations
      .createAlias('final_reports__examination_id__examinations__id');

  $$ExaminationsTableProcessedTableManager get examinationId {
    final $_column = $_itemColumn<String>('examination_id')!;

    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examinationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FinalReportsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $FinalReportsTable> {
  $$FinalReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get finalizedAnalysis => $composableBuilder(
    column: $table.finalizedAnalysis,
    builder: (column) => ColumnFilters(column),
  );

  $$ExaminationsTableFilterComposer get examinationId {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinalReportsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $FinalReportsTable> {
  $$FinalReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finalizedAnalysis => $composableBuilder(
    column: $table.finalizedAnalysis,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExaminationsTableOrderingComposer get examinationId {
    final $$ExaminationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableOrderingComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinalReportsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $FinalReportsTable> {
  $$FinalReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get finalizedAnalysis => $composableBuilder(
    column: $table.finalizedAnalysis,
    builder: (column) => column,
  );

  $$ExaminationsTableAnnotationComposer get examinationId {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinalReportsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $FinalReportsTable,
          FinalReport,
          $$FinalReportsTableFilterComposer,
          $$FinalReportsTableOrderingComposer,
          $$FinalReportsTableAnnotationComposer,
          $$FinalReportsTableCreateCompanionBuilder,
          $$FinalReportsTableUpdateCompanionBuilder,
          (FinalReport, $$FinalReportsTableReferences),
          FinalReport,
          PrefetchHooks Function({bool examinationId})
        > {
  $$FinalReportsTableTableManager(
    _$WisteriaDatabase db,
    $FinalReportsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinalReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinalReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinalReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> examinationId = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> finalizedAnalysis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FinalReportsCompanion(
                id: id,
                examinationId: examinationId,
                generatedAt: generatedAt,
                filePath: filePath,
                finalizedAnalysis: finalizedAnalysis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String examinationId,
                required DateTime generatedAt,
                required String filePath,
                required String finalizedAnalysis,
                Value<int> rowid = const Value.absent(),
              }) => FinalReportsCompanion.insert(
                id: id,
                examinationId: examinationId,
                generatedAt: generatedAt,
                filePath: filePath,
                finalizedAnalysis: finalizedAnalysis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FinalReportsTable, FinalReport>(table),
                  $$FinalReportsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examinationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (examinationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examinationId,
                                referencedTable: $$FinalReportsTableReferences
                                    ._examinationIdTable(db),
                                referencedColumn: $$FinalReportsTableReferences
                                    ._examinationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FinalReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $FinalReportsTable,
      FinalReport,
      $$FinalReportsTableFilterComposer,
      $$FinalReportsTableOrderingComposer,
      $$FinalReportsTableAnnotationComposer,
      $$FinalReportsTableCreateCompanionBuilder,
      $$FinalReportsTableUpdateCompanionBuilder,
      (FinalReport, $$FinalReportsTableReferences),
      FinalReport,
      PrefetchHooks Function({bool examinationId})
    >;
typedef $$SyncItemsTableCreateCompanionBuilder =
    SyncItemsCompanion Function({
      required String id,
      required String entityId,
      required String entityType,
      required int localVersion,
      Value<int?> cloudVersion,
      required String syncStatus,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncItemsTableUpdateCompanionBuilder =
    SyncItemsCompanion Function({
      Value<String> id,
      Value<String> entityId,
      Value<String> entityType,
      Value<int> localVersion,
      Value<int?> cloudVersion,
      Value<String> syncStatus,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncItemsTableFilterComposer
    extends Composer<_$WisteriaDatabase, $SyncItemsTable> {
  $$SyncItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cloudVersion => $composableBuilder(
    column: $table.cloudVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncItemsTableOrderingComposer
    extends Composer<_$WisteriaDatabase, $SyncItemsTable> {
  $$SyncItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cloudVersion => $composableBuilder(
    column: $table.cloudVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncItemsTableAnnotationComposer
    extends Composer<_$WisteriaDatabase, $SyncItemsTable> {
  $$SyncItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cloudVersion => $composableBuilder(
    column: $table.cloudVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncItemsTableTableManager
    extends
        RootTableManager<
          _$WisteriaDatabase,
          $SyncItemsTable,
          SyncItem,
          $$SyncItemsTableFilterComposer,
          $$SyncItemsTableOrderingComposer,
          $$SyncItemsTableAnnotationComposer,
          $$SyncItemsTableCreateCompanionBuilder,
          $$SyncItemsTableUpdateCompanionBuilder,
          (
            SyncItem,
            BaseReferences<_$WisteriaDatabase, $SyncItemsTable, SyncItem>,
          ),
          SyncItem,
          PrefetchHooks Function()
        > {
  $$SyncItemsTableTableManager(_$WisteriaDatabase db, $SyncItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<int?> cloudVersion = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncItemsCompanion(
                id: id,
                entityId: entityId,
                entityType: entityType,
                localVersion: localVersion,
                cloudVersion: cloudVersion,
                syncStatus: syncStatus,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityId,
                required String entityType,
                required int localVersion,
                Value<int?> cloudVersion = const Value.absent(),
                required String syncStatus,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncItemsCompanion.insert(
                id: id,
                entityId: entityId,
                entityType: entityType,
                localVersion: localVersion,
                cloudVersion: cloudVersion,
                syncStatus: syncStatus,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncItemsTable, SyncItem>(table),
                  BaseReferences<_$WisteriaDatabase, $SyncItemsTable, SyncItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$WisteriaDatabase,
      $SyncItemsTable,
      SyncItem,
      $$SyncItemsTableFilterComposer,
      $$SyncItemsTableOrderingComposer,
      $$SyncItemsTableAnnotationComposer,
      $$SyncItemsTableCreateCompanionBuilder,
      $$SyncItemsTableUpdateCompanionBuilder,
      (SyncItem, BaseReferences<_$WisteriaDatabase, $SyncItemsTable, SyncItem>),
      SyncItem,
      PrefetchHooks Function()
    >;

class $WisteriaDatabaseManager {
  final _$WisteriaDatabase _db;
  $WisteriaDatabaseManager(this._db);
  $$DoctorProfilesTableTableManager get doctorProfiles =>
      $$DoctorProfilesTableTableManager(_db, _db.doctorProfiles);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$PreviousMedicalInformationsTableTableManager
  get previousMedicalInformations =>
      $$PreviousMedicalInformationsTableTableManager(
        _db,
        _db.previousMedicalInformations,
      );
  $$PreviousMedicationsTableTableManager get previousMedications =>
      $$PreviousMedicationsTableTableManager(_db, _db.previousMedications);
  $$PreviousTestResultsTableTableManager get previousTestResults =>
      $$PreviousTestResultsTableTableManager(_db, _db.previousTestResults);
  $$ExaminationsTableTableManager get examinations =>
      $$ExaminationsTableTableManager(_db, _db.examinations);
  $$MedicalImagesTableTableManager get medicalImages =>
      $$MedicalImagesTableTableManager(_db, _db.medicalImages);
  $$MedicalModelsTableTableManager get medicalModels =>
      $$MedicalModelsTableTableManager(_db, _db.medicalModels);
  $$ModelVersionsTableTableManager get modelVersions =>
      $$ModelVersionsTableTableManager(_db, _db.modelVersions);
  $$ModelRunsTableTableManager get modelRuns =>
      $$ModelRunsTableTableManager(_db, _db.modelRuns);
  $$ModelRunResultsTableTableManager get modelRunResults =>
      $$ModelRunResultsTableTableManager(_db, _db.modelRunResults);
  $$ModelFindingsTableTableManager get modelFindings =>
      $$ModelFindingsTableTableManager(_db, _db.modelFindings);
  $$AiAnalysesTableTableManager get aiAnalyses =>
      $$AiAnalysesTableTableManager(_db, _db.aiAnalyses);
  $$EvidenceTableTableManager get evidence =>
      $$EvidenceTableTableManager(_db, _db.evidence);
  $$DoctorReviewsTableTableManager get doctorReviews =>
      $$DoctorReviewsTableTableManager(_db, _db.doctorReviews);
  $$FinalReportsTableTableManager get finalReports =>
      $$FinalReportsTableTableManager(_db, _db.finalReports);
  $$SyncItemsTableTableManager get syncItems =>
      $$SyncItemsTableTableManager(_db, _db.syncItems);
}
