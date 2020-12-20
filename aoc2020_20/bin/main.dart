import 'inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  var answer = await input_reader.readInputFile('bin/input2.txt');
  print('The answer is: ${answer}');
}
