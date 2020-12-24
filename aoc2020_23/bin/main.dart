import 'dart:collection';

void main(List<String> arguments) async {
  var input = [5, 9, 8, 1, 6, 2, 7, 3, 4];
  var game = CrabbyCupsGame(input, 1000000, 10000000);
  print(game.playGame());
}

class CrabbyCupsGame {
  List<int> input;
  int length;
  int moves;
  var cups = LinkedList<Cup>();
  var cupVals = <int, Cup>{};
  Cup current;
  Cup destination;

  CrabbyCupsGame(this.input, this.length, this.moves) {
    _initGame();
  }

  int playGame() {
    for (var i = 0; i < moves; i++) {
      if ((i + 1) % 1000000 == 0) {
        print('-- move ${i + 1} --');
      }
      move(i + 1);
    }

    return cupVals[1].next.val * cupVals[1].next.next.val;
  }

  void move(int move) {
    var oneGirl = current.next;
    var twoCup = oneGirl.next;
    var threePuke = twoCup.next;

    threePuke.unlink();
    twoCup.unlink();
    oneGirl.unlink();

    var destVal = current.val - 1;
    while (destVal > 0) {
      if (destVal != oneGirl.val &&
          destVal != twoCup.val &&
          destVal != threePuke.val) {
        destination = cupVals[destVal];
        break;
      }
      destVal--;
    }

    if (destVal == 0) {
      destination = getMax();
    }

    destination.insertAfter(oneGirl);
    oneGirl.insertAfter(twoCup);
    twoCup.insertAfter(threePuke);

    current = current.next;
  }

  void _initGame() {
    cups.addAll(input.map((val) => Cup(val)));
    for (var j = 10; j <= length; j++) {
      cups.add(Cup(j));
    }
    cups.forEach((cup) {
      cupVals[cup.val] = cup;
    });
    current = cups.first;
  }

  Cup getMax() {
    var max = Cup(0);
    cups.forEach((cup) {
      if (max.val < cup.val) {
        max = cup;
      }
    });
    return max;
  }
}

class Cup extends LinkedListEntry<Cup> {
  int val;

  Cup(this.val);

  @override
  Cup get next => super.next ?? super.list.first;

  @override
  String toString() {
    return '${val}';
  }
}
