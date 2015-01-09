package funtotype.typeaballoon.systems;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;

import funtotype.typeaballoon.components.Display;
import funtotype.typeaballoon.components.Transform2D;

import funtotype.typeaballoon.nodes.RenderNode;

class RenderSystem extends System {
    public var container:DisplayObjectContainer;

    private var nodes:NodeList<RenderNode>;

    public function new(container:DisplayObjectContainer) {
        super();
        this.container = container;
    }

    override public function addToEngine(engine:Engine):Void {
        nodes = engine.getNodeList(RenderNode);

        for (node in nodes) {
            addToDisplay(node);
        }

        nodes.nodeAdded.add(addToDisplay);
        nodes.nodeRemoved.add(removeFromDisplay);
    }

    private function addToDisplay(node:RenderNode):Void {
        var _container:DisplayObjectContainer = (node.display.renderToChildContainer)?
                cast(container.getChildByName(node.display.childContainerName), DisplayObjectContainer):
                container;

        node.display.target.x = node.transform.x;
        node.display.target.y = node.transform.y;
        node.display.target.rotation = node.transform.rotation;

        _container.addChild(node.display.target);
    }

    private function removeFromDisplay(node:RenderNode):Void {

        if (node.display.renderToChildContainer) {
            cast(container.getChildByName(node.display.childContainerName), DisplayObjectContainer).removeChild(node.display.target);
        } else {
            container.removeChild(node.display.target);
        }

    }

    override public function update(time:Float):Void {

        for (node in nodes) {
            var displayObject:DisplayObject = node.display.target;
            var transform:Transform2D = node.transform;

            displayObject.x = transform.x;
            displayObject.y = transform.y;
            displayObject.rotation = transform.rotation;
        }

    }

    override public function removeFromEngine(engine:Engine):Void {
        nodes = null;
    }

}
