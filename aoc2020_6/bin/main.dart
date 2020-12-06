import 'package:aoc2020_6/inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  var sum = await input_reader.readInputFile('lib/input.txt');
  print('The answer is: ${sum}');
}
