import 'dart:developer';
import 'dart:io';

String toCamelCase(String input) {
  final parts = input.split('_');
  return parts.first +
      parts.skip(1).map((w) => w[0].toUpperCase() + w.substring(1)).join();
}

void main() {
  const iconFolder = 'assets/svg_icons';
  final iconFiles = Directory(iconFolder)
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.svg'));

  final buffer = StringBuffer();

  buffer.writeln('class SvgIconData {');
  buffer.writeln('  final String name;');
  buffer.writeln('  const SvgIconData._(this.name);');
  buffer.writeln();
  buffer.writeln("  String get path => '$iconFolder/\$name.svg';");
  buffer.writeln();

  for (final file in iconFiles) {
    final filename = file.uri.pathSegments.last;
    final nameWithoutExtension = filename.replaceAll('.svg', '');
    final variableName = toCamelCase(nameWithoutExtension);
    buffer.writeln(
        "  static const $variableName = SvgIconData._('$nameWithoutExtension');");
  }

  buffer.writeln('}');

  final output = buffer.toString();
  //print(output);
  File('lib/svg_icon_data.dart').writeAsStringSync(output);
  log('SvgIconData class generated in lib/svg_icon_data.dart');
}
