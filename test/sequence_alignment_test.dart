import 'package:flutter_test/flutter_test.dart';
import 'package:pairwise_sequence_alignment/phylogenetic_tree_generation/pairwise_alignment/models/alignment.dart';

void main() {
  test(
      'calculateDistance returns correct distance in an alignment without gaps',
      () {
    SequenceAlignment alignment = SequenceAlignment('ABC', 'ABB', 1);

    expect(alignment.calculateDistance(), 1);
  });
  test(
      'calculateDistance returns correct distance in an alignment without gaps',
      () {
    SequenceAlignment alignment = SequenceAlignment('AB-C', 'ABBD', 1);

    expect(alignment.calculateDistance(), 2);
  });
}
