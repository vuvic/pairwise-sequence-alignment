import './pairwise_alignment/pairwise_sequence_aligner.dart';
import './pairwise_alignment/models/alignment.dart';
import './models/clade.dart';

class PhylogeneticTreeGenerator {
  // computes pairwise alignment of all pairs of input sequences and creates a distance matrix
  List<List<SequenceAlignment>> initializeDistanceMatrix(
      List<String> sequences) {
    List<List<SequenceAlignment>> distanceMatrix = List.generate(
      sequences.length,
      (i) => List.generate(
        sequences.length,
        (j) => SequenceAlignment('', '', 0),
      ),
    );

    for (int i = 0; i < sequences.length; i++) {
      for (int j = i + 1; j < sequences.length; j++) {
        PairwiseSequenceAligner aligner =
            PairwiseSequenceAligner(sequences[i], sequences[j]);
        List<SequenceAlignment> alignments = aligner.alignSequences();
        distanceMatrix[i][j] = alignments[0];
        distanceMatrix[j][i] = alignments[0];
      }
    }

    return distanceMatrix;
  }

  Clade generateTree() {
    return Clade();
  }
}
