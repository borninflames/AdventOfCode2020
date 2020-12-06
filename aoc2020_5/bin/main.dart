import 'package:aoc2020_5/inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  var maxSeatId = await input_reader.readInputFile('lib/input5.txt');
  print('The maximum seatId: ${maxSeatId}');
}
