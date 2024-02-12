enum AppEnvironment {
  dev,
  prod,
}

class AppConfig {
  final String appName;
  final AppEnvironment flavor;

  AppConfig({required this.appName, required this.flavor});
}
