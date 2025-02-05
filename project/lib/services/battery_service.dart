import 'package:battery_plus/battery_plus.dart';

class BatteryService {
  final Battery _battery = Battery();

  Future<int> getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    return level;
  }

  Stream<BatteryState> getBatteryState() {
    return _battery.onBatteryStateChanged;
  }
}