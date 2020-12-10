import 'inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  var adapters = await input_reader.readInputFile('bin/input.txt');
  adapters.add(0);
  adapters.sort();
  adapters.add(adapters.last + 3);

  var joltDiffs = [-1, 0, 0, 0];
  var currentJolt = 0;
  for (var i = 0; i < adapters.length; i++) {
    joltDiffs[adapters[i] - currentJolt]++;
    currentJolt = adapters[i];
  }

  print(joltDiffs);

  print('The answer is: ${joltDiffs[1] * joltDiffs[3]}');

  print(adapters);
  var ways = List<int>.generate(adapters.last + 1, (i) => 0);
  ways[adapters[0]] = 1;
  ways[adapters[1]] = 1;

  for (var i = 2; i < adapters.length; i++) {
    for (var j = 3; j > 0; j--) {
      if (i - j >= 0 && adapters[i - j] >= adapters[i] - 3) {
        ways[adapters[i]] += ways[adapters[i - j]];
      }
    }
    print('Adapter: ${adapters[i]} - ways: ${ways[adapters[i]]}');
  }
}
