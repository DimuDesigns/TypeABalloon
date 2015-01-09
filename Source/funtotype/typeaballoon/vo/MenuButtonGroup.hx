package funtotype.typeaballoon.vo;

import funtotype.typeaballoon.vo.MenuButton;

class MenuButtonGroup {
    private var groupID:String;
    public var lastSelected:MenuButton;

    public function new(id:String) {
        groupID = id;
    }

    public function getGroupID():String {
        return groupID;
    }
}
