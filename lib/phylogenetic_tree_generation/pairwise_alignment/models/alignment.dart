class SequenceAlignment {
  String alignedSequence1;
  String alignedSequence2;
  int score;

  SequenceAlignment(this.alignedSequence1, this.alignedSequence2, this.score);

  int calculateDistance() {
    int distance = 0;
    for (int i = 0; i < alignedSequence1.length; i++) {
      if (alignedSequence1[i] != alignedSequence2[i]) {
        distance++;
      }
    }
    return distance;
  }
}
