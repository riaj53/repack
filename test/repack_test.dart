import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:repack/repack.dart';
import 'package:test/test.dart';

// Mock file contents for a typical Flutter project
const mockAndroidManifest = '''
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.oldapp">
   <application
        android:label="OldApp"
        android:name="io.flutter.app.FlutterApplication">
   </application>
</manifest>
''';

const mockInfoPList = '''
<dict>
	<key>CFBundleName</key>
	<string>OldApp</string>
</dict>
''';

const mockPbxproj = '''
		ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
		PRODUCT_BUNDLE_IDENTIFIER = com.example.oldapp;
		PRODUCT_NAME = \$(FLUTTER_BUILD_NAME);
''';

const mockMainActivity = '''
package com.example.oldapp

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
''';

void main() {
  group('RePack Tool Tests', () {
    late Directory tempDir;
    late String originalDirectory;

    // Before each test, create a temporary directory and a complete fake project structure
    setUp(() {
      originalDirectory = Directory.current.path;
      tempDir = Directory.systemTemp.createTempSync('repack_test_');

      // Change the current directory to the temp one so the tool finds the files
      Directory.current = tempDir;

      // Mock build.gradle.kts file with a namespace
      final mockBuildGradleKts = '''
      android {
          namespace = "com.example.oldapp"
          defaultConfig {
              applicationId = "com.example.oldapp"
          }
      }
      ''';

      // Create all necessary mock files for the tests
      File(p.join('android', 'app', 'src', 'main', 'AndroidManifest.xml'))
        ..createSync(recursive: true)
        ..writeAsStringSync(mockAndroidManifest);

      File(p.join('android', 'app', 'build.gradle.kts'))
        ..createSync(recursive: true)
        ..writeAsStringSync(mockBuildGradleKts);

      File(p.join('ios', 'Runner', 'Info.plist'))
        ..createSync(recursive: true)
        ..writeAsStringSync(mockInfoPList);

      File(p.join('ios', 'Runner.xcodeproj', 'project.pbxproj'))
        ..createSync(recursive: true)
        ..writeAsStringSync(mockPbxproj);

      final mainActivityPath = p.join('android', 'app', 'src', 'main', 'kotlin', 'com', 'example', 'oldapp', 'MainActivity.kt');
      File(mainActivityPath)
        ..createSync(recursive: true)
        ..writeAsStringSync(mockMainActivity);
    });

    // After each test, clean up the temporary directory
    tearDown(() {
      Directory.current = originalDirectory;
      tempDir.deleteSync(recursive: true);
    });

    test('changeAppName should update AndroidManifest.xml and Info.plist', () {
      const newName = 'NewCoolApp';
      changeAppName(newName);

      final androidManifest = File(p.join('android', 'app', 'src', 'main', 'AndroidManifest.xml')).readAsStringSync();
      final infoPlist = File(p.join('ios', 'Runner', 'Info.plist')).readAsStringSync();

      expect(androidManifest, contains('android:label="$newName"'));
      expect(infoPlist, contains('<string>$newName</string>'));
    });

    test('changePackageId should update all relevant files', () {
      const newId = 'com.awesome.newid';
      changePackageId(newId);

      final buildGradle = File(p.join('android', 'app', 'build.gradle.kts')).readAsStringSync();
      final pbxproj = File(p.join('ios', 'Runner.xcodeproj', 'project.pbxproj')).readAsStringSync();

      // Check for the Kotlin format with the equals sign
      expect(buildGradle, contains('applicationId = "$newId"'));
      expect(buildGradle, contains('namespace = "$newId"'));
      expect(pbxproj, contains('PRODUCT_BUNDLE_IDENTIFIER = $newId;'));

      // Check if MainActivity was moved and its package declaration updated
      final oldMainActivityPath = p.join('android', 'app', 'src', 'main', 'kotlin', 'com', 'example', 'oldapp');
      final newMainActivityFile = File(p.join('android', 'app', 'src', 'main', 'kotlin', 'com', 'awesome', 'newid', 'MainActivity.kt'));

      expect(Directory(oldMainActivityPath).existsSync(), isFalse, reason: "Old directory should be deleted.");
      expect(newMainActivityFile.existsSync(), isTrue, reason: "New MainActivity file should be created.");
      expect(newMainActivityFile.readAsStringSync(), startsWith('package $newId'), reason: "MainActivity package declaration should be updated.");
    });
  });
}