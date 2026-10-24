import 'package:flutter/material.dart';
import '../../../core/theme/wisteria_theme.dart';

/// Legacy centralized age categories for patient avatar selection (preserved for backwards compatibility).
enum PatientAgeCategory { child, teenager, adult, senior }

/// Legacy deterministic age-to-category mapping.
PatientAgeCategory getPatientAgeCategory(int? age) {
  if (age == null) return PatientAgeCategory.adult;
  if (age <= 12) return PatientAgeCategory.child;
  if (age <= 19) return PatientAgeCategory.teenager;
  if (age <= 59) return PatientAgeCategory.adult;
  return PatientAgeCategory.senior;
}

/// Returns a human-readable label for the legacy age category.
String getAgeCategoryLabel(PatientAgeCategory category) {
  switch (category) {
    case PatientAgeCategory.child:
      return 'Child (0–12 yrs)';
    case PatientAgeCategory.teenager:
      return 'Teenager (13–19 yrs)';
    case PatientAgeCategory.adult:
      return 'Adult (20–59 yrs)';
    case PatientAgeCategory.senior:
      return 'Senior (60+ yrs)';
  }
}

/// Standardized age groups for clinical patient avatars:
/// - Child: 0–17 years
/// - Adult: 18–49 years
/// - Older adult: 50 years and above
enum PatientAgeGroup { child, adult, olderAdult }

/// Supported genders for dynamic patient avatars.
enum PatientAvatarGender { male, female }

/// Six age- and gender-based patient avatar categories plus neutral fallback.
enum PatientAvatarCategory {
  childMale,
  childFemale,
  adultMale,
  adultFemale,
  olderAdultMale,
  olderAdultFemale,
  childNeutral,
  adultNeutral,
  olderAdultNeutral,
  neutralFallback,
}

/// Resolves patient age.
/// Calculates age dynamically from [dateOfBirth] when available.
/// If only [age] is stored, that value is used.
int? resolvePatientAge({DateTime? dateOfBirth, int? age}) {
  if (dateOfBirth != null) {
    final now = DateTime.now();
    int calculated = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      calculated--;
    }
    return calculated >= 0 ? calculated : 0;
  }
  return age;
}

/// Maps an age in years to its respective [PatientAgeGroup].
PatientAgeGroup? getPatientAgeGroup(int? age) {
  if (age == null || age < 0) return null;
  if (age <= 17) return PatientAgeGroup.child;
  if (age <= 49) return PatientAgeGroup.adult;
  return PatientAgeGroup.olderAdult;
}

/// Parses gender string into [PatientAvatarGender].
PatientAvatarGender? parsePatientGender(String? gender) {
  if (gender == null) return null;
  final g = gender.trim().toLowerCase();
  if (g == 'male' || g == 'm') return PatientAvatarGender.male;
  if (g == 'female' || g == 'f') return PatientAvatarGender.female;
  return null;
}

/// Selects the appropriate avatar category based on age/DOB and gender.
/// If gender or age/DOB is missing or unrecognized, returns [PatientAvatarCategory.neutralFallback].
PatientAvatarCategory getPatientAvatarCategory({
  DateTime? dateOfBirth,
  int? age,
  String? gender,
}) {
  final resolvedAge = resolvePatientAge(dateOfBirth: dateOfBirth, age: age);
  final parsedGender = parsePatientGender(gender);

  if (resolvedAge == null) {
    return PatientAvatarCategory.neutralFallback;
  }

  if (parsedGender == null) {
    if (resolvedAge <= 17) return PatientAvatarCategory.childNeutral;
    if (resolvedAge <= 49) return PatientAvatarCategory.adultNeutral;
    return PatientAvatarCategory.olderAdultNeutral;
  }

  if (resolvedAge <= 17) {
    return parsedGender == PatientAvatarGender.male
        ? PatientAvatarCategory.childMale
        : PatientAvatarCategory.childFemale;
  } else if (resolvedAge <= 49) {
    return parsedGender == PatientAvatarGender.male
        ? PatientAvatarCategory.adultMale
        : PatientAvatarCategory.adultFemale;
  } else {
    return parsedGender == PatientAvatarGender.male
        ? PatientAvatarCategory.olderAdultMale
        : PatientAvatarCategory.olderAdultFemale;
  }
}

/// Returns a descriptive human-readable label for the avatar category.
String getAvatarCategoryLabel(PatientAvatarCategory category) {
  switch (category) {
    case PatientAvatarCategory.childMale:
      return 'Child (Male, 0–17 yrs)';
    case PatientAvatarCategory.childFemale:
      return 'Child (Female, 0–17 yrs)';
    case PatientAvatarCategory.adultMale:
      return 'Adult (Male, 18–49 yrs)';
    case PatientAvatarCategory.adultFemale:
      return 'Adult (Female, 18–49 yrs)';
    case PatientAvatarCategory.olderAdultMale:
      return 'Older Adult (Male, 50+ yrs)';
    case PatientAvatarCategory.olderAdultFemale:
      return 'Older Adult (Female, 50+ yrs)';
    case PatientAvatarCategory.childNeutral:
      return 'Child (Gender not provided, 0–17 yrs)';
    case PatientAvatarCategory.adultNeutral:
      return 'Adult (Gender not provided, 18–49 yrs)';
    case PatientAvatarCategory.olderAdultNeutral:
      return 'Older Adult (Gender not provided, 50+ yrs)';
    case PatientAvatarCategory.neutralFallback:
      return 'Patient Profile';
  }
}

String getPatientPortraitAsset(PatientAvatarCategory category) {
  switch (category) {
    case PatientAvatarCategory.childMale:
      return 'assets/images/patients/child_male.png';
    case PatientAvatarCategory.childFemale:
      return 'assets/images/patients/child_female.png';
    case PatientAvatarCategory.adultMale:
      return 'assets/images/patients/adult_male.png';
    case PatientAvatarCategory.adultFemale:
      return 'assets/images/patients/adult_female.png';
    case PatientAvatarCategory.olderAdultMale:
      return 'assets/images/patients/older_male.png';
    case PatientAvatarCategory.olderAdultFemale:
      return 'assets/images/patients/older_female.png';
    case PatientAvatarCategory.childNeutral:
    case PatientAvatarCategory.adultNeutral:
    case PatientAvatarCategory.olderAdultNeutral:
    case PatientAvatarCategory.neutralFallback:
      return 'assets/images/patients/adult_male.png';
  }
}

/// Theme-aware, age- and gender-based photographic portrait for patient records.
class PatientAgeAvatar extends StatelessWidget {
  final int? age;
  final String? gender;
  final DateTime? dateOfBirth;
  final double size;

  const PatientAgeAvatar({
    super.key,
    this.age,
    this.gender,
    this.dateOfBirth,
    this.size = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final category = getPatientAvatarCategory(
      dateOfBirth: dateOfBirth,
      age: age,
      gender: gender,
    );
    return Tooltip(
      message: getAvatarCategoryLabel(category),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: colors.border),
          color: colors.surfaceLow,
        ),
        child: Image.asset(
          getPatientPortraitAsset(category),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/patient info.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  ColoredBox(color: colors.surfaceLow),
            );
          },
        ),
      ),
    );
  }
}

/// Full-surface photographic patient portrait for patient cards.
class PatientProfileBackground extends StatelessWidget {
  final int? age;
  final String? gender;
  final DateTime? dateOfBirth;

  const PatientProfileBackground({
    super.key,
    this.age,
    this.gender,
    this.dateOfBirth,
  });

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final category = getPatientAvatarCategory(
      dateOfBirth: dateOfBirth,
      age: age,
      gender: gender,
    );

    return Tooltip(
      message: getAvatarCategoryLabel(category),
      child: Image.asset(
        getPatientPortraitAsset(category),
        fit: BoxFit.cover,
        cacheWidth: 900,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/patient info.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                ColoredBox(color: colors.surfaceLow),
          );
        },
      ),
    );
  }
}
