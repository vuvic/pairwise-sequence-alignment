class Clade {
  final String name;
  final List<Clade> children; // subclades or leaves
  double branchLength = 0;
  int? bootStrapValue;

  Clade(this.name, this.children);

  String toNewickString() {
    if (children.isEmpty) {
      return '$name:${branchLength.toString()}';
    }
    String childrenString =
        children.map((child) => child.toNewickString()).join(',');
    return '($childrenString)${bootStrapValue.toString()}';
  }
}
