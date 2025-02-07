import 'package:decimal/decimal.dart';

import 'base.dart' show Node;
import 'defs.dart' as defs;

abstract class Leaf extends Node {}

/// A node representing a numeric constant.
class ConstantLeaf extends Leaf {
  static final ConstantLeaf zero = ConstantLeaf(Decimal.zero);
  static final ConstantLeaf one = ConstantLeaf(Decimal.one);

  ConstantLeaf(this.value);
  final Decimal value;

  @override
  Decimal call(Map<String, Decimal> _) => value;

  @override
  String toTeX() => '$value ';

  @override
  String representation([int indent = 0]) => 'Constant $value';

  @override
  String toString() => value.toString();
}

//// A node representing a special numeric constant.
class SpecialConstantLeaf extends Leaf {
  SpecialConstantLeaf(this.constant) : value = defs.constantMap[constant]!;

  final String constant;
  final Decimal value;

  @override
  Decimal call(Map<String, Decimal> _) => value;

  @override
  String toTeX() => defs.constantLatexRepresentation[constant]!;

  @override
  String representation([int indent = 0]) => 'Special Constant $constant';

  @override
  String toString() => constant;
}

//// A node representing a variable.
class VariableLeaf extends Leaf {
  VariableLeaf(this.variable);

  final String variable;

  @override
  Decimal call(Map<String, Decimal> variables) => variables[variable]!;

  @override
  String toTeX() => '$variable ';

  @override
  String representation([int indent = 0]) => 'Variable $variable';

  @override
  String toString() => variable;
}
