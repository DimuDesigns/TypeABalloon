package funtotype.typeaballoon.nodes;

import ash.core.Node;

import funtotype.typeaballoon.components.tags.CompositeBitmapRenderTarget;
import funtotype.typeaballoon.components.CompositeBitmap;
import funtotype.typeaballoon.components.Display;
import funtotype.typeaballoon.components.RenderInfo;


class CompositeBitmapRenderNode extends Node<CompositeBitmapRenderNode> {
    public var tag:CompositeBitmapRenderTarget;
    public var composite:CompositeBitmap;
    public var display:Display;
    public var info:RenderInfo;
}
