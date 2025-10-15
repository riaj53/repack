import 'package:repack/repack.dart';
import 'package:args/args.dart';
import 'dart:io';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('name', abbr: 'n', help: 'Set the new application display name.')
    ..addOption('id', abbr: 'i', help: 'Set the new package ID (e.g., com.example.app).');

  try {
    final argResults = parser.parse(arguments);

    if (argResults.options.isEmpty) {
      print('Error: Please provide an option. Use --help for more info.');
      exit(1);
    }

    // --- Handle App Name Change ---
    if (argResults['name'] != null) {
      final newName = argResults['name'] as String;
      print('Changing app display name to: "$newName"');
      changeAppName(newName);
      print('✅ App name changed successfully!');
    }

    // --- Handle Package ID Change ---
    if (argResults['id'] != null) {
      final newId = argResults['id'] as String;
      // Basic validation for package ID format
      if (!RegExp(r'^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+$').hasMatch(newId)) {
        print('Error: Invalid package ID format. Example: com.company.appname');
        exit(1);
      }
      print('Changing package ID to: "$newId"');
      changePackageId(newId);
      print('✅ Package ID changed successfully!');
      print('ℹ️  Note: You may need to run "flutter clean" and restart your IDE.');
    }
  } on FormatException catch (e) {
    print('Error: ${e.message}');
    print(parser.usage);
    exit(1);
  } catch (e) {
    print('An unexpected error occurred: $e');
    exit(1);
  }
}