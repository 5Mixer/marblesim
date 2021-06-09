package ui;

import kha.graphics2.Graphics;

class Button {
    public var x:Int;
    public var y:Int;
    public var width:Int;
    public var height:Int;
    public var label:String;
    public var sprite:Sprite;
    public var callback:()->Void;

    public function new(label, sprite, callback) {
        this.label = label;
        this.width = 20;
        this.height = 20;
        this.sprite = sprite;
        this.callback = callback;
    }
    public function render(g:Graphics, x, y) {
        sprite.render(g, x, y);
    }
    public function onClick() {
        if (callback != null) {
            callback();
        }else{
            trace("onClick has no callback");
        }
    }
}