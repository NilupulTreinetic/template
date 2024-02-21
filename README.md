
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
