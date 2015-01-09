package funtotype.typeaballoon.systems;

import ash.tools.ListIteratingSystem;
import funtotype.typeaballoon.nodes.CloudRenderNode;

class CloudRenderSystem extends ListIteratingSystem<CloudRenderNode> {
    private var canvas:BitmapData;

    public function new() {
        super(CloudRenderNode, updateNode);
    }

    override public function addToEngine(engine:Engine):Void {
        super.addToEngine(engine);
        canvas = cast(
                engine
                    .getEntityByName("background")
                    .get(CompositeBitmap)
                    .map
                    .get("clouds"),
                BitmapData
            );
    }

    override public function update(time:Float):Void {
        // clear canvas
        canvas.clear();
        super.update(time);
    }

    public function updateNode(node:CloudRenderNode, time:Float):Void {

        //Render
    }
}
