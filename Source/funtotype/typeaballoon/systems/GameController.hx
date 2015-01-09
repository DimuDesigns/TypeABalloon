package funtotype.typeaballoon.systems;

import ash.core.Engine;
import ash.core.Entity;
import ash.core.System;
import ash.core.NodeList;

import funtotype.typeaballoon.CustomTypeDefs;

import funtotype.typeaballoon.factories.EntityFactory;

import funtotype.typeaballoon.utils.ClickTargetCache;

import funtotype.typeaballoon.nodes.GameNode;

import funtotype.typeaballoon.vo.Difficulty;
import funtotype.typeaballoon.vo.LessonType;

import net.richardlord.input.KeyPoll;

class GameController extends System {
    private var entityFactory:EntityFactory;
    private var nodes:NodeList<GameNode>;

    private var keyPoll:KeyPoll;

    private var targetCache:ClickTargetCache;

    public function new(entityFactory:EntityFactory, targetCache:ClickTargetCache, keyPoll:KeyPoll) {
        super();
        this.entityFactory = entityFactory;
        this.keyPoll = keyPoll;
        this.targetCache = targetCache;
    }

    override public function addToEngine(engine:Engine):Void {
        super.addToEngine(engine);

        nodes = engine.getNodeList(GameNode);
    }

    override public function update(time:Float):Void {
        var target:String = targetCache.getTarget();

        for (node in nodes) {

            if (target != null && target != "") {

                switch(target) {
                    // Update Difficulty
                    case "easy_btn":
                        node.config.difficulty = Difficulty.EASY;

                    case "medium_btn":
                        node.config.difficulty = Difficulty.MEDIUM;

                    case "hard_btn":
                        node.config.difficulty = Difficulty.HARD;

                    // Update Lesson Type
                    case "all_btn":
                        node.config.lessonType = LessonType.ALL_LETTERS;
                    case "home_row_btn":
                        node.config.lessonType = LessonType.HOME_ROW;
                    case "top_row_btn":
                        node.config.lessonType = LessonType.TOP_ROW;
                    case "bottom_row_btn":
                        node.config.lessonType = LessonType.BOTTOM_ROW;
                    case "numbers_btn":
                        node.config.lessonType = LessonType.NUMBERS;
                }
            }

            if (node.state.running) {

            }
        }
    }

    override public function removeFromEngine(engine:Engine):Void {
        nodes = null;
    }
}
