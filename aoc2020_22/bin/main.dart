void main(List<String> arguments) async {
  var game = SpaceCards();
  game.playGame(game.decks);
}

class SpaceCards {
  var p1 = [9, 2, 6, 3, 1];
  var p2 = [5, 8, 4, 7, 10];
  var decks = [
    [9, 2, 6, 3, 1],
    [5, 8, 4, 7, 10]
  ];

  int playGame(List<List<int>> decks) {
    while (decks[0].isNotEmpty && decks[1].isNotEmpty) {
      var c1 = decks[0].removeAt(0);
      var c2 = decks[1].removeAt(0);
      if (c1 > c2) {
        decks[0].add(c1);
        decks[0].add(c2);
      } else {
        decks[1].add(c2);
        decks[1].add(c1);
      }
    }

    var winner = decks[0].isNotEmpty ? 0 : 1;
    winnerScore(winner);
    return winner;
  }

  int winnerScore(int winner) {
    var winnerDeck = decks[winner].reversed.toList();
    var sum = 0;
    for (var i = 0; i < winnerDeck.length; i++) {
      sum += winnerDeck[i] * (i + 1);
    }
    print(sum);
    return sum;
  }
}
