class SequenceAlignment {
  final String alignedSequence1;
  final String alignedSequence2;
  final int score;

  SequenceAlignment(this.alignedSequence1, this.alignedSequence2, this.score);

  @override
  String toString() {
    return 'Sequence 1: $alignedSequence1\nSequence 2: $alignedSequence2\nScore: $score';
  }
}
