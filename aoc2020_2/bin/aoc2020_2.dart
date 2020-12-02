import 'package:aoc2020_2/inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  var validPasswords = await input_reader.readInputFile('lib/input2.txt');
  print('The answer is: ${validPasswords}');
}
