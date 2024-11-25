class Clade {
  final String? name; // leaf nodes will be named
  final List<Clade> children;
  double? branchLength; // non-root nodes will have branch lengths

  Clade({this.name, List<Clade>? children, this.branchLength})
      : children = children ?? [];

  String toNewickString() {
    if (children.isEmpty) {
      return '$name:${branchLength.toString()}';
    } else {
      return '(${children.map((child) => child.toNewickString()).join(',')});';
    }
  }
}
