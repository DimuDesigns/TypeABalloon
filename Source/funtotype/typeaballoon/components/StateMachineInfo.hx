package funtotype.typeaballoon.components;

import ash.fsm.EntityStateMachine;

class StateMachineInfo {
    public var fsm:EntityStateMachine;
    public var currentState:String;
    public var prevState:String;
    public var nextState:String;

    public function new() {}
}
