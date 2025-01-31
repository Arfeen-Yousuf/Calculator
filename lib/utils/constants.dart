const nanString = 'NaN';

class Constants {
  static const packageName = 'com.arfeen.calculator';
  static const appUrl =
      'https://play.google.com/store/apps/details?id=$packageName';
  static const privacyPolicyUrl =
      'https://github.com/Arfeen-Yousuf/calculator-privacy-policy'
      '/blob/main/privacy-policy.html';

  static const historyLogsPerPage = 50;
}

class CalculatorConstants {
  static const addition = '+';
  static const subtraction = '\u2212';
  static const multiplication = '×';
  static const division = '÷';
  static const percentage = '%';
  static const power = '^';
  static const space = '\u200A';
  static const factorial = '!';

  static const unaryOperators = [percentage, factorial];
}

class ScientificConstants {
  static const pi = 'π';
  static const eular = '\u0117'; //'\u212F';
  static const phi = '\u03D5';

  static final constants = [pi, eular, phi];
}

class ScientificFunctions {
  static const squareRoot = '\u221A';
  static const cubeRoot = '\u221B';
  static const roots = <String>[squareRoot, cubeRoot];

  static const round = 'round';

  //Trigonometric
  static const sine = 'sin';
  static const cosine = 'cos';
  static const tangent = 'tan';
  static const trigonometric = <String>[sine, cosine, tangent];

  //Trigonometric inverses
  static const sineInverse = 'sin⁻¹';
  static const cosineInverse = 'cos⁻¹';
  static const tangentInverse = 'tan⁻¹';
  static const trigonometricInverses = <String>[
    sineInverse,
    cosineInverse,
    tangentInverse
  ];

  //Hyperbolic
  static const sineHyperbolic = 'sinh';
  static const cosineHyperbolic = 'cosh';
  static const tangentHyperbolic = 'tanh';
  static const hyperbolics = <String>[
    sineHyperbolic,
    cosineHyperbolic,
    tangentHyperbolic
  ];

  //Hyperbolic inverses
  static const sineHyperbolicInverse = 'sinh⁻¹';
  static const cosineHyperbolicInverse = 'cosh⁻¹';
  static const tangentHyperbolicInverse = 'tanh⁻¹';
  static const hyperbolicInverses = <String>[
    sineHyperbolicInverse,
    cosineHyperbolicInverse,
    tangentHyperbolicInverse
  ];

  //Logarithms
  static const logarithm = 'log';
  static const naturalLogarithm = 'ln';
  static const logarithms = <String>[logarithm, naturalLogarithm];

  static const absolute = 'abs';
  static const others = <String>[absolute];

  static final functionNames = <String>[
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
