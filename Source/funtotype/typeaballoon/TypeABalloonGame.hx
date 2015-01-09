package funtotype.typeaballoon;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Assets;

import ash.tick.ITickProvider;
import ash.tick.FrameTickProvider;
import ash.core.Engine;

import funtotype.typeaballoon.systems.GameController;
import funtotype.typeaballoon.systems.DayNightCycleSystem;
import funtotype.typeaballoon.systems.CompositeBitmapRenderSystem;
import funtotype.typeaballoon.systems.ViewStateTransitionSystem;
import funtotype.typeaballoon.systems.RenderSystem;

import funtotype.typeaballoon.factories.EntityFactory;
import funtotype.typeaballoon.factories.ComponentFactory;

import funtotype.typeaballoon.components.TimeTracker;
import funtotype.typeaballoon.components.StateMachineInfo;

import funtotype.typeaballoon.utils.ClickTargetCache;

import net.richardlord.input.KeyPoll;
import net.richardlord.enums.SystemPriorities;

import haxe.Json;

class TypeABalloonGame {

    private var container:DisplayObjectContainer;
    private var engine:Engine;
    private var entityFactory:EntityFactory;
    private var componentFactory:ComponentFactory;
    private var keyPoll:KeyPoll;
    private var tickProvider:FrameTickProvider;
    private var targetCache:ClickTargetCache;
    private var info:StateMachineInfo;

    public function new(container:DisplayObjectContainer) {
        this.container = container;
        targetCache = ClickTargetCache.getInstance(container);

        init();
    }

    private function init() {
        engine = new Engine();
        keyPoll = new KeyPoll(container.stage);
        componentFactory = new ComponentFactory();
        entityFactory = new EntityFactory(engine, componentFactory);

        engine.addSystem(new GameController(entityFactory, targetCache, keyPoll), SystemPriorities.preUpdate);
        engine.addSystem(new DayNightCycleSystem(), SystemPriorities.preUpdate);
        engine.addSystem(new CompositeBitmapRenderSystem(), SystemPriorities.preUpdate);
        engine.addSystem(new ViewStateTransitionSystem(targetCache), SystemPriorities.preUpdate);
        engine.addSystem(new RenderSystem(container), SystemPriorities.update);

        // Create Game entity
        entityFactory.createGame();

        // Create Background entity; start timer for day/night cycle
        entityFactory.createBackground(
            container.stage.stageWidth,
            container.stage.stageHeight,
            Json.parse(Assets.getText("Assets/data/background_composite.json")),
            30000,
            1
        ).get(TimeTracker).timer.start();

        // Create View entity; get ViewInfo component
        info = entityFactory.createView(
            Json.parse(Assets.getText("Assets/data/view_states.json"))
        ).get(StateMachineInfo);

    }

    public function start() {
        tickProvider = new FrameTickProvider(container);
        tickProvider.add(engine.update);
        tickProvider.start();

        info.currentState = "title";
        info.fsm.changeState("title");
    }

    private function killTick(time:Float):Void {
        tickProvider.stop();
    }
}
