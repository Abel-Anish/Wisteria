import 'dart:convert';

import 'package:drift/drift.dart';

import '../database.dart';

class ModelRunRepository {
  final WisteriaDatabase database;

  ModelRunRepository(this.database);

  /// Saves a successful Pneumonia Classification run.
  Future<void> saveSuccessfulRun({
    required String runId,
    required String resultId,
    required String findingId,
    required String examinationId,
    required String modelId,
    required String modelVersionId,
    required String inputImageId,
    required DateTime inputImageDate,
    required DateTime executionTimestamp,
    required String prediction,
    required double confidence,
    required double normalProbability,
    required double pneumoniaProbability,
  }) {
    return database.transaction(() async {
      await database
          .into(database.modelRuns)
          .insert(
            ModelRunsCompanion.insert(
              id: runId,
              examinationId: examinationId,
              modelId: modelId,
              modelVersionId: modelVersionId,
              inputImageId: inputImageId,
              inputImageDate: inputImageDate,
              executionTimestamp: executionTimestamp,
            ),
          );

      await database
          .into(database.modelRunResults)
          .insert(
            ModelRunResultsCompanion.insert(
              id: resultId,
              modelRunId: runId,
              status: 'SUCCESS',
              confidence: Value(confidence.toString()),
              rawModelOutput: Value(
                jsonEncode({
                  'prediction': prediction,
                  'normalProbability': normalProbability,
                  'pneumoniaProbability': pneumoniaProbability,
                }),
              ),
            ),
          );

      await database
          .into(database.modelFindings)
          .insert(
            ModelFindingsCompanion.insert(
              id: findingId,
              modelRunResultId: resultId,
              label: 'classification',
              value: prediction,
              confidence: Value(confidence.toString()),
            ),
          );
    });
  }

  /// Saves a successful Brain Tumor Classification run.
  ///
  /// [scores] is a map of class label → probability, e.g.
  ///   {'glioma': 0.87, 'meningioma': 0.05, 'notumor': 0.04, 'pituitary': 0.04}
  Future<void> saveSuccessfulBrainTumorRun({
    required String runId,
    required String resultId,
    required String findingId,
    required String examinationId,
    required String modelId,
    required String modelVersionId,
    required String inputImageId,
    required DateTime inputImageDate,
    required DateTime executionTimestamp,
    required String prediction,
    required double confidence,
    required Map<String, double> scores,
  }) {
    return database.transaction(() async {
      await database
          .into(database.modelRuns)
          .insert(
            ModelRunsCompanion.insert(
              id: runId,
              examinationId: examinationId,
              modelId: modelId,
              modelVersionId: modelVersionId,
              inputImageId: inputImageId,
              inputImageDate: inputImageDate,
              executionTimestamp: executionTimestamp,
            ),
          );

      await database
          .into(database.modelRunResults)
          .insert(
            ModelRunResultsCompanion.insert(
              id: resultId,
              modelRunId: runId,
              status: 'SUCCESS',
              confidence: Value(confidence.toString()),
              rawModelOutput: Value(
                jsonEncode({
                  'prediction': prediction,
                  'modelType': 'brain_tumor',
                  ...scores,
                }),
              ),
            ),
          );

      await database
          .into(database.modelFindings)
          .insert(
            ModelFindingsCompanion.insert(
              id: findingId,
              modelRunResultId: resultId,
              label: 'classification',
              value: prediction,
              confidence: Value(confidence.toString()),
            ),
          );
    });
  }

  Future<List<ModelRun>> getRunsForExamination(String examinationId) {
    return (database.select(database.modelRuns)
          ..where((run) => run.examinationId.equals(examinationId))
          ..orderBy([(run) => OrderingTerm.desc(run.executionTimestamp)]))
        .get();
  }

  Future<ModelRunResult?> getResultForRun(String runId) {
    return (database.select(
      database.modelRunResults,
    )..where((result) => result.modelRunId.equals(runId))).getSingleOrNull();
  }

  Future<List<ModelFinding>> getFindingsForResult(String resultId) {
    return (database.select(
      database.modelFindings,
    )..where((finding) => finding.modelRunResultId.equals(resultId))).get();
  }
}
