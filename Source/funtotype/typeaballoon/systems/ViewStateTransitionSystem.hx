package funtotype.typeaballoon.systems;

import openfl.display.DisplayObject;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;

import ash.fsm.EntityStateMachine;

import funtotype.typeaballoon.components.Transform2D;
import funtotype.typeaballoon.components.StateMachineInfo;
import funtotype.typeaballoon.components.Transition;

import funtotype.typeaballoon.nodes.ViewStateTransitionNode;

import funtotype.typeaballoon.utils.ClickTargetCache;

import motion.Actuate;
import motion.easing.*;
import motion.actuators.GenericActuator;

class ViewStateTransitionSystem extends System {
    public var targetCache:ClickTargetCache;

    private var nodes:NodeList<ViewStateTransitionNode>;

    public function new(targetCache:ClickTargetCache) {
        super();
        this.targetCache = targetCache;
    }

    override public function addToEngine(engine:Engine):Void {
        nodes = engine.getNodeList(ViewStateTransitionNode);

        for (node in nodes) {
            transitionIn(node);
        }

        nodes.nodeAdded.add(transitionIn);
        nodes.nodeRemoved.add(transitionOut);
    }

    private function transitionIn(node:ViewStateTransitionNode):Void {
        var actuator:GenericActuator<Transform2D> = null;

        targetCache.disable();

        for (tweenData in node.transition.inTweens) {

            for (prop in Type.getInstanceFields(Transform2D)) {
                if (Reflect.hasField(tweenData, prop)) {
                    Reflect.setProperty(node.transform, prop, tweenData.from);
                }
            }

            actuator = Actuate
                .tween(node.transform, tweenData.duration, tweenData.to)
                .delay(tweenData.delay)
                .ease(Reflect.getProperty(Type.resolveClass(tweenData.ease.type), tweenData.ease.func));

        }

        if (actuator != null) {
            actuator.onComplete(enableTargetCache);
        } else {
            targetCache.enable();
        }
    }

    private function enableTargetCache() {
        targetCache.enable();
    }

    private function transitionOut(node:ViewStateTransitionNode):Void {
        var actuator:GenericActuator<Transform2D> = null;

        for (tweenData in node.transition.outTweens) {
            for (prop in Type.getInstanceFields(Transform2D)) {
                if (Reflect.hasField(tweenData, prop)) {
                    Reflect.setProperty(node.transform, prop, tweenData.from);
                }
            }

            actuator = Actuate
                .tween(node.transform, tweenData.duration, tweenData.to)
                .delay(tweenData.delay)
                .ease(Reflect.getProperty(Type.resolveClass(tweenData.ease.type), tweenData.ease.func));
        }

        if (actuator != null) {
            actuator.onComplete(changeState, [node]);
        } else {
            changeState(node);
        }
    }

    private function changeState(node:ViewStateTransitionNode):Void {
        targetCache.enable();
        node.info.fsm.changeState(node.info.nextState);
    }

    override public function update(time:Float):Void {
        var target:String = targetCache.getLastFetched();

        for (node in nodes) {

            if (target != null && target != "") {
                switch(target) {
                    // Change view state via FSM
                    case "start_btn":
                        node.info.nextState = "options";

                    case "howto_btn":
                        node.info.nextState = "howto";

                    case "howto_pause_btn":
                        node.info.nextState = "howto";

                    case "howto_close_btn":
                        node.info.nextState = node.info.prevState;

                    case "quit_game_btn":
                        node.info.nextState = "title";

                    case "play_btn":
                        node.info.nextState = "score";

                    case "close_pause_btn":
                        node.info.nextState = "score";

                    case "pause_btn":
                        node.info.nextState = "paused";

                }
            }

            if (node.info.nextState != "" && node.info.nextState != node.info.currentState) {
                targetCache.disable();
                node.info.prevState = node.info.currentState;
                node.info.currentState = node.info.nextState;
                node.entity.remove(Transition);
            }
        }
    }

    override public function removeFromEngine(engine:Engine):Void {
        nodes = null;
    }

}
