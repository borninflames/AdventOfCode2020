import 'package:collection/collection.dart';

void main(List<String> arguments) async {
  var game = SpaceCards();
  var winner = game.playGame(game.decks, 1);
  game.winnerScore(winner);
}

class SpaceCards {
  var decks = [
    [
      23,
      32,
      46,
      47,
      27,
      35,
      1,
      16,
      37,
      50,
      15,
      11,
      14,
      31,
      4,
      38,
      21,
      39,
      26,
      22,
      3,
      2,
      8,
      45,
      19
    ],
    [
      13,
      20,
      12,
      28,
      9,
      10,
      30,
      25,
      18,
      36,
      48,
      41,
      29,
      24,
      49,
      33,
      44,
      40,
      6,
      34,
      7,
      43,
      42,
      17,
      5
    ]
  ];

  // var decks = [
  //   [9, 2, 6, 3, 1],
  //   [5, 8, 4, 7, 10]
  // ];

  // var decks = [
  //   [43, 19],
  //   [2, 29, 14]
  // ];

  int playGame(List<List<int>> decks, int game) {
    print('=== Game ${game} ===');
    var roundDecks = <List<List<int>>>[];
    while (decks[0].isNotEmpty && decks[1].isNotEmpty) {
      if (votmaren(roundDecks, decks)) {
        print('Vótmáren: ${decks}');
        print(roundDecks);

        return 0;
      }

      roundDecks.add(copyDecks(decks));

      var c1 = decks[0].removeAt(0);
      var c2 = decks[1].removeAt(0);
      var winnerOfTheRound = c1 > c2 ? 0 : 1;

      if (decks[0].length >= c1 && decks[1].length >= c2) {
        winnerOfTheRound = playGame(copyDecks(decks, c1: c1, c2: c2), game++);
      }

      if (winnerOfTheRound == 0) {
        decks[0].add(c1);
        decks[0].add(c2);
      } else {
        decks[1].add(c2);
        decks[1].add(c1);
      }
    }

    var winner = decks[0].isNotEmpty ? 0 : 1;
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

  List<List<int>> copyDecks(List<List<int>> decks, {int c1 = -1, c2 = -1}) {
    var newDeck = <List<int>>[];
    if (c1 == -1 && c2 == -1) {
      newDeck.add(List<int>.from(decks[0]));
      newDeck.add(List<int>.from(decks[1]));
    } else {
      newDeck.add(List<int>.from(decks[0].getRange(0, c1)));
      newDeck.add(List<int>.from(decks[1].getRange(0, c2)));
    }

    return newDeck;
  }

  bool votmaren(List<List<List<int>>> roundDecks, List<List<int>> decks) {
    return roundDecks.any((ds) => ListEquality().equals(ds[0], decks[0]));
  }
}
