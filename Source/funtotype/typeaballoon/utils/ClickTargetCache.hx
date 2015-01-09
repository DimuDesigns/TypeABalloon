package funtotype.typeaballoon.utils;

import openfl.events.MouseEvent;
import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;

import haxe.ds.ObjectMap;

class ClickTargetCache {
    static private var cacheMap:ObjectMap<DisplayObjectContainer, ClickTargetCache>;

    static public function getInstance(source:DisplayObjectContainer):ClickTargetCache {
        var cache:ClickTargetCache;

        if (cacheMap == null) {
            cacheMap = new ObjectMap<DisplayObjectContainer, ClickTargetCache>();
        }

        if(cacheMap.exists(source)) {
            cache = cacheMap.get(source);
        } else {
            cache = new ClickTargetCache(source);
            cacheMap.set(source, cache);
        }

        return cache;
    }

    private var queue:Array<String>;
    private var enabled:Bool;
    private var lastClicked:String = "";
    private var lastFetched:String;

    public function new(source:DisplayObjectContainer) {
        queue = new Array<String>();
        enabled = true;
        source.addEventListener(MouseEvent.CLICK, onClick);
    }

    private function onClick(e:MouseEvent):Void {
        
        if (!enabled) {
            return;
        }

        var name:String = cast(e.target, DisplayObject).name;

        if(queue.length == 0) {
            lastClicked == "";
        }

        if (name != null && name != "" && name != lastClicked) {
            queue.push(name);
            lastClicked = name;
        }
    }

    public function getTarget():String {
        lastFetched = (queue.length > 0)?queue.shift():null;
        return lastFetched;
    }

    public function getLastFetched():String {
        return lastFetched;
    }

    public function disable():Void {
        enabled = false;
    }

    public function enable():Void {
        enabled = true;
    }

    public function clearCache():Void {
        queue = new Array<String>();
        lastClicked = lastFetched = "";
    }

    public function length():Int {
        return queue.length;
    }
}
