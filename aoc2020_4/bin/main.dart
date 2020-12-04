import 'package:aoc2020_4/inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  var validIdsCount = await input_reader.readInputFile('lib/input4.txt');
  print(validIdsCount);
}
