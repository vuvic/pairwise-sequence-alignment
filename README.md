**Pairwise Sequence Alignment CLI FRQ**

FR-01: Prompt the user for a pair of sequences
- Check that the sequences are of the same type
- Ensure that only valid input values are entered

FR-02: Calculate an alignment score for a given pair of sequences.
- Scoring scheme:
    - Match score: +1
    - Mismatch penalty: -1
    - Gap penalty: -2

FR-03: Calculate an optimal alignment for a given pair of sequences.

FR-04: Copy the optimal alignment to a text file.
- The application will store the alignment in FASTA format.

