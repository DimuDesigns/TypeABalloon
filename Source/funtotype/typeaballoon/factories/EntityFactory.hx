package funtotype.typeaballoon.factories;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.DisplayObjectContainer;
import openfl.display.PixelSnapping;

import openfl.geom.Point;

import ash.core.Entity;
import ash.core.Engine;
import ash.fsm.EntityStateMachine;

import funtotype.typeaballoon.factories.ComponentFactory;
import funtotype.typeaballoon.components.CompositeBitmap;
import funtotype.typeaballoon.vo.Period;
import funtotype.typeaballoon.CustomTypeDefs;

import openfl.Assets;

class EntityFactory {
    private var engine:Engine;
    private var componentFactory:ComponentFactory;

    public function new(engine:Engine, componentFactory:ComponentFactory) {
        this.engine = engine;
        this.componentFactory = componentFactory;
    }

    public function createGame():Entity {
        var game:Entity = new Entity("Game");

        // Create game component
        game
            .add(componentFactory.createGameState(true))
            .add(componentFactory.createGameConfig());

        engine.addEntity(game);

        return game;
    }

    public function createBalloon(x:Float, y:Float, color:UInt):Entity {
        var balloon:Entity = new Entity();

        // Create transform component
        balloon
            .add(componentFactory.createTransform(x, y))
            .add(componentFactory.createDisplay(new Sprite()));

        engine.addEntity(balloon);

        return balloon;
    }

    public function createDart(x:Float, y:Float):Entity {
        var arrow:Entity = new Entity();

        arrow
            .add(componentFactory.createTransform(x, y))
            .add(componentFactory.createDisplay(new Sprite()));

        engine.addEntity(arrow);

        return arrow;
    }

    public function createCannon(x:Float, y:Float, rotation:Float, scale:Float):Entity {
        var cannon:Entity = new Entity();

        cannon
            .add(componentFactory.createTransform(x, y, rotation, scale))
            .add(componentFactory.createDisplay(new Sprite()));

        engine.addEntity(cannon);

        return cannon;
    }

    public function createBackground(width:Int, height:Int, data:Array<BitmapMetaData>, duration:Int, count:Int):Entity {
        var background:Entity = new Entity("background");

        var composite:CompositeBitmap = componentFactory.createCompositeBitmap(data);

        background
            .add(composite)
            .add(componentFactory.createTransform())
            .add(componentFactory.createRenderInfo())
            .add(componentFactory.createCycle(Period.DAY))
            .add(componentFactory.createTimeTracker(duration, count))
            .add(componentFactory.createDisplay(
                new Bitmap(
                    new BitmapData(width, height, true, 0x00000000),
                        PixelSnapping.ALWAYS,
                        false
                    )
                )
            )
            .add(componentFactory.createDayNightCyclerTag())
            .add(componentFactory.createCompositeBitmapRenderTarget());

        engine.addEntity(background);

        return background;
    }

    public function createCloud(x:Int, y:Int, vx:Float, vy:Float, scale:Float):Entity {
        var cloud:Entity = new Entity();

        cloud
            .add(componentFactory.createTransform(x, y, scale))
            .add(componentFactory.createVelocity(vx, vy))
            .add(componentFactory.createDisplay(
                new Bitmap(
                    Assets.getBitmapData("Assets/images/cloud.png"),
                    PixelSnapping.ALWAYS,
                    false
                )
            )
        );

        return cloud;
    }

    public function createView(viewStates:Array<ViewState>, renderToChildContainer:Bool = false, childContainerName:String = ""):Entity {
        var view:Entity = new Entity("View");
        var fsm:EntityStateMachine = new EntityStateMachine(view);

        view.add(componentFactory.createStateMachineInfo(fsm));

        for (state in viewStates) {
            componentFactory.createViewState(
                fsm,
                state,
                renderToChildContainer,
                childContainerName
            );
        }

        engine.addEntity(view);

        return view;
    }

    public function destroyEntity(entity:Entity):Void {
        engine.removeEntity(entity);
    }

}
