import 'package:flutter_test/flutter_test.dart';
import 'package:pairwise_sequence_alignment/phylogenetic_tree_generation/fasta_parser.dart';
import 'package:pairwise_sequence_alignment/phylogenetic_tree_generation/models/fasta_entry.dart';

void main() {
  group('FastaParser', () {
    test('parses single entry correctly', () {
      String fastaString = '>seq1\nAGCT';
      List<FastaEntry> result = FastaParser.parseFasta(fastaString);

      expect(result.length, 1);
      expect(result[0].name, 'seq1');
      expect(result[0].sequence, 'AGCT');
    });

    test('parses multiple entries correctly', () {
      String fastaString = '>seq1\nAGCT\n>seq2\nCGTA';
      List<FastaEntry> result = FastaParser.parseFasta(fastaString);

      expect(result.length, 2);
      expect(result[0].name, 'seq1');
      expect(result[0].sequence, 'AGCT');
      expect(result[1].name, 'seq2');
      expect(result[1].sequence, 'CGTA');
    });

    test('handles sequences with multiple lines', () {
      String fastaString = '>seq1\nAGC\nT\n>seq2\nCG\nTA';
      List<FastaEntry> result = FastaParser.parseFasta(fastaString);

      expect(result.length, 2);
      expect(result[0].name, 'seq1');
      expect(result[0].sequence, 'AGCT');
      expect(result[1].name, 'seq2');
      expect(result[1].sequence, 'CGTA');
    });

    test('handles sequences with no newline at the end', () {
      String fastaString = '>seq1\nAGCT';
      List<FastaEntry> result = FastaParser.parseFasta(fastaString);

      expect(result.length, 1);
      expect(result[0].name, 'seq1');
      expect(result[0].sequence, 'AGCT');
    });
  });
}
