import 'dart:math';
import './models/alignment.dart';
import 'models/matrix_cell.dart';
import 'models/scoring_scheme.dart';

class PairwiseSequenceAligner {
  String sequence1;
  String sequence2;
  List<List<MatrixCell>> matrix;

  PairwiseSequenceAligner(this.sequence1, this.sequence2)
      : matrix = generateScoringMatrix(sequence1, sequence2);

  static List<List<MatrixCell>> generateScoringMatrix(
      String sequence1, String sequence2) {
    List<List<MatrixCell>> matrix = []; // Placeholder value
    return matrix;
  }

  SequenceAlignment alignSequences() {
    for (int i = 1; i < sequence1.length; i++) {
      for (int j = 1; j < sequence2.length; j++) {
        matrix[i][j] = calculateCell(matrix, i, j);
      }
    }
    return SequenceAlignment("", "", 0);
  }

  MatrixCell calculateCell(List<List<MatrixCell>> matrix, int i, int j) {
    // TODO: Implement this method

    int value = 0; // Placeholder value
    List<Index> paths = []; // Placeholder paths
    return MatrixCell(value: value, paths: paths);
  }
}
