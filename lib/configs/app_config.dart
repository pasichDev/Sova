import 'package:noso_dart/models/app_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

final class AppConfig {
  String _appVersion = "";

  static const int durationTimeOut = 3;
  static const int delaySync = 30;
  static const String seedsDNS = "seed.nosocoin.com";

  get getAppInfo => AppInfo(appVersion: "NOSOSOVA_$_appVersion");

  AppConfig() {
    _load();
  }

  Future<void> _load() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
  }
}
