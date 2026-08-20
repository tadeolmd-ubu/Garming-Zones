import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.UserProfile;
import Toybox.WatchUi;

class ZoneVibroView extends WatchUi.SimpleDataField {

    hidden var _hrZones as Array<Number> or Null;

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
        for (var i = 0; i < _hrZones.size(); i++) {
            if (hr <= _hrZones[i]) {
                return "Z" + (i + 1);
            }
        }
        return "Z5";
    }

}