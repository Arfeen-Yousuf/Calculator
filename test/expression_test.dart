import 'package:flutter_test/flutter_test.dart';
import 'package:function_tree/function_tree.dart';

void main() {
  test('Counter value should be incremented', () {
    const expression = '111112.13+3632542';
    final result = expression.interpret();

    expect(result, 3743654.13);
  });
}
