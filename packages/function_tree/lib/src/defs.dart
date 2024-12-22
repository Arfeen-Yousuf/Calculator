import "dart:math";

/// A mapping of string representations to two-parameter functions.
final Map<String, num Function(num, num)> twoParameterFunctionMap = {
  "log": (b, x) => log(x) / log(b),
  "nrt": (n, x) => pow(x, 1 / n),
  "pow": (x, p) => pow(x, p)
};

/// A mapping of string representations of functions to LaTeX.
final Map<String, String> twoParameterFunctionLatexRepresentation = {
  "log": r"\log_{C1}\left(C2\right)",
  "nrt": r"\sqrt[C1]{C2}",
  "pow": r"{C1}^{C2}"
};

/// A mapping of string representations to functions.
final Map<String, num Function(num)> oneParameterFunctionMap = {
  "sin": sin,
  "cos": cos,
  "tan": tan,
  "acos": acos,
  "asin": asin,
  "atan": atan,
  "sinDeg": (x) => sin(x * pi / 180), // Convert degrees to radians
  "cosDeg": (x) => cos(x * pi / 180),
  "tanDeg": (x) => tan(x * pi / 180),
  "asinDeg": (x) => asin(x) * 180 / pi, // Convert radians to degrees
  "acosDeg": (x) => acos(x) * 180 / pi,
  "atanDeg": (x) => atan(x) * 180 / pi,
  "sinh": (x) => (pow(e, x) - pow(e, -x)) / 2,
  "cosh": (x) => (pow(e, x) + pow(e, -x)) / 2,
  "tanh": (x) => (pow(e, x) - pow(e, -x)) / (pow(e, x) + pow(e, -x)),
  "asinh": (x) => log(x + sqrt(x * x + 1)),
  "acosh": (x) => x >= 1
      ? log(x + sqrt(x * x - 1))
      : throw ArgumentError("acosh(x) is defined for x >= 1"),
  "atanh": (x) => (x > -1 && x < 1)
      ? 0.5 * log((1 + x) / (1 - x))
      : throw ArgumentError("atanh(x) is defined for -1 < x < 1"),
  "sqrt": sqrt,
  "cuberoot": (x) => (x >= 0) ? pow(x, 1 / 3) : -pow(-x, 1 / 3),
  "log10": (x) => log(x) / log(10), // Logarithm base 10
  "ln": log, // Natural logarithm (base e)
  "abs": (x) => x.abs(),
  "round": (x) => x.round(),
  "fact": (x) => x.toInt() == x && x >= 0
      ? [for (var i = 1; i <= x; i++) i].fold<double>(1.0, (a, b) => a * b)
      : throw (ArgumentError.value("Factorial expects non negative integer.")),
};

/// A mapping of string representations of functions to LaTeX.
final Map<String, String> oneParameterFunctionLatexRepresentation = {
  "abs": r"\left| C \right| ",
  "acos": r"\arccos\left( C \right) ",
  "asin": r"\arcsin\left( C \right) ",
  "atan": r"\arctan\left( C \right) ",
  "ceil": r"\lceil C \rceil ",
  "cos": r"\cos\left( C \right) ",
  "cosh": r"\cosh\left( C \right) ",
  "cot": r"\cot\left( C \right) ",
  "coth": r"\coth\left( C \right) ",
  "csc": r"\csc\left( C \right) ",
  "csch": r"\csch\left( C \right) ",
  "exp": r"\exp\left( C \right) ",
  "floor": r"\lfloor C \rfloor ",
  "ln": r"\ln\left( C \right) ",
  "log": r"\log\left( C \right) ",
  "round": r"\left[ C \right] ",
  "sec": r"\sec\left( C \right) ",
  "sech": r"\sech\left( C \right) ",
  "sin": r"\sin\left( C \right) ",
  "sinh": r"\sinh\left( C \right) ",
  "sqrt": r"\sqrt{ C } ",
  "tan": r"\tan\left( C \right) ",
  "tanh": r"\tanh\left( C \right) "
};

/// A mapping of string representations to constants.
final Map<String, num> constantMap = {
  "E": e,
  "PI": pi,
  "LN2": ln2,
  "LN10": ln10,
  "LOG2E": log2e,
  "LOG10E": log10e,
  "SQRT1_2": sqrt1_2,
  "SQRT2": sqrt2,
  "e": e,
  "pi": pi,
  "tau": 2 * pi,
  "phi": 1.61803398875,
  "ln2": ln2,
  "ln10": ln10,
  "log2e": log2e,
  "log10e": log10e,
  "sqrt1_2": sqrt1_2,
  "sqrt2": sqrt2,
};

/// A mapping of string representations of constants to LaTeX.
final Map<String, String> constantLatexRepresentation = {
  "E": "e ",
  "LN2": r"\ln 2 ",
  "LN10": r"\ln 10 ",
  "LOG2E": r"\log_2e ",
  "LOG10E": r"\log_{10} e ",
  "PI": r"\pi ",
  "SQRT1_2": r"\frac{\sqrt2}{2} ",
  "SQRT2": r"\sqrt{2} ",
  "e": "e ",
  "ln2": r"\ln 2 ",
  "ln10": r"\ln 10 ",
  "log2e": r"\log_2e ",
  "log10e": r"\log_{10} e ",
  "pi": r"\pi ",
  "sqrt1_2": r"\frac{\sqrt2}{2} ",
  "sqrt2": r"\sqrt{2} "
};
