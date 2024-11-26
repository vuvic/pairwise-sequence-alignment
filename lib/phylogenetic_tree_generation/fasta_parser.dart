import './models/fasta_entry.dart';

class FastaParser {
  static List<FastaEntry> parseFasta(String fastaString) {
    List<FastaEntry> fastaEntries = [];
    List<String> lines = fastaString.split('\n');

    String currentName = '';
    StringBuffer currentSequence = StringBuffer();

    for (String line in lines) {
      if (line.startsWith('>')) {
        if (currentName.isNotEmpty) {
          fastaEntries.add(FastaEntry(currentName, currentSequence.toString()));
          currentSequence.clear();
        }
        currentName = line.substring(1);
      } else {
        currentSequence.write(line);
      }
    }

    if (currentName.isNotEmpty) {
      fastaEntries.add(FastaEntry(currentName, currentSequence.toString()));
    }

    return fastaEntries;
  }
}
