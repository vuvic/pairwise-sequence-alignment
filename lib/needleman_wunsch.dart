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
    List<List<MatrixCell>> matrix = List.generate(
      sequence1.length + 1,
      (i) => List.generate(
        sequence2.length + 1,
        (j) => MatrixCell(value: 0, paths: []),
      ),
    );

    // Fill in the first row and column of the matrix
    for (int i = 0; i < sequence1.length + 1; i++) {
      matrix[i][0].value = i * ScoringScheme.gap;
    }

    for (int j = 0; j < sequence2.length + 1; j++) {
      matrix[0][j].value = j * ScoringScheme.gap;
    }

    return matrix;
  }

  SequenceAlignment alignSequences() {
    // Fill in the rest of the matrix
    for (int i = 1; i < sequence1.length + 1; i++) {
      for (int j = 1; j < sequence2.length + 1; j++) {
        matrix[i][j] = calculateCell(i, j);
      }
    }

    int finalScore = matrix[sequence1.length + 1][sequence2.length + 1].value;
    String alignedSequence1 = "";
    String alignedSequence2 = "";
    return SequenceAlignment(alignedSequence1, alignedSequence2, finalScore);
  }

  MatrixCell calculateCell(int i, int j) {
    // TODO: Implement this method

    MatrixCell northwestCell = matrix[i - 1][j - 1];
    MatrixCell northCell = matrix[i - 1][j];
    MatrixCell westCell = matrix[i][j - 1];

    int northwestCellScore = northwestCell.value +
        (sequence1[i - 1] == sequence2[j - 1]
            ? ScoringScheme.match
            : ScoringScheme.mismatch);
    int northCellScore = northCell.value + ScoringScheme.gap;
    int westCellScore = westCell.value + ScoringScheme.gap;

    List<int> scores = [northwestCellScore, northCellScore, westCellScore];
    int maxScore = scores.reduce(max);

    List<Index> paths = [];

    if (northwestCellScore == maxScore) {
      paths.add(Index(i: i - 1, j: j - 1));
    }
    if (northCellScore == maxScore) {
      paths.add(Index(i: i - 1, j: j));
    }
    if (westCellScore == maxScore) {
      paths.add(Index(i: i, j: j - 1));
    }

    return MatrixCell(value: maxScore, paths: paths);
  }

  String generateAlignedSequence() {
    //TODO: Convert return type to a list of alignments
    String alignedSequence = "";
    Index currentIndex = Index(i: sequence1.length, j: sequence2.length);
    while (currentIndex.i > 0 || currentIndex.j > 0) {
      MatrixCell currentCell = matrix[currentIndex.i][currentIndex.j];
      //TODO: Generate an alignment for each path in the current cell
    }

    return alignedSequence;
  }
}
