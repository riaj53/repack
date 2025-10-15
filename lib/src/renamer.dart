import 'dart:io';

/// Changes the display name of the app for Android and iOS.
void changeAppName(String newName) {
  _changeAndroidAppName(newName);
  _changeIosAppName(newName);
}

// For Android: Changes the android:label in AndroidManifest.xml
void _changeAndroidAppName(String newName) {
  final manifestFile = File('android/app/src/main/AndroidManifest.xml');
  if (!manifestFile.existsSync()) {
    throw Exception('AndroidManifest.xml not found!');
  }

  String content = manifestFile.readAsStringSync();
  // Using a regular expression to find and replace the android:label
  final regex = RegExp(r'android:label=".*?"');
  content = content.replaceAll(regex, 'android:label="$newName"');

  manifestFile.writeAsStringSync(content);
}

// For iOS: Changes the CFBundleName in Info.plist
void _changeIosAppName(String newName) {
  final plistFile = File('ios/Runner/Info.plist');
  if (!plistFile.existsSync()) {
    throw Exception('Info.plist not found!');
  }

  String content = plistFile.readAsStringSync();
  // Using a regular expression to find and replace the CFBundleName string value
  final regex = RegExp(
    r'<key>CFBundleName</key>\s*<string>.*?</string>',
    dotAll: true,
  );
  content = content.replaceAll(regex, '<key>CFBundleName</key>\n\t<string>$newName</string>');

  plistFile.writeAsStringSync(content);
}