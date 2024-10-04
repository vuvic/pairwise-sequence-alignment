class SequenceAlignment {
  String alignedSequence1;
  String alignedSequence2;
  int score;

  SequenceAlignment(this.alignedSequence1, this.alignedSequence2, this.score);

  @override
  String toString() {
    return 'Sequence 1: $alignedSequence1\nSequence 2: $alignedSequence2\nScore: $score';
  }
}
