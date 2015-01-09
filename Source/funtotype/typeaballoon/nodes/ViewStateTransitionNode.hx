package funtotype.typeaballoon.nodes;

import ash.core.Node;

import funtotype.typeaballoon.components.Transform2D;
import funtotype.typeaballoon.components.StateMachineInfo;
import funtotype.typeaballoon.components.Transition;

class ViewStateTransitionNode extends Node<ViewStateTransitionNode> {
    public var transform:Transform2D;
    public var info:StateMachineInfo;
    public var transition:Transition;
}
