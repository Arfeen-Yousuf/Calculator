import 'dart:async';

import 'package:decimal/decimal.dart';

import 'base.dart' show Node;
import 'defs.dart' as defs;

/// Base class for nodes with a single child node.
abstract class Branch extends Node {
  /// The single child node.
  late final Node child;
}

/// A node representing a function with a single parameter.
class FunctionBranch extends Branch {
  FunctionBranch(this.name, Node child) {
    this.child = child;
  }

  /// The name of the function.
  final String name;

  @override
  FutureOr<Decimal> call(Map<String, Decimal> variables) async {
    final futureDecimal =
        defs.oneParameterFunctionMap[name]!(await child(variables));
    return await futureDecimal;
  }

  @override
  String toTeX() => defs.oneParameterFunctionLatexRepresentation[name]!
      .replaceAll('C', child.toTeX());

  @override
  String representation([int indent = 0]) {
    final tab = ' ' * indent;
    return 'Function $name:\n$tab  ${child.representation(indent + 2)}';
  }

  @override
  String toString() => '$name($child)';
}

/// A node representing parentheses.
class ParenthesisBranch extends Branch {
  ParenthesisBranch(Node child) {
    this.child = child;
  }

  @override
  FutureOr<Decimal> call(Map<String, Decimal> variables) async {
    final futureDecimal = child(variables);
    return await futureDecimal;
  }

  @override
  String toTeX() => r'\left(C\right)'.replaceAll('C', child.toTeX());

  @override
  String representation([int indent = 0]) {
    final tab = ' ' * indent;
    return 'Parentheses:\n$tab  ${child.representation(indent + 2)}';
  }

  @override
  String toString() => '($child)';
}

/// A node representing the negation of an expression.
class NegationBranch extends Branch {
  NegationBranch(Node child) {
    this.child = child;
  }

  @override
  FutureOr<Decimal> call(Map<String, Decimal> variables) async {
    final result = await child(variables);
    return -result;
  }

  @override
  String toTeX() => '-${child.toTeX()}';

  @override
  String representation([int indent = 0]) {
    final tab = ' ' * indent;
    return 'Negation:\n$tab  ${child.representation(indent + 2)}';
  }

  @override
  String toString() => '-$child';
}

/// A node representing the affirmation (unary +) of an expression.
class AffirmationBranch extends Branch {
  AffirmationBranch(Node child) {
    this.child = child;
  }

  @override
  FutureOr<Decimal> call(Map<String, Decimal> variables) async {
    final futureDecimal = child(variables);
    return await futureDecimal;
  }

  @override
  String toTeX() => '+${child.toTeX()}';

  @override
  String representation([int indent = 0]) {
    final tab = ' ' * indent;
    return 'Affirmation:\n$tab  ${child.representation(indent + 2)}';
  }

  @override
  String toString() => '+$child';
}
