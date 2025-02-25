extension StringExtensions on String {
  static final singleAlphabetRegex = RegExp(r'[a-zA-Z]');
  static final singleDigitRegex = RegExp(r'[0-9]');

  bool get isAlphabet {
    return length == 1 && startsWith(singleAlphabetRegex);
  }

  bool get isDigit {
    return length == 1 && startsWith(singleDigitRegex);
  }

  bool hasAlphabetAtIndex(int index) {
    return this[index].startsWith(singleAlphabetRegex);
  }

  ///Returns the first character(if any) in the string
  String get first => isEmpty ? '' : this[0];

  ///Removes last character from the string
  String removeFirst() => substring(1);

  ///Returns the last character(if any) in the string
  String get last => isEmpty ? '' : this[length - 1];

  ///Removes last character from the string
  String removeLast() => substring(0, length - 1);
}
