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

  test('calculateCell returns correct cell value and paths', () {
    String sequence1 = "GATTACA";
    String sequence2 = "GCATGCU";
    PairwiseSequenceAligner aligner =
        PairwiseSequenceAligner(sequence1, sequence2);

    MatrixCell cell = aligner.calculateCell(1, 1);
    expect(cell.value, isNonNegative);
    expect(cell.paths, isNotEmpty);
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
