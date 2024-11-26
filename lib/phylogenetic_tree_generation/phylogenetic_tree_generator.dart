import './pairwise_alignment/pairwise_sequence_aligner.dart';
import './pairwise_alignment/models/alignment.dart';
import './models/clade.dart';
import './models/fasta_entry.dart';
import './models/distance_matrix_entry.dart';

// implements WPGMA algorithm to generate a phylogenetic tree using the clade class
class PhylogeneticTreeGenerator {
  Clade generateTree(List<FastaEntry> fastaEntries) {
    int numClades = fastaEntries.length;

    // Initialize distance matrix
    List<List<double>> distanceMatrix = initializeDistanceMatrix(fastaEntries);

    // initializes a clade for each sequence
    List<Clade> clades =
        fastaEntries.map((entry) => Clade(name: entry.name)).toList();

    // repeat until there is only one clade left
    while (numClades > 1) {
      // find the closest pair of clades
      DistanceMatrixEntry closestClades = findClosestClades(distanceMatrix);
      int minI = closestClades.i;
      int minJ = closestClades.j;
      double distance = closestClades.distance;

      // replace child clades with a single parent clade
      Clade parent = createParentClade(clades[minI], clades[minJ], distance);
      clades[minI] = parent;
      clades.removeAt(minJ);

      // Update entries of child at index minI in distance matrix with parent distance values
      for (int k = 0; k < distanceMatrix.length; k++) {
        if (k != minI && k != minJ) {
          distanceMatrix[minI][k] =
              (distanceMatrix[minI][k] + distanceMatrix[minJ][k]) / 2;
          distanceMatrix[k][minI] = distanceMatrix[minI][k];
        }
      }

      // remove entries of child at index minJ from distance matrix
      distanceMatrix.removeAt(minJ);
      for (int i = 0; i < distanceMatrix.length; i++) {
        distanceMatrix[i].removeAt(minJ);
      }

      numClades--;
    }

    return clades[0];
  }

  // create a distance matrix for all pairs of input sequences
  List<List<double>> initializeDistanceMatrix(List<FastaEntry> fastaEntries) {
    List<String> sequences =
        fastaEntries.map((entry) => entry.sequence).toList();

    // Initialize distance matrix with large numbers as a failsafe
    const double largeNumber = 1000000;
    List<List<double>> distanceMatrix = List.generate(
      sequences.length,
      (i) => List.generate(
        sequences.length,
        (j) => largeNumber,
      ),
    );

    // computes pairwise alignment of all pairs of input sequences
    for (int i = 0; i < sequences.length; i++) {
      for (int j = i + 1; j < sequences.length; j++) {
        PairwiseSequenceAligner aligner = PairwiseSequenceAligner(
          sequences[i],
          sequences[j],
        );
        List<SequenceAlignment> alignments = aligner.alignSequences();
        distanceMatrix[i][j] = alignments[0]
            .calculateDistance()
            .toDouble(); // to accomodate for fractional distances due to division
        distanceMatrix[j][i] = alignments[0].calculateDistance().toDouble();
      }
    }

    return distanceMatrix;
  }

  DistanceMatrixEntry findClosestClades(List<List<double>> distanceMatrix) {
    double minDistance = distanceMatrix[0][1];
    int minI = 0;
    int minJ = 1;

    for (int i = 0; i < distanceMatrix.length; i++) {
      for (int j = i + 1; j < distanceMatrix.length; j++) {
        if (distanceMatrix[i][j] < minDistance) {
          minDistance = distanceMatrix[i][j];
          minI = i;
          minJ = j;
        }
      }
    }

    return DistanceMatrixEntry(distance: minDistance, i: minI, j: minJ);
  }

  Clade createParentClade(Clade clade1, Clade clade2, double distance) {
    clade1.branchLength = calculateChildBranchLength(clade1, distance);
    clade2.branchLength = calculateChildBranchLength(clade2, distance);
    Clade parent = Clade(children: [clade1, clade2]);
    return parent;
  }

  double calculateChildBranchLength(Clade child, double distance) {
    double halfDistance = distance / 2;

    double branchLength = halfDistance;
    while (child.children.isNotEmpty) {
      branchLength -= child.branchLength!;
      child = child.children[0];
    }

    return branchLength;
  }
}
