package funtotype.typeaballoon.components;

class GameState{
    public var running:Bool = false;
    public var lives:Int = 5;
    public var points:Int = 0;

    public var paused:Bool = false;

    public var soundEnabled:Bool = true;
    public var musicEnabled:Bool = true;

	public function new(){}
}
