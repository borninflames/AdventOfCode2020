void main(List<String> arguments) async {
  part1();
}

void part1() {
  var game = MemoryGame();
  var t1 = DateTime.now().millisecondsSinceEpoch;
  game.play();
  var t2 = DateTime.now().millisecondsSinceEpoch;
  print('Elapsed milliseconds: ${t2 - t1}');
}

class MemoryGame {
  var input = [0, 5, 4, 1, 10, 14, 7];
  var maxTurn = 30000000;
  int lastSpokenNumber;
  var spokenNumbers = <int, List<int>>{};

  void play() {
    for (var turn = 1; turn <= maxTurn; turn++) {
      if (turn - 1 < input.length) {
        lastSpokenNumber = input[turn - 1];
        spokenNumbers[lastSpokenNumber] = [turn];
      } else {
        if (!spokenNumbers.containsKey(lastSpokenNumber) ||
            spokenNumbers[lastSpokenNumber].length == 1) {
          lastSpokenNumber = 0;
          addTurnToLastSpokenNumber(turn);
        } else {
          lastSpokenNumber = spokenNumbers[lastSpokenNumber].last -
              spokenNumbers[lastSpokenNumber].first;
          if (!spokenNumbers.containsKey(lastSpokenNumber)) {
            spokenNumbers[lastSpokenNumber] = [turn];
          } else {
            addTurnToLastSpokenNumber(turn);
          }
        }
      }
      if (turn == maxTurn) {
        print('Turn ${turn}: ${lastSpokenNumber}');
      }
    }
  }

  void addTurnToLastSpokenNumber(int turn) {
    spokenNumbers[lastSpokenNumber].add(turn);
    if (spokenNumbers[lastSpokenNumber].length > 2) {
      spokenNumbers[lastSpokenNumber].removeAt(0);
    }
  }
}
