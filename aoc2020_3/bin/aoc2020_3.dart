import 'package:aoc2020_3/aoc2020_3.dart' as aoc2020_3;
import 'package:aoc2020_3/inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  var trees = await input_reader.readInputFile('lib/input3.txt');
  print(aoc2020_3.calculate(trees));
}
