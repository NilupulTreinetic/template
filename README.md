# template

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

------------- Run ------------

/** To run dev **/
flutter run -t lib/main_dev.dart --debug --flavor=dev

/** To run prod **/
flutter run -t lib/main_prod.dart --debug --flavor=prod

------------- Release ------------

/** To release dev **/
flutter build apk -t lib/main_dev.dart --release --flavor=dev

/** To release prod **/
flutter build apk -t lib/main_prod.dart --release --flavor=prod

/** To release prod .aab **/
flutter build appbundle -t lib/main_prod.dart --release --flavor=prod
