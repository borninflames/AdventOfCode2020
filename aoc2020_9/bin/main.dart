import 'dart:math';
import 'inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  var numbers = await input_reader.readInputFile('bin/input.txt');
  var invalidNumber = -1;
  var index = 25;
  while (invalidNumber == -1 && index < numbers.length) {
    if (!isValid(numbers, index, 25)) {
      invalidNumber = numbers[index];
      continue;
    }
    index++;
  }

  print('The first invalid number is: ${invalidNumber} at ${index}');

  findSet(numbers, index, invalidNumber);
}

bool isValid(List<int> numbers, int index, int preambulum) {
  for (var i = index - preambulum; i < index - 1; i++) {
    for (var j = i + 1; j < index; j++) {
      if (numbers[i] + numbers[j] == numbers[index]) {
        return true;
      }
    }
  }
  return false;
}

void findSet(List<int> numbers, int index, int number) {
  var found = false;
  for (var i = 0; i < index - 1 && !found; i++) {
    var sum = numbers[i];
    for (var j = i + 1; j < index && !found; j++) {
      sum += numbers[j];
      if (sum == number) {
        found = true;
        print('Found set: [${i},${j}]');
        var set = numbers.getRange(i, j).toList();
        var minimum = set.reduce(min);
        var maximum = set.reduce(max);
        var answer = minimum + maximum;
        print(answer);
      }

      if (sum > number) {
        break;
      }
    }
  }
}
