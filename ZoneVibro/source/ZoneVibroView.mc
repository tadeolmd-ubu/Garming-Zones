import Toybox.Activity;
import Toybox.Attention;
import Toybox.Lang;
import Toybox.Time;
import Toybox.UserProfile;
import Toybox.WatchUi;

class ZoneVibroView extends WatchUi.SimpleDataField {

    const ZONE_INTERVALS = [10, 7, 5, 3, 2];

    hidden var _hrZones as Array<Number> or Null;
    hidden var _lastZone as Number or Null;
    hidden var _lastVibeTime as Number or Null;

    function initialize() {
        SimpleDataField.initialize();
        label = "Zona";
        _hrZones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
    }

    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        var hr = info.currentHeartRate;
        if (hr == null || hr <= 0 || _hrZones == null) {
            return "--";
        }
        var zone = _hrZones.size() - 1;
        for (var i = 0; i < _hrZones.size(); i++) {
            if (hr <= _hrZones[i]) {
                zone = i;
                break;
            }
        }
        _updateVibration(zone, info);
        return "Z" + (zone + 1);
    }

    function _updateVibration(zone as Number, info as Activity.Info) as Void {
        var timer = info.timerTime;
        if (timer == null) {
            return;
        }
        var now = (timer as Number) / 1000;
        if (_lastZone == null || zone != _lastZone || _lastVibeTime == null
                || now - _lastVibeTime >= ZONE_INTERVALS[zone]) {
            _lastZone = zone;
            _lastVibeTime = now;
            Attention.vibrate([new Attention.VibeProfile(75, 250)]);
        }
    }

}