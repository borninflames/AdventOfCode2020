void main(List<String> arguments) async {
  var game = SpaceCards();
  game.play();
}

class SpaceCards {
  //var p1 = [9, 2, 6, 3, 1];
  var p1 = [
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
  ];
  //var p2 = [5, 8, 4, 7, 10];
  var p2 = [
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
  ];

  void play() {
    //var round = 1;
    while (p1.isNotEmpty && p2.isNotEmpty) {
      //print('Round ${round}');
      var c1 = p1.first;
      p1.removeAt(0);
      var c2 = p2.first;
      p2.removeAt(0);

      if (c1 > c2) {
        p1.add(c1);
        p1.add(c2);
      } else {
        p2.add(c2);
        p2.add(c1);
      }

      // if (p1.isNotEmpty && p2.isNotEmpty) {
      //   round++;
      // }
    }

    print('p1: ${p1}');
    print('p2: ${p2}');

    var winnerDeck = p1.isNotEmpty ? p1 : p2;
    winnerDeck = winnerDeck.reversed.toList();
    var sum = 0;
    for (var i = 0; i < winnerDeck.length; i++) {
      sum += winnerDeck[i] * (i + 1);
    }
    print(sum);
  }

  int winnerScore() {
    var winnerDeck = p1.isNotEmpty ? p1 : p2;
    winnerDeck = winnerDeck.reversed.toList();
    var sum = 0;
    for (var i = 0; i < winnerDeck.length; i++) {
      sum += winnerDeck[i] * (i + 1);
    }
    print(sum);
    return sum;
  }
}
