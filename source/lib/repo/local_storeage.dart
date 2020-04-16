import 'package:localstorage/localstorage.dart';
import 'package:psv_trophy_editor/util/psn_time.dart';

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
    this.storage.setItem("jitter", jitter);
  }

  void setRange(PSNTime base, PSNTime end) {
    this.storage.setItem("basePSNTime", base.timeString);
    this.storage.setItem("endPSNTime", end.timeString);
  }

  String getLocalLocale() {
    return this.storage.getItem("locale");
  }

  int getLocalJitter() {
    return this.storage.getItem("jitter");
  }

  PSNTime getLocalBasePSNTime() {
    final String timeString = this.storage.getItem("basePSNTime");
    return PSNTime(timeString: timeString);
  }

  PSNTime getLocalEndPSNTime() {
    final String timeString = this.storage.getItem("endPSNTime");
    return PSNTime(timeString: timeString);
  }
}