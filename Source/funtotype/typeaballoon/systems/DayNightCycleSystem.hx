package funtotype.typeaballoon.systems;

import ash.tools.ListIteratingSystem;

import funtotype.typeaballoon.nodes.DayNightCycleNode;
import funtotype.typeaballoon.components.tags.DayNightCycler;
import funtotype.typeaballoon.vo.Period;

import openfl.display.BitmapData;

import motion.Actuate;
import motion.easing.Cubic;

import openfl.geom.Point;

class DayNightCycleSystem extends ListIteratingSystem<DayNightCycleNode> {
    public function new() {
        super(DayNightCycleNode, updateNode);
    }

    private function updateNode(node:DayNightCycleNode, time:Float):Void {
        if (node.tracker.timer.currentCount >= node.tracker.count) {
            node.tracker.timer.stop();
            node.tracker.timer.reset();

            var cycler:DayNightCycler = node.entity.remove(DayNightCycler);

            var point:Point = cast(node.composite.map.get("night").point, Point);

            if (node.cycle.period == Period.DAY) {
                Actuate.tween(point, 2, {y:0}).ease(Cubic.easeInOut).onComplete(restore, [node, cycler]);
                node.cycle.period = Period.NIGHT;
            } else {
                Actuate.tween(point, 2, {y:-400}).ease(Cubic.easeInOut).onComplete(restore, [node, cycler]);
                node.cycle.period = Period.DAY;
            }
        }

    }

    public function restore(node:DayNightCycleNode, cycler:DayNightCycler):Void {
        node.entity.add(cycler);
        node.tracker.timer.start();
    }
}
