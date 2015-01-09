package funtotype.typeaballoon;

import openfl.display.BitmapData;
import openfl.geom.Point;

typedef BitmapMetaData = {
        name:String,
        path:String,
        x:Int,
        y:Int
    }

typedef ButtonInfo = {
        name:String,
        up:String,
        over:String,
        selected:String
    }

typedef ButtonGroup = {
        groupID:String,
        select:String,
        isMenu:Bool,
        buttons:Array<ButtonInfo>
    }

typedef EaseData = {
        type:String,
        func:String
    }

typedef TweenData = {
        delay:Float,
        duration:Float,
        from:Dynamic,
        to:Dynamic,
        ease:EaseData
    }

typedef ViewState = {
        name:String,
        composite:Array<BitmapMetaData>,
        x:Int,
        y:Int,
        width:Int,
        height:Int,
        buttonGroups:Array<ButtonGroup>,
        inTweens:Array<TweenData>,
        outTweens:Array<TweenData>
    }

typedef CompositeBitmapData = {
        bitmap:BitmapData,
        point:Point
    }
