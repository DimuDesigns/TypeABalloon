package funtotype.typeaballoon;

import openfl.events.Event;
import openfl.display.Sprite;

import openfl.display.StageScaleMode;
import openfl.display.StageQuality;
/**
 * Main class
 */
class Main extends Sprite {
    public function new() {
        super();
        stage.scaleMode = StageScaleMode.NO_SCALE;
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        this.name = "Main";
    }

    private function onEnterFrame(event:Event):Void {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);

        var game:TypeABalloonGame = new TypeABalloonGame(this);
        game.start();
    }

}
