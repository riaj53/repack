
## RePack: The Ultimate Flutter Rename & Package Changer Tool
![RePack Logo](https://raw.githubusercontent.com/riaj53/repack/main/repack.png)

[![pub version](https://img.shields.io/pub/v/stefore_box?color=blue)](https://pub.dev/packages/store_box)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![style: lints](https://img.shields.io/badge/style-lints-40c4ff.svg)](https://pub.dev/packages/lints)

RePack is a fast and powerful command-line utility that completely automates the tedious process of renaming your Flutter app and changing its package ID. Stop wasting time manually editing files! Rebrand your Flutter projects in seconds for Android and iOS.

Whether you're starting from a boilerplate project or need to create different versions of your app (e.g., staging, production), RePack is the perfect tool for your workflow.
## Why Use RePack? 🚀
Manually changing your app's name and package ID is prone to errors. You have to edit multiple files across different platforms, including build.gradle, AndroidManifest.xml, Info.plist, and more. RePack handles all of this automatically.

⚡️ Blazing Fast: Rename and repackage your entire app in under a second.

✅ Cross-Platform: Modifies all necessary files for both Android and iOS.

🧠 Smart & Modern: Automatically detects and handles both build.gradle (Groovy) and build.gradle.kts (Kotlin DSL) for Android.

🎯 All-in-One: Changes the app display name, Android applicationId, Android namespace, and iOS PRODUCT_BUNDLE_IDENTIFIER.

🛠️ Error-Free: Eliminates the risk of manual typos that can break your project.

## Installation
To use RePack, activate it globally from your terminal using `dart pub`
```Bash
dart pub global activate repack
```
This will make the repack command available system-wide.
## How to Use
Navigate to the root directory of your Flutter project in the terminal and run the desired commands.

### 1. Change the App Display Name
To change the name that appears on the user's home screen.

```Command
repack --name "My Awesome App"
```
### 2. Change the Package ID / Bundle Identifier
To change the unique identifier for the Google Play Store and Apple App Store.
```
repack --id "com.mycompany.awesomeapp"
```

## This command is incredibly powerful and updates:

* Android (`build.gradle` or `build.gradle.kts`):

* `applicationId`

* `namespace`

* Android (`AndroidManifest.xml`):

* The package attribute in all manifest files (`main`, `debug`, `profile`).

* Android (`MainActivity.kt` or `MainActivity.java`):

* Updates the `package declaration`.

* Moves the file to the new folder structure (e.g., `com/mycompany/awesomeapp/`).

* iOS (`project.pbxproj`):

* The `PRODUCT_BUNDLE_IDENTIFIER`.

## Frequently Asked Questions (FAQ)
* Q: Does `RePack` work with modern Flutter projects that use `build.gradle.kts`?
  A: Yes! `RePack` automatically detects whether your project uses the traditional Groovy   `build.gradle` or the modern Kotlin `build.gradle.kts` and applies the changes correctly.

* Q: What should I do after running a `repack` command?
  A: It's a good practice to run flutter clean and then restart your IDE (VS Code, Android Studio) to ensure all changes are indexed and recognized by the build system.

* Q: Is it safe to run this on my project?
  A: RePack directly modifies your project's configuration files. While it's tested and reliable, it's highly recommended to have your project under version control (like Git) before running the commands. This way, you can easily review and revert changes if needed.
## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue on GitHub.


## License

MIT License

Copyright (c) 2025 Riazul Islam

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
