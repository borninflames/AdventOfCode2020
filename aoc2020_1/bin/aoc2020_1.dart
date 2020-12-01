import 'package:aoc2020_1/aoc2020_1.dart' as aoc2020_1;
import 'package:aoc2020_1/inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  var input = await input_reader.readInputFile('lib/input1.txt');
  print('The answer is: ${aoc2020_1.calculate(input)}');
  print('The 2nd answer is: ${aoc2020_1.calculate2(input)}');
}
