import 'dart:async';
import 'dart:io';
import 'dart:convert';

final String THE_SHINY_SHIT = 'shiny gold bag';

Future<List<Bag>> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<List<Bag>>();
  var bags = <Bag>[];
  var inputStream = file.openRead();
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    bags.add(Bag(line));
  }, onDone: () {
    countTheShinyShit(bags); //part 1

    var theShinyShit = bags.where((el) => el.colour == THE_SHINY_SHIT).first;
    print(countTheShit(theShinyShit, bags)); //part2

    completer.complete(bags);
  }, onError: (e) {
    print(e.toString());
  });

  return completer.future;
}

int countTheShinyShit(List<Bag> bags) {
  var num = bags.where((bag) => canContainTheShinyShit(bag, bags)).length;
  print('The answer is: ${num}');
  return num;
}

bool canContainTheShinyShit(Bag bag, List<Bag> bags) {
  if (bag.bags != null && bag.bags.isNotEmpty) {
    if (bag.bags.any((b) => b.colour == THE_SHINY_SHIT)) {
      return true;
    }

    if (bag.bags.any((b) => canContainTheShinyShit(
        bags.where((el) => el.colour == b.colour).first, bags))) {
      return true;
    }
  }

  return false;
}

int countTheShit(Bag bag, List<Bag> bags) {
  var cunt = 0;
  if (bag.bags != null && bag.bags.isNotEmpty) {
    bag.bags.forEach((b) {
      cunt += (b.amount +
          b.amount *
              countTheShit(
                  bags.where((el) => el.colour == b.colour).first, bags));
    });
    return cunt;
  }

  return cunt;
}

class Bag {
  String colour;
  int amount;
  List<Bag> bags;

  Bag._(this.colour, this.amount, List<Bag> bags) {
    this.bags = bags;
  }

  Bag(String line) {
    line = line.substring(0, line.length - 1);
    var parts = line.split(' contain ');
    bags = <Bag>[];
    if (parts[1] != 'no other bags') {
      var bagsParts = parts[1].split(', ');

      for (var i = 0; i < bagsParts.length; i++) {
        var am = int.tryParse(bagsParts[i][0]);
        var col = bagsParts[i].substring(2, bagsParts[i].length);
        col = col.replaceAll('bags', 'bag');
        bags.add(Bag._(col, am, <Bag>[]));
      }
    }
    colour = parts[0].substring(0, parts[0].length - 1);
    amount = 0;
  }
}
