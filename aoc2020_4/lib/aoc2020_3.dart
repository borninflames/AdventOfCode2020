int calculate(List<String> trees) {
  return calcSlopesTrees(trees, 1, 1) *
      calcSlopesTrees(trees, 3, 1) *
      calcSlopesTrees(trees, 5, 1) *
      calcSlopesTrees(trees, 7, 1) *
      calcSlopesTrees(trees, 1, 2);
}

int calcSlopesTrees(List<String> trees, int right, int down) {
  var count = 0;
  var posX = 0;
  var posY = 0;
  var width = trees[0].length;
  do {
    posX += right;
    posX = posX >= width ? posX - width : posX;
    posY += down;
    count += trees[posY][posX] == '#' ? 1 : 0;
  } while (posY < trees.length - down);

  print(count);
  return count;
}
