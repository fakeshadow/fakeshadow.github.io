import 'package:localstorage/localstorage.dart';

class LocalStorageRepo {
  final LocalStorage storage;

  LocalStorageRepo(this.storage);

  static init() {
    final LocalStorage storage = new LocalStorage('psv_trophy_editor');

    return LocalStorageRepo(storage);
  }

  void setLocale(String locale) {
    this.storage.setItem("locale", locale);
  }

  void setJitter(int jitter) {
    if (jitter != null) {
      this.storage.setItem("jitter", jitter);
    }
  }

  void setShowScriptManual(bool showScriptMenu) {
    this.storage.setItem("showScriptMenu", showScriptMenu);
  }

  void setShowStaticManual(bool showScriptMenu) {
    this.storage.setItem("showStaticMenu", showScriptMenu);
  }

  void setRandomRange({DateTime base, DateTime end}) {
    if (base != null) {
      this.storage.setItem("baseDateTime", base.toString());
    }
    if (end != null) {
      this.storage.setItem("endDateTime", end.toString());
    }
  }

  Future<String> getLocalLocale() async {
    final ready = await this.storage.ready.timeout(Duration(seconds: 3));
    if (ready) {
      return this.storage.getItem("locale");
    } else {
      throw ("Can't get localLocale");
    }
  }

  Future<int> getLocalJitter() async {
    return await this.storage.getItem("jitter");
  }

  Future<bool> getLocalShowScriptManual() async {
    return await this.storage.getItem("showScriptMenu");
  }

  Future<bool> getLocalShowStaticManual() async {
    return await this.storage.getItem("showStaticMenu");
  }

  Future<DateTime> getLocalBasePSNTime() async {
    final String timeString = await this.storage.getItem("baseDateTime");
    if (timeString != null) {
      return DateTime.parse(timeString);
    } else {
      return null;
    }
  }

  Future<DateTime> getLocalEndPSNTime() async {
    final String timeString = await this.storage.getItem("endDateTime");
    if (timeString != null) {
      return DateTime.parse(timeString);
    } else {
      return null;
    }
  }
}
