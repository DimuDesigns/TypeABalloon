package funtotype.typeaballoon.components;

import openfl.display.BitmapData;
import openfl.geom.Point;

import funtotype.typeaballoon.CustomTypeDefs;

class CompositeBitmap {
    public var stack:Array<CompositeBitmapData>;
    public var map:Map<String, CompositeBitmapData>;

    public function new() {}
}
