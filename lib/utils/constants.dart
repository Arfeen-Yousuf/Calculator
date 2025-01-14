const String nanString = 'NaN';

class Constants {
  static const int historyLogsPerPage = 50;
}

class CalculatorConstants {
  static const String addition = '+';
  static const String subtraction = '\u2212';
  static const String multiplication = '×';
  static const String division = '÷';
  static const String percentage = '%';
  static const String power = '^';
  static const String space = '\u200A';
  static const String factorial = '!';

  static const List<String> unaryOperators = [percentage, factorial];
}

class ScientificConstants {
  static const String pi = 'π';
  static const String eular = '\u0117'; //'\u212F';
  static const String phi = '\u03D5';

  static final constants = [pi, eular, phi];
}

class ScientificFunctions {
  static const String squareRoot = '\u221A';
  static const String cubeRoot = '\u221B';
  static const List<String> roots = [squareRoot, cubeRoot];

  static const String round = 'round';

  //Trigonometric
  static const String sine = 'sin';
  static const String cosine = 'cos';
  static const String tangent = 'tan';
  static const List<String> trigonometric = [sine, cosine, tangent];

  //Trigonometric inverses
  static const String sineInverse = 'sin⁻¹';
  static const String cosineInverse = 'cos⁻¹';
  static const String tangentInverse = 'tan⁻¹';
  static const List<String> trigonometricInverses = [
    sineInverse,
    cosineInverse,
    tangentInverse
  ];

  //Hyperbolic
  static const String sineHyperbolic = 'sinh';
  static const String cosineHyperbolic = 'cosh';
  static const String tangentHyperbolic = 'tanh';
  static const List<String> hyperbolics = [
    sineHyperbolic,
    cosineHyperbolic,
    tangentHyperbolic
  ];

  //Hyperbolic inverses
  static const String sineHyperbolicInverse = 'sinh⁻¹';
  static const String cosineHyperbolicInverse = 'cosh⁻¹';
  static const String tangentHyperbolicInverse = 'tanh⁻¹';
  static const List<String> hyperbolicInverses = [
    sineHyperbolicInverse,
    cosineHyperbolicInverse,
    tangentHyperbolicInverse
  ];

  //Logarithms
  static const String logarithm = 'log';
  static const String naturalLogarithm = 'ln';
  static const List<String> logarithms = [logarithm, naturalLogarithm];

  static const String absolute = 'abs';
  static const List<String> others = [absolute];

  static final List<String> functionNames = [
    ...roots,
    round,
    ...trigonometric,
    ...trigonometricInverses,
    ...hyperbolics,
    ...hyperbolicInverses,
    ...logarithms,
    ...others
  ];
}
