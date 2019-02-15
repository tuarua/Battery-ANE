package {

import com.tuarua.BatteryANE;
import com.tuarua.battery.BatteryState;
import com.tuarua.battery.events.BatteryEvent;
import com.tuarua.battery.events.StateEvent;

import flash.desktop.NativeApplication;
import flash.events.Event;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class StarlingRoot extends Sprite {
    private var btnLevel:SimpleButton = new SimpleButton("Get Level");
    private var btnIsCharging:SimpleButton = new SimpleButton("Get State");
    private var battery:BatteryANE;
    private var statusLabel:TextField;

    public function StarlingRoot() {
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        battery = BatteryANE.battery;
        battery.addEventListener(BatteryEvent.ON_CHANGE, onBatteryChange);
        battery.addEventListener(StateEvent.ON_CHANGE, onStateChange);

        initMenu();

    }

    private function onStateChange(event:StateEvent):void {
        switch (event.state) {
            case BatteryState.CHARGING:
                statusLabel.text = "New State: Charging";
                break;
            case BatteryState.UNPLUGGED:
                statusLabel.text = "New State: Unplugged";
                break;
            case BatteryState.UNKNOWN:
                statusLabel.text = "New State: Unknown";
                break;
        }
    }

    private function onBatteryChange(event:BatteryEvent):void {
        statusLabel.text = event.isLow ? "Battery is low" : "Battery is okay";
    }

    private function initMenu():void {
        btnLevel.x = (stage.stageWidth - 200) * 0.5;
        btnLevel.y = 100;
        btnLevel.addEventListener(TouchEvent.TOUCH, onLevelClick);

        btnIsCharging.x = (stage.stageWidth - 200) * 0.5;
        btnIsCharging.y = 180;
        btnIsCharging.addEventListener(TouchEvent.TOUCH, onStateClick);

        addChild(btnLevel);
        addChild(btnIsCharging);

        statusLabel = new TextField(stage.stageWidth, 100, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnIsCharging.y + 75;
        addChild(statusLabel);

    }

    private function onLevelClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnLevel);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            statusLabel.text = Math.floor(battery.level * 100) + "%";
        }
    }

    private function onStateClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnIsCharging);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            switch (battery.state) {
                case BatteryState.CHARGING:
                    statusLabel.text = "Charging";
                    break;
                case BatteryState.FULL:
                    statusLabel.text = "Full";
                    break;
                case BatteryState.UNPLUGGED:
                    statusLabel.text = "Unplugged";
                    break;
                case BatteryState.UNKNOWN:
                    statusLabel.text = "Unknown";
                    break;
            }
        }
    }

    private function onExiting(event:Event):void {
        BatteryANE.dispose();
    }

}
}