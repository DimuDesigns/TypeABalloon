package funtotype.typeaballoon.factories;

import ash.fsm.EntityStateMachine;
import ash.fsm.EntityState;
import ash.tools.ComponentPool;

import funtotype.typeaballoon.components.*;
import funtotype.typeaballoon.components.tags.*;
import funtotype.typeaballoon.CustomTypeDefs;

import funtotype.typeaballoon.vo.*;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.Timer;
import openfl.Assets;

class ComponentFactory {
    public function new() {}

    public function createGameState(
            running:Bool,
            lives:Int = 5,
            points:Int = 0,
            paused:Bool = false,
            musicEnabled:Bool = true,
            soundEnabled:Bool = true
        ):GameState {
        var gameState:GameState = new GameState();

        gameState.running = running;
        gameState.lives = lives;
        gameState.points = points;

        gameState.paused = paused;

        gameState.musicEnabled = musicEnabled;
        gameState.soundEnabled = soundEnabled;

        return gameState;
    }

    public function createGameConfig(
            ?difficulty:Difficulty,
            ?lessonType:LessonType
        ):GameConfig {
        var gameConfig:GameConfig = new GameConfig();

        gameConfig.difficulty = (difficulty == null)? Difficulty.EASY : difficulty;
        gameConfig.lessonType = (lessonType == null)? LessonType.ALL_LETTERS : lessonType;

        return gameConfig;
    }

    public function createTransform(x:Float = 0, y:Float = 0, rotation:Float = 0.0, scale:Float = 1.0):Transform2D {
        var transform:Transform2D = new Transform2D();

        transform.x = x;
        transform.y = y;
        transform.rotation = rotation;
        transform.scale = scale;

        return transform;
    }

    public function createVelocity(vx:Float = 0, vy:Float = 0):Velocity {
        var velocity:Velocity = new Velocity();

        velocity.vx = vx;
        velocity.vy = vy;

        return velocity;
    }

    public function createCompositeBitmap(data:Array<BitmapMetaData>):CompositeBitmap {
        var composite:CompositeBitmap = new CompositeBitmap();

        composite.stack = new Array<CompositeBitmapData>();
        composite.map = new Map<String, CompositeBitmapData>();

        for (item in data) {
            var point:Point = new Point(item.x, item.y);
            var bmd:BitmapData = Assets.getBitmapData(item.path);

            composite.stack.push({bitmap:bmd, point:point});
            composite.map.set(item.name, {bitmap:bmd, point:point});
        }

        return composite;
    }

    public function createTimeTracker(delay:Float, count:Int):TimeTracker {
        var tracker:TimeTracker = new TimeTracker();

        tracker.count = count;
        tracker.timer = new Timer(delay, 0);
        tracker.timer.start();

        return tracker;
    }

    public function createDisplay(target:DisplayObject, renderToChildContainer:Bool = false, childContainerName:String = ""):Display {
        var display:Display = new Display();

        display.target = target;
        display.renderToChildContainer = renderToChildContainer;
        display.childContainerName = childContainerName;

        return display;
    }

    public function createCycle(period:Period):Cycle {
        var cycle:Cycle = new Cycle();

        cycle.period = period;

        return cycle;
    }

    public function createRenderInfo(limit:Int = 0, count:Int = 0):RenderInfo {
        var info:RenderInfo = new RenderInfo();

        info.limit = limit;
        info.count = count;

        return info;
    }

    public function createStateMachineInfo(fsm:EntityStateMachine, prevState:String = "", currentState:String = "", nextState:String = ""):StateMachineInfo {
        var info:StateMachineInfo = new StateMachineInfo();

        info.fsm = fsm;
        info.prevState = prevState;
        info.currentState = currentState;
        info.nextState = nextState;

        return info;
    }

    public function createViewState(fsm:EntityStateMachine, state:ViewState, renderToChildContainer:Bool = false, childContainerName:String = ""):Void {
        var entityState:EntityState;
        var menuButton:MenuButton;
        var pos:Point;
        var container:Sprite = new Sprite();

        // Build composite
        var composite:CompositeBitmap = createCompositeBitmap(state.composite);
        var base:Bitmap = new Bitmap(
                new BitmapData(state.width, state.height, true, 0x00000000),
                PixelSnapping.ALWAYS,
                false
            );

        for (item in composite.stack) {
            base.bitmapData.copyPixels(
                item.bitmap,
                item.bitmap.rect,
                item.point,
                null,
                null,
                true
            );
        }

        container.addChild(base);

        for (item in state.buttonGroups) {

            if (item.isMenu) {

                for (buttonInfo in item.buttons) {

                    // create menu button
                    menuButton = new MenuButton(buttonInfo, item.groupID);

                    // add instance to container
                    container.addChild(menuButton);

                    // Position menu button
                    pos = cast(composite.map.get(buttonInfo.name).point, Point);
                    menuButton.x = pos.x;
                    menuButton.y = pos.y;

                    if (buttonInfo.name == item.select) {
                        menuButton.select();
                    }
                }

            } else {
                for (buttonInfo in item.buttons) {
                    var point:Point = cast(composite.map.get(buttonInfo.name).point, Point);
                    var rect:Rectangle = (cast(composite.map.get(buttonInfo.name).bitmap, BitmapData)).rect;

                    var btn:Sprite = new Sprite();
                    btn.name = buttonInfo.name;
                    btn.graphics.beginFill(0x000000, 0);
                    btn.graphics.drawRect(0, 0, rect.width, rect.height);
                    btn.graphics.endFill();
                    btn.buttonMode = true;

                    btn.x = point.x;
                    btn.y = point.y;

                    container.addChild(btn);
                }
            }
        }

        entityState = fsm.createState(state.name);
        entityState
            .add(CompositeBitmap).withInstance(composite)
            .add(Transform2D).withInstance(createTransform(state.x, state.y))
            .add(Display).withInstance(createDisplay(container))
            .add(Transition).withInstance(createTransition(state.inTweens, state.outTweens));

    }

    public function createTransition(inTweens:Array<TweenData>, outTweens:Array<TweenData>):Transition {
        // create button states
        var transition:Transition = new Transition();

        transition.inTweens = inTweens;
        transition.outTweens = outTweens;

        return transition;
    }

    public function createDayNightCyclerTag():DayNightCycler {
        var tag:DayNightCycler = new DayNightCycler();
        return tag;
    }

    public function createCompositeBitmapRenderTarget():CompositeBitmapRenderTarget {
        var tag:CompositeBitmapRenderTarget = new CompositeBitmapRenderTarget();
        return tag;
    }
}
