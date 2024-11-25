import 'package:flutter_test/flutter_test.dart';
import 'package:pairwise_sequence_alignment/phylogenetic_tree_generation/models/clade.dart';

void main() {
  test('Clade with no children returns correct newick format string', () {
    Clade clade = Clade(name: 'A', branchLength: 0.0);
    expect(clade.toNewickString(), 'A:0.0');
  });

  test('Clade with 2 children returns correct newick format string', () {
    Clade child1 = Clade(name: 'A');
    child1.branchLength = 0.1;

    Clade child2 = Clade(name: 'B');
    child2.branchLength = 0.2;

    Clade clade = Clade(name: 'root', children: [child1, child2]);
    expect(clade.toNewickString(), '(A:0.1,B:0.2);');
  });

  test('Clade with nested children returns correct newick format string', () {
    Clade a = Clade(name: 'A');
    a.branchLength = 0.1;

    Clade b = Clade(name: 'B');
    b.branchLength = 0.2;

    Clade ab = Clade(children: [a, b], branchLength: 0.3);
    Clade c = Clade(name: 'C', branchLength: 0.4);
    Clade abc = Clade(children: [ab, c]);

    expect(abc.toNewickString(), '((A:0.1,B:0.2):0.3,C:0.4);');
  });
}
