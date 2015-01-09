package funtotype.typeaballoon.nodes;

import ash.core.Node;

import funtotype.typeaballoon.components.GameState;
import funtotype.typeaballoon.components.GameConfig;

class GameNode extends Node<GameNode> {
    public var state:GameState;
    public var config:GameConfig;
}
