int countAccumulation(List<int> amountCategories, List<int> priceCategories) {
  int num = 0;
  try {
    for (int i = 0; i < amountCategories.length; i++) {
      num = num + amountCategories[i] * priceCategories[i];
    }
  } catch (e) {
    return 0;
  }
  return num;
}
