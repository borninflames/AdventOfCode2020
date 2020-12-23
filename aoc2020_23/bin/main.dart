void main(List<String> arguments) async {
  var game = CrabCups();
  game.playGame(100);
}

class CrabCups {
  //var cups = [3, 2, 4, 1, 5];
  //var cups = [3, 8, 9, 1, 2, 5, 4, 6, 7];
  var cups = [5, 9, 8, 1, 6, 2, 7, 3, 4];

  int playGame(int moves) {
    for (var i = 0; i < moves; i++) {
      move();
    }

    return 0;
  }

  void move() {
    var pickUp = <int>[];
    pickUp = cups.getRange(1, 4).toList();
    cups.removeRange(1, 4);

    var destNum = cups.first;
    var destIndex = -1;
    do {
      destNum--;
      destIndex = cups.indexOf(destNum);
    } while (destIndex == -1 && destNum > 0);

    if (destIndex == -1) {
      destIndex = 0;
      for (var i = 0; i < cups.length; i++) {
        if (cups[i] > cups[destIndex]) {
          destIndex = i;
        }
      }
    }

    //put it back
    cups.insertAll(destIndex + 1, pickUp);

    //shift
    var curr = cups.removeAt(0);
    cups.add(curr);

    print(cups);
  }
}
