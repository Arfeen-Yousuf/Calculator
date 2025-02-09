extension StringExtensions on String {
  static final singleAlphabetRegex = RegExp(r'[a-zA-Z]');

  bool get isAlphabet {
    return length == 1 && startsWith(singleAlphabetRegex);
  }

  bool hasAlphabetAtIndex(int index) {
    return this[index].startsWith(singleAlphabetRegex);
  }
}
