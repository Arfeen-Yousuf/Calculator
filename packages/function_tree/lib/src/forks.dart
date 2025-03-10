import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:function_tree/src/extensions.dart';

import 'base.dart' show Node;
import 'defs.dart' as defs;

/// General base class for nodes with two child nodes.
abstract class Fork extends Node {
  /// Fork operand.
  final Node left, right;

  /// Fork label in tree representation.
  final String label;

  /// TeX expression generator.
  final String Function(Node, Node) generateTeX;

  /// String expression generator.
  final String Function(Node, Node) generateString;

  /// Operator definition.
  final Decimal Function(Decimal, Decimal) definition;

  Fork({
    required this.left,
    required this.right,
    required this.label,
    required this.generateTeX,
    required this.generateString,
    required this.definition,
  });

  @override
  FutureOr<Decimal> call(Map<String, Decimal> variables) async {
    final result = definition(
      await left(variables),
      await right(variables),
    );
    return result;
  }

  @override
  String toTeX() => generateTeX(left, right);

  @override
  String representation([int indent = 0]) {
    final tab = ' ' * indent;
    return '$label:\n$tab  ${left.representation(indent + 2)}'
        '\n$tab  ${right.representation(indent + 2)}';
  }

  @override
  String toString() => generateString(left, right);
}

/// A node representing the sum of two expressions.
class SumFork extends Fork {
  SumFork(Node left, Node right)
      : super(
          left: left,
          right: right,
          label: 'Sum',
          generateTeX: (left, right) => '${left.toTeX()} + ${right.toTeX()}',
          generateString: (left, right) => '$left + $right',
          definition: (a, b) => a + b,
        );
}

/// A node representing the difference between two expressions.
class DifferenceFork extends Fork {
  DifferenceFork(Node left, Node right)
      : super(
          left: left,
          right: right,
          label: 'Difference',
          generateTeX: (left, right) => '${left.toTeX()} - ${right.toTeX()}',
          generateString: (left, right) => '$left - $right',
          definition: (a, b) => a - b,
        );
}

/// A node representing the product of two expressions.

class ProductFork extends Fork {
  ProductFork(Node left, Node right)
      : super(
          left: left,
          right: right,
          label: 'Product',
          generateTeX: (left, right) =>
              '${left.toTeX()} \cdot ${right.toTeX()}',
          generateString: (left, right) => '$left * $right',
          definition: (a, b) => a * b,
        );
}

/// A node representing the quotient of two expressions.
class QuotientFork extends Fork {
  QuotientFork(Node left, Node right)
      : super(
          left: left,
          right: right,
          label: 'Quotient',
          generateTeX: (left, right) =>
              '\frac{${left.toTeX()}}{${right.toTeX()}}',
          generateString: (left, right) => '($left) / ($right)',
          definition: (a, b) => a.divide(b),
        );
}

/// A node representing the modulus of two expressions.
class ModulusFork extends Fork {
  ModulusFork(Node left, Node right)
      : super(
          left: left,
          right: right,
          label: 'Modulus',
          generateTeX: (left, right) =>
              '${left.toTeX()} \bmod ${right.toTeX()}',
          generateString: (left, right) => '$left % $right',
          definition: (a, b) => a % b,
        );
}

/// A node representing an expression raised to the power of
/// another expression.
class PowerFork extends Fork {
  PowerFork(Node left, Node right)
      : super(
          left: left,
          right: right,
          label: 'Power',
          generateTeX: (left, right) => '${left.toTeX()}^{${right.toTeX()}}',
          generateString: (left, right) => '$left ^ $right',
          definition: (a, b) => a.power(b),
        );
}

/// A node representing a function with two parameters.
class TwoParameterFunctionFork extends Fork {
  TwoParameterFunctionFork(this.name, Node left, Node right)
      : super(
            left: left,
            right: right,
            label: name,
            generateTeX: (left, right) => defs
                .twoParameterFunctionLatexRepresentation[name]!
                .replaceAll('C1', left.toTeX())
                .replaceAll('C2', right.toTeX()),
            generateString: (left, right) => '$name($left, $right)',
            definition: defs.twoParameterFunctionMap[name]!);

  /// The name of the function.
  String name;
}
