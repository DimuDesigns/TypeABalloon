package funtotype.typeaballoon.nodes;

import ash.core.Node;

import funtotype.typeaballoon.components.tags.DayNightCycler;
import funtotype.typeaballoon.components.CompositeBitmap;
import funtotype.typeaballoon.components.Cycle;
import funtotype.typeaballoon.components.TimeTracker;

class DayNightCycleNode extends Node<DayNightCycleNode> {
    public var tag:DayNightCycler;
    public var composite:CompositeBitmap;
    public var cycle:Cycle;
    public var tracker:TimeTracker;
}
