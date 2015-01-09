package funtotype.typeaballoon.vo;

import openfl.events.Event;
import openfl.events.MouseEvent;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.geom.Point;
import openfl.Assets;

import funtotype.typeaballoon.vo.MenuButtonGroup;
import funtotype.typeaballoon.CustomTypeDefs;

class MenuButton extends Sprite {
    static private var point:Point = null;
    static private var groups:Map<String, MenuButtonGroup> = null;

    static public function createGroup(id:String):MenuButtonGroup {
        if (groups == null) {
            groups = new Map<String, MenuButtonGroup>();
        }

        var group:MenuButtonGroup = new MenuButtonGroup(id);

        groups.set(id, group);

        return group;
    }

    static public function getGroupByID(id:String):MenuButtonGroup {
        if(groups == null || !groups.exists(id)) {
            createGroup(id);
        }
        return groups.get(id);
    }

    static public function getPoint():Point {
        if (point == null) {
            point = new Point();
        }

        return point;
    }

    private var canvas:Bitmap;
    private var drawTarget:BitmapData;

    private var upState:BitmapData;
    private var overState:BitmapData;
    private var selectState:BitmapData;

    private var group:MenuButtonGroup;

    public function new(info:ButtonInfo, groupID:String) {
        super();
        name = info.name;

        upState = Assets.getBitmapData(info.up);
        overState = Assets.getBitmapData(info.over);
        selectState = Assets.getBitmapData(info.selected);

        buttonMode = true;
        mouseChildren = false;

        drawTarget = upState.clone();
        canvas = new Bitmap(drawTarget, PixelSnapping.ALWAYS, false);
        addChild(canvas);

        group = MenuButton.getGroupByID(groupID);

        addEventListener(MouseEvent.MOUSE_OVER, over);
        addEventListener(MouseEvent.MOUSE_OUT, out);

        addEventListener(MouseEvent.CLICK, function(e:Event) {
                select();
            });
    }

    private function removeListeners():Void {
        removeEventListener(MouseEvent.MOUSE_OVER, over);
        removeEventListener(MouseEvent.MOUSE_OUT, out);
    }

    private function addListeners():Void {
        addEventListener(MouseEvent.MOUSE_OVER, over);
        addEventListener(MouseEvent.MOUSE_OUT, out);
    }

    private function over(e:Event):Void {
        drawTarget.lock();
        drawTarget.copyPixels(
            overState,
            overState.rect,
            getPoint()
        );
        drawTarget.unlock();
    }

    private function out(e:Event):Void {
        drawTarget.lock();
        drawTarget.copyPixels(
            upState,
            upState.rect,
            getPoint()
        );
        drawTarget.unlock();
    }

    public function select():Void {
        removeListeners();

        if (group.lastSelected != null) {
            group.lastSelected.deselect();
        }

        buttonMode = false;

        drawTarget.lock();
        drawTarget.copyPixels(
            selectState,
            selectState.rect,
            getPoint()
        );
        drawTarget.unlock();

        group.lastSelected = this;
    }

    public function deselect():Void {
        drawTarget.lock();
        drawTarget.copyPixels(
            upState,
            upState.rect,
            MenuButton.getPoint()
        );
        drawTarget.unlock();

        buttonMode = true;

        addListeners();
    }
}
