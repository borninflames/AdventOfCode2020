import 'inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  var memorySum = await input_reader.readInputFile('bin/input.txt');
  print(memorySum);
}
