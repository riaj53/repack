import 'dart:io';
import 'package:path/path.dart' as p;

/// Changes the package ID for Android and iOS.
void changePackageId(String newId) {
  File buildGradleFile;
  if (File('android/app/build.gradle.kts').existsSync()) {
    buildGradleFile = File('android/app/build.gradle.kts');
  } else if (File('android/app/build.gradle').existsSync()) {
    buildGradleFile = File('android/app/build.gradle');
  } else {
    throw Exception('Could not find build.gradle or build.gradle.kts');
  }

  String gradleContent = buildGradleFile.readAsStringSync();

  final oldIdMatch = RegExp(r'applicationId\s*=?\s*"(.+?)"').firstMatch(gradleContent);
  if (oldIdMatch == null) {
    throw Exception('Could not find applicationId in ${buildGradleFile.path}!');
  }
  final oldId = oldIdMatch.group(1)!;

  gradleContent = gradleContent.replaceAll(
    RegExp(r'applicationId\s*=?\s*"(.+?)"'),
    'applicationId = "$newId"',
  );
  gradleContent = gradleContent.replaceAll(
    RegExp(r'namespace\s*=?\s*"(.+?)"'),
    'namespace = "$newId"',
  );
  buildGradleFile.writeAsStringSync(gradleContent);


  // 2. Update AndroidManifest.xml files
  for (var path in [
    'android/app/src/main/AndroidManifest.xml',
    'android/app/src/debug/AndroidManifest.xml',
    'android/app/src/profile/AndroidManifest.xml',
  ]) {
    final manifestFile = File(path);
    if (manifestFile.existsSync()) {
      String manifestContent = manifestFile.readAsStringSync();
      manifestContent = manifestContent.replaceAll('package="$oldId"', 'package="$newId"');
      manifestFile.writeAsStringSync(manifestContent);
    }
  }

  // 3. Move and update MainActivity file
  // The oldId is used here to find the correct original path
  final oldPath = p.joinAll(['android', 'app', 'src', 'main', 'kotlin', ...oldId.split('.')]);
  final newPath = p.joinAll(['android', 'app', 'src', 'main', 'kotlin', ...newId.split('.')]);

  final mainActivityDir = Directory(oldPath);
  if (mainActivityDir.existsSync()) {
    final mainActivityFile = mainActivityDir.listSync().firstWhere(
          (file) => file.path.endsWith('MainActivity.kt'),
      orElse: () => throw Exception('MainActivity.kt not found in $oldPath'),
    );
    Directory(newPath).createSync(recursive: true);
    String activityContent = (mainActivityFile as File).readAsStringSync();
    activityContent = activityContent.replaceAll('package $oldId', 'package $newId');
    final newFilePath = p.join(newPath, 'MainActivity.kt');
    File(newFilePath).writeAsStringSync(activityContent);
    mainActivityDir.deleteSync(recursive: true);
  } else {
    print('Warning: Kotlin directory for old package ID not found. Skipping MainActivity move.');
  }

  // --- iOS ---
  final pbxprojFile = File('ios/Runner.xcodeproj/project.pbxproj');
  if (!pbxprojFile.existsSync()) throw Exception('iOS project.pbxproj not found!');

  String pbxprojContent = pbxprojFile.readAsStringSync();
  final regex = RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = .+?;');
  pbxprojContent = pbxprojContent.replaceAll(regex, 'PRODUCT_BUNDLE_IDENTIFIER = $newId;');
  pbxprojFile.writeAsStringSync(pbxprojContent);
}