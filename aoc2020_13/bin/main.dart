//import 'inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  //var ferry = await input_reader.readInputFile('bin/input.txt');
  //part1();
  part2a();
}

void part1() {
  var ts = 1006401;
  var busIds = {17, 37, 449, 23, 13, 19, 607, 41, 29};
  var earliestDepartments = <int>[];

  busIds.forEach((id) {
    earliestDepartments.add(findNextTimestamp(id, ts) - ts);
  });

  print(earliestDepartments);
}

int findNextTimestamp(int ts, int earliestTs) {
  var loop = 1;
  while (ts * loop < earliestTs) {
    loop++;
  }

  return loop * ts;
}

void part2() {
  var t = 99999999999992;
  t = 100000000000000;
  var ids = [
    17,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    37,
    0,
    0,
    0,
    0,
    0,
    449,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    23,
    0,
    0,
    0,
    0,
    13,
    0,
    0,
    0,
    0,
    0,
    19,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    607,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    41,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    29
  ];

  //ids = List<int>.generate(78, (index) => 0);
  //ids.first = 17;
  //ids.last = 29;
  var step = ids.first;
  var lastMin = ids.length - 1;
  var lastId = ids.last;
  var found = false;
  while (!found && t < 100000000000000 + 100000) {
    t += step;
    found = (t + lastMin) % lastId == 0;
    for (var i = 1; i < 12 /*ids.length - 1*/ && found; i++) {
      if (ids[i] != 0) {
        found = (t + i) % ids[i] == 0;
        //print('found for ${ids[i]}');
      }
    }
    if (found) {
      print(t);
      found = false;
    }
  }

  print(t);
}

void part2a() {
  var t = 0;
  var ids = [
    17,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    37,
    0,
    0,
    0,
    0,
    0,
    449,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    23,
    0,
    0,
    0,
    0,
    13,
    0,
    0,
    0,
    0,
    0,
    19,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    607,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    41,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    29
  ];
  //ids = [17, 0, 13, 19];
  //ids = [67, 7, 0, 59, 61];

  var step = ids.first;
  var found = false;
  var compareIndex = 1;
  var timeAtFound = 0;
  while (!found) {
    t += step;
    while (ids[compareIndex] == 0) {
      compareIndex++;
    }

    found = (t + compareIndex) % ids[compareIndex] == 0;
    if (found && timeAtFound == 0) {
      timeAtFound = t;
      found = compareIndex == ids.length - 1;
    }

    if (found && timeAtFound != 0) {
      step = t - timeAtFound;
      timeAtFound = 0;
      found = compareIndex == ids.length - 1;
      compareIndex++;
    }
  }

  print(t);
}
