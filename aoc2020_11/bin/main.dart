import 'inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  var ferry = await input_reader.readInputFile('bin/input.txt');

  var width = ferry[0].length;
  var chairsChanged = 0;
  do {
    chairsChanged = 0;
    var newFerry = List<String>.from(ferry);
    for (var row = 1; row < ferry.length - 1; row++) {
      for (var col = 1; col < width - 1; col++) {
        chairsChanged += checkChair(row, col, ferry, newFerry);
      }
    }
    ferry = List<String>.from(newFerry);
  } while (chairsChanged > 0);
  var occupiedSeats = 0;
  ferry.forEach((row) {
    occupiedSeats += '#'.allMatches(row).length;
  });
  print('Occupied seats = ${occupiedSeats}');
}

int checkChair(int row, int col, List<String> ferry, List<String> newFerry) {
  var count = countOccupiedChairs2(row, col, ferry);
  switch (ferry[row][col]) {
    case 'L':
      if (count == 0) {
        changeSeat(row, col, newFerry, '#');
        return 1;
      }
      break;
    case '#':
      if (count >= 5) {
        changeSeat(row, col, newFerry, 'L');
        return 1;
      }
      break;
  }
  return 0;
}

int countOccupiedChairs(int row, int col, List<String> ferry) {
  //part1
  var around = ferry[row - 1].substring(col - 1, col + 2) +
      ferry[row + 1].substring(col - 1, col + 2) +
      ferry[row][col - 1] +
      ferry[row][col + 1];
  var count = '#'.allMatches(around).length;
  return count;
}

int countOccupiedChairs2(int row, int col, List<String> ferry) {
  //part2
  var around = findFirstSeat(row, col, ferry, -1, 0) + //up
      findFirstSeat(row, col, ferry, 1, 0) + //down
      findFirstSeat(row, col, ferry, 0, 1) + //left
      findFirstSeat(row, col, ferry, 0, -1) + //right
      findFirstSeat(row, col, ferry, -1, -1) + //up-left
      findFirstSeat(row, col, ferry, -1, 1) + //up-right
      findFirstSeat(row, col, ferry, 1, -1) + //down-left
      findFirstSeat(row, col, ferry, 1, 1); //down-right

  var count = '#'.allMatches(around).length;
  return count;
}

String findFirstSeat(
    int row, int col, List<String> ferry, int vert, int horiz) {
  row += vert;
  col += horiz;
  var spot = ferry[row][col];
  while (row >= 0 &&
      row < ferry.length &&
      col >= 0 &&
      col < ferry[row].length &&
      spot == '.') {
    spot = ferry[row][col];
    row += vert;
    col += horiz;
  }

  return spot;
}

void changeSeat(int row, int col, List<String> ferry, String chair) {
  ferry[row] = ferry[row].replaceRange(col, col + 1, chair);
}

void printFerry(List<String> ferry) {
  ferry.forEach((row) {
    print(row);
  });
}
