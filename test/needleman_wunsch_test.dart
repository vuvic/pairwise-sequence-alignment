import 'package:flutter_test/flutter_test.dart';
import 'package:pairwise_sequence_alignment/needleman_wunsch.dart';
import 'package:pairwise_sequence_alignment/models/matrix_cell.dart';
import 'package:pairwise_sequence_alignment/models/scoring_scheme.dart';
import 'package:pairwise_sequence_alignment/models/alignment.dart';

void main() {
  test('generateScoringMatrix initializes the matrix correctly', () {
    String sequence1 = "GATTACA";
    String sequence2 = "GCATGCU";
    List<List<MatrixCell>> matrix =
        PairwiseSequenceAligner.generateScoringMatrix(sequence1, sequence2);

    // Log the resulting matrix values
    StringBuffer matrixLog = StringBuffer();
    for (var row in matrix) {
      for (var cell in row) {
        matrixLog.write('${cell.value} ');
      }
      matrixLog.writeln();
    }
    print(matrixLog.toString());

    // Check the first row and column for correct gap penalties
    for (int i = 0; i < sequence1.length; i++) {
      expect(matrix[i][0].value, i * ScoringScheme.gap);
    }

    for (int j = 0; j < sequence2.length; j++) {
      expect(matrix[0][j].value, j * ScoringScheme.gap);
    }
  });

  test('calculateCell returns correct cell value and paths for a single cell',
      () {
    String sequence1 = "GATTACA";
    String sequence2 = "GCATGCU";
    PairwiseSequenceAligner aligner =
        PairwiseSequenceAligner(sequence1, sequence2);

    List<List<MatrixCell>> matrix = aligner.matrix;
    StringBuffer matrixLog = StringBuffer();

    int i = 1;
    int j = 1;

    matrix[i][j] = aligner.calculateCell(i, j);
    expect(matrix[i][j].value, 1);
    expect(matrix[i][j].paths?[0].i, 0);
    expect(matrix[i][j].paths?[0].j, 0);

    for (var row in matrix) {
      for (var cell in row) {
        matrixLog.write('${cell.value} ');
      }
      matrixLog.writeln();
    }
    print(matrixLog.toString());
  });

  test(
      'running calculateCell in a nested loop generates the correct alignment matrix',
      () {
    String sequence1 = "GATTACA";
    String sequence2 = "GCATGCU";
    PairwiseSequenceAligner aligner =
        PairwiseSequenceAligner(sequence1, sequence2);

    List<List<MatrixCell>> matrix = aligner.matrix;
    StringBuffer matrixLog = StringBuffer();

    for (int i = 1; i < sequence1.length + 1; i++) {
      for (int j = 1; j < sequence2.length + 1; j++) {
        matrix[i][j] = aligner.calculateCell(i, j);
      }
    }

    expect(matrix[sequence1.length][sequence2.length].value, -1);

    for (var row in matrix) {
      for (var cell in row) {
        matrixLog.write('${cell.value} ');
      }
      matrixLog.writeln();
    }
    print(matrixLog.toString());
  });

  test('alignSequences returns correct alignment for simple sequences', () {
    String sequence1 = "GATTACA";
    String sequence2 = "GCATGCU";
    PairwiseSequenceAligner aligner =
        PairwiseSequenceAligner(sequence1, sequence2);
    SequenceAlignment alignment = aligner.alignSequences();

    expect(alignment.alignedSequence1, isNotEmpty);
    expect(alignment.alignedSequence2, isNotEmpty);
    expect(alignment.score, isNonNegative);
  });
}
