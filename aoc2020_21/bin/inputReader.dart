import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<int>();
  var inputStream = file.openRead();
  var foods = <Food>[];
  var ingredientAllergens = <String, String>{};

  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    foods.add(Food(line: line));
  }, onDone: () {
    var a1 = part1(foods, ingredientAllergens);
    part2(ingredientAllergens);
    completer.complete(a1);
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

int part1(List<Food> foods, Map<String, String> ingrAll) {
  for (var i = 0; i < foods.length; i++) {
    findPairs(foods, foods[i], ingrAll);
  }
  print(ingrAll);

  var ingList = foods
      .where((f) => !f.isTemp)
      .map((f) => f.ingredients.where((i) => !ingrAll.containsKey(i)))
      .expand((element) => element)
      .toList();

  return ingList.length;
}

void part2(Map<String, String> ingredientAllergens) {
  var ingrAll = ingredientAllergens.entries.toList(growable: false);
  ingrAll.sort((a, b) => a.value.compareTo(b.value));
  var answer = ingrAll.map((e) => e.key).join(',');
  print(answer);
}

void findPairs(List<Food> foods, Food food, Map<String, String> ingrAll) {
  food.allergens.forEach((a) {
    var filteredFoods =
        foods.where((f) => f.allergens.contains(a)).toList(growable: false);
    var ingredients = food.ingredients
        .where((i) =>
            !ingrAll.containsKey(i) &&
            filteredFoods.every((ff) => ff.ingredients.contains(i)))
        .toList(growable: false);

    if (ingredients.length == 1) {
      print('${ingredients.first} contains ${a}');
      ingrAll[ingredients.first] = a;
      var ftu = foods
          .where((f) =>
              !f.allergens.contains(a) &&
              f.ingredients.contains(ingredients.first))
          .toList(growable: false);

      ftu.forEach((f) {
        f.allergens.add(a);
      });
    } else if (ingredients.length > 1) {
      print('Found more than one for ${a}: ${ingredients}');
      var newFood = Food();
      newFood.isTemp = true;
      newFood.allergens.add(a);
      newFood.ingredients = ingredients;
      foods.add(newFood);
    }
  });
}

class Food {
  var ingredients = <String>[];
  var allergens = <String>[];
  bool isTemp = false;

  Food({String line = ''}) {
    if (line.isNotEmpty) {
      var parts = line.split(' (');
      ingredients = parts[0].split(' ');
      allergens = parts[1].substring(9, parts[1].length - 1).split(', ');
    }
  }

  @override
  String toString() {
    return '${isTemp ? '[*]' : ''} ${ingredients} (${allergens})';
  }
}
