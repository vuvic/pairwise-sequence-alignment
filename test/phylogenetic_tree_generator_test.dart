import 'package:flutter_test/flutter_test.dart';
import 'package:pairwise_sequence_alignment/phylogenetic_tree_generation/phylogenetic_tree_generator.dart';
import 'package:pairwise_sequence_alignment/phylogenetic_tree_generation/models/fasta_entry.dart';
import 'package:pairwise_sequence_alignment/phylogenetic_tree_generation/models/clade.dart';
import 'package:pairwise_sequence_alignment/phylogenetic_tree_generation/models/distance_matrix_entry.dart';

void main() {
  group('PhylogeneticTreeGenerator', () {
    final generator = PhylogeneticTreeGenerator();

    test('initializeDistanceMatrix should create a correct distance matrix',
        () {
      List<FastaEntry> fastaEntries = [
        FastaEntry('seq1', 'AGCT'),
        FastaEntry('seq2', 'AGTT'),
        FastaEntry('seq3', 'TGCA'),
      ];

      List<List<double>> distanceMatrix =
          generator.initializeDistanceMatrix(fastaEntries);

      expect(distanceMatrix.length, 3);
      expect(distanceMatrix[0].length, 3);
      expect(distanceMatrix[0][0], 1000000);
      expect(distanceMatrix[0][1], isNot(1000000));
      expect(distanceMatrix[0][2], isNot(1000000));
      expect(distanceMatrix[1][2], isNot(1000000));
    });

    test('findClosestClades should return the closest clades', () {
      List<List<double>> distanceMatrix = [
        [0, 2.0, 4.0],
        [2.0, 1000000, 3.0],
        [4.0, 3.0, 1000000],
      ];

      DistanceMatrixEntry closestClades =
          generator.findClosestClades(distanceMatrix);

      expect(closestClades.i, 0);
      expect(closestClades.j, 1);
      expect(closestClades.distance, 2.0);
    });

    test(
        'createParentClade should create a parent clade with correct branch lengths',
        () {
      Clade clade1 = Clade(name: 'clade1');
      Clade clade2 = Clade(name: 'clade2');
      double distance = 4.0;

      Clade parent = generator.createParentClade(clade1, clade2, distance);

      expect(parent.children.length, 2);
      expect(parent.children[0].branchLength, 2.0);
      expect(parent.children[1].branchLength, 2.0);
    });

    test('calculateChildBranchLength should return correct branch length', () {
      Clade child = Clade(name: 'child');
      double distance = 4.0;

      double branchLength =
          generator.calculateChildBranchLength(child, distance);

      expect(branchLength, 2.0);
    });

    test('generateTree should generate a correct phylogenetic tree', () {
      List<FastaEntry> fastaEntries = [
        FastaEntry('seq1', 'AGCT'),
        FastaEntry('seq2', 'AGTT'),
        FastaEntry('seq3', 'TGCA'),
      ];

      Clade tree = generator.generateTree(fastaEntries);

      expect(tree.children.length, 2);
    });
  });
}
