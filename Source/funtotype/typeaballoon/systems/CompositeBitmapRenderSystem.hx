package funtotype.typeaballoon.systems;

import ash.core.Engine;
import ash.tools.ListIteratingSystem;

import funtotype.typeaballoon.nodes.CompositeBitmapRenderNode;

import funtotype.typeaballoon.components.CompositeBitmap;
import funtotype.typeaballoon.components.Display;
import funtotype.typeaballoon.components.tags.CompositeBitmapRenderTarget;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;

class CompositeBitmapRenderSystem extends ListIteratingSystem<CompositeBitmapRenderNode> {

    public function new() {
        super(CompositeBitmapRenderNode, updateNode);
    }

    private function updateNode(node:CompositeBitmapRenderNode, time:Float):Void {
            var target:Bitmap = cast(node.display.target, Bitmap);
            var stack:Array<Dynamic> = node.composite.stack;

            target.bitmapData.lock();

            for (item in stack) {
                target.bitmapData.copyPixels(
                    item.bitmap,
                    item.bitmap.rect,
                    item.point,
                    null,
                    null,
                    true
                    );
            }

            target.bitmapData.unlock();

            if (node.info.limit > 0 && (++node.info.count >= node.info.limit)) {
                node.entity.remove(CompositeBitmapRenderTarget);
            }
    }
}
