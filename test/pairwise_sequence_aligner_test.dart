import 'package:flutter_test/flutter_test.dart';
import 'package:pairwise_sequence_alignment/multiple_sequence_alignment/pairwise_alignment/pairwise_sequence_aligner.dart';
import 'package:pairwise_sequence_alignment/multiple_sequence_alignment/pairwise_alignment/models/matrix_cell.dart';
import 'package:pairwise_sequence_alignment/multiple_sequence_alignment/pairwise_alignment/models/scoring_scheme.dart';
import 'package:pairwise_sequence_alignment/multiple_sequence_alignment/pairwise_alignment/models/alignment.dart';

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

  test(
    'calculateCell returns correct cell value and paths for a single cell',
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
    },
  );

  test(
    'running calculateCell in a nested loop generates the correct alignment matrix for matching sequences',
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
    },
  );

  test(
    'running calculateCell in a nested loop generates the correct alignment matrix for non-matching sequences',
    () {
      String sequence1 = "GATTACA";
      String sequence2 = "GATC";
      PairwiseSequenceAligner aligner =
          PairwiseSequenceAligner(sequence1, sequence2);

      List<List<MatrixCell>> matrix = aligner.matrix;
      StringBuffer matrixLog = StringBuffer();

      for (int i = 1; i < sequence1.length + 1; i++) {
        for (int j = 1; j < sequence2.length + 1; j++) {
          matrix[i][j] = aligner.calculateCell(i, j);
        }
      }

      expect(matrix[sequence1.length][sequence2.length].value, -2);

      for (var row in matrix) {
        for (var cell in row) {
          matrixLog.write('${cell.value} ');
        }
        matrixLog.writeln();
      }
      print(matrixLog.toString());
    },
  );

  test(
      'traceback returns an empty list of alignments when called for matrix[0][0]',
      () {
    String sequence1 = "GATTACA";
    String sequence2 = "GATC";
    PairwiseSequenceAligner aligner =
        PairwiseSequenceAligner(sequence1, sequence2);

    List<List<MatrixCell>> matrix = aligner.matrix;
    StringBuffer matrixLog = StringBuffer();

    for (int i = 1; i < sequence1.length + 1; i++) {
      for (int j = 1; j < sequence2.length + 1; j++) {
        matrix[i][j] = aligner.calculateCell(i, j);
      }
    }

    List<SequenceAlignment> alignments = aligner.traceback(0, 0);

    expect(alignments.length, 1);
    expect(alignments[0].score, 0);
    expect(alignments[0].alignedSequence1, '');
    expect(alignments[0].alignedSequence2, '');
  });

  test('traceback returns an incomplete alignment when called for matrix[0][1]',
      () {
    String sequence1 = "GATTACA";
    String sequence2 = "GATC";
    PairwiseSequenceAligner aligner =
        PairwiseSequenceAligner(sequence1, sequence2);

    List<List<MatrixCell>> matrix = aligner.matrix;
    StringBuffer matrixLog = StringBuffer();

    for (int i = 1; i < sequence1.length + 1; i++) {
      for (int j = 1; j < sequence2.length + 1; j++) {
        matrix[i][j] = aligner.calculateCell(i, j);
      }
    }
    List<SequenceAlignment> alignments = aligner.traceback(0, 1);

    expect(alignments.length, 1);
    expect(alignments[0].score, -2);
    expect(alignments[0].alignedSequence1, '-');
    expect(alignments[0].alignedSequence2, 'G');
  });

  test(
    'alignSequences returns optimal alignment for matching sequences when there is one optimal alignment',
    () {
      String sequence1 = "ATGGTGCACGTGACTCCTGA";
      String sequence2 = "ATGGTCCACTGACTCCTGT";
      PairwiseSequenceAligner aligner =
          PairwiseSequenceAligner(sequence1, sequence2);

      List<SequenceAlignment> alignments = aligner.alignSequences();

      List<List<MatrixCell>> matrix = aligner.matrix;
      StringBuffer matrixLog = StringBuffer();
      for (var row in matrix) {
        for (var cell in row) {
          matrixLog.write('${cell.value} ');
        }
        matrixLog.writeln();
      }

      expect(alignments.length, 1);
      expect(alignments[0].score, 13);
      expect(alignments[0].alignedSequence1, 'ATGGTGCACGTGACTCCTGA');
      expect(alignments[0].alignedSequence2, 'ATGGTCCAC-TGACTCCTGT');
    },
  );

  test(
    'alignSequences returns optimal alignments for matching sequences when there are multiple optimal alignments',
    () {
      String sequence1 = "GATTACA";
      String sequence2 = "GATC";
      PairwiseSequenceAligner aligner =
          PairwiseSequenceAligner(sequence1, sequence2);

      List<SequenceAlignment> alignments = aligner.alignSequences();

      List<List<MatrixCell>> matrix = aligner.matrix;
      StringBuffer matrixLog = StringBuffer();
      for (var row in matrix) {
        for (var cell in row) {
          matrixLog.write('${cell.value} ');
        }
        matrixLog.writeln();
      }

      expect(alignments.length, 2);
      expect(alignments[0].score, -2);
      expect(alignments[0].alignedSequence1, 'GATTACA');
      expect(alignments[0].alignedSequence2, 'GA-T-C-');
      expect(alignments[1].alignedSequence1, 'GATTACA');
      expect(alignments[1].alignedSequence2, 'GAT--C-');
    },
  );
}
