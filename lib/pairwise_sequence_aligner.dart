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
    // Initialize the matrix with the correct dimensions
    List<List<MatrixCell>> matrix = List.generate(
      sequence1.length + 1,
      (i) => List.generate(
        sequence2.length + 1,
        (j) => MatrixCell(value: 0, paths: []),
      ),
    );

    // Fill in the first row and column of the matrix
    for (int i = 1; i < sequence1.length + 1; i++) {
      matrix[i][0].value = i * ScoringScheme.gap;
      matrix[i][0].paths!.add(Index(i: i - 1, j: 0));
    }

    for (int j = 1; j < sequence2.length + 1; j++) {
      matrix[0][j].value = j * ScoringScheme.gap;
      matrix[0][j].paths!.add(Index(i: 0, j: j - 1));
    }

    return matrix;
  }

  List<SequenceAlignment> alignSequences() {
    // Fill in the rest of the matrix
    for (int i = 1; i < sequence1.length + 1; i++) {
      for (int j = 1; j < sequence2.length + 1; j++) {
        matrix[i][j] = calculateCell(i, j);
      }
    }

    List<SequenceAlignment> alignments =
        traceback(sequence1.length, sequence2.length);
    return alignments;
  }

  MatrixCell calculateCell(int i, int j) {
    MatrixCell northwestCell = matrix[i - 1][j - 1];
    MatrixCell northCell = matrix[i - 1][j];
    MatrixCell westCell = matrix[i][j - 1];

    // calculate scores for the three possible paths to the current cell
    int northwestCellScore = northwestCell.value +
        (sequence1[i - 1] == sequence2[j - 1]
            ? ScoringScheme.match
            : ScoringScheme.mismatch);
    int northCellScore = northCell.value + ScoringScheme.gap;
    int westCellScore = westCell.value + ScoringScheme.gap;

    // find the highest score
    List<int> scores = [northwestCellScore, northCellScore, westCellScore];
    int maxScore = scores.reduce(max);

    List<Index> paths = [];
    // add all optimal paths to the current cell
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

  List<SequenceAlignment> traceback(int i, int j) {
    List<SequenceAlignment> currentAlignments = [];

    MatrixCell currentCell = matrix[i][j];
    // Base case
    if (currentCell.paths == null || currentCell.paths!.isEmpty) {
      currentAlignments.add(SequenceAlignment("", "", 0));
      return currentAlignments;
    }

    for (var path in currentCell.paths!) {
      if (path.i == i - 1 && path.j == j - 1) {
        // Get and append to alignments from northwest cell
        List<SequenceAlignment> previousAlignments = traceback(path.i, path.j);
        for (var alignment in previousAlignments) {
          alignment.alignedSequence1 += sequence1[i - 1];
          alignment.alignedSequence2 += sequence2[j - 1];
          alignment.score = currentCell.value;
        }
        currentAlignments.addAll(previousAlignments);
      } else if (path.i == i - 1 && path.j == j) {
        // Get and append to alignments from north cell
        List<SequenceAlignment> previousAlignments = traceback(path.i, path.j);
        for (var alignment in previousAlignments) {
          alignment.alignedSequence1 += sequence1[i - 1];
          alignment.alignedSequence2 += "-";
          alignment.score = currentCell.value;
        }
        currentAlignments.addAll(previousAlignments);
      } else if (path.i == i && path.j == j - 1) {
        // Get and append to alignments from west cell
        List<SequenceAlignment> previousAlignments = traceback(path.i, path.j);
        for (var alignment in previousAlignments) {
          alignment.alignedSequence1 += "-";
          alignment.alignedSequence2 += sequence2[j - 1];
          alignment.score = currentCell.value;
        }
        currentAlignments.addAll(previousAlignments);
      }
    }

    return currentAlignments;
  }
}
