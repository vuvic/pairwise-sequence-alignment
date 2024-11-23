class MatrixCell {
  int value;
  List<Index>? paths;

  MatrixCell({required this.value, this.paths});
}

class Index {
  int i;
  int j;

  Index({required this.i, required this.j});
}
