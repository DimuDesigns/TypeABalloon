package funtotype.typeaballoon.components;

import funtotype.typeaballoon.vo.Difficulty;
import funtotype.typeaballoon.vo.LessonType;

class GameConfig {
    public var difficulty:Difficulty = Difficulty.EASY;
    public var lessonType:LessonType = LessonType.ALL_LETTERS;

    public function new(){}
}
