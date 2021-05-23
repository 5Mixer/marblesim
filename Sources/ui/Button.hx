package ui;

import kha.graphics2.Graphics;

class Button {
    public var x:Int;
    public var y:Int;
    public var width:Int;
    public var height:Int;
    var sprite:Sprite;
    public var callback:()->Void;

    public function new(x, y, sprite, callback) {
        this.x = x;
        this.y = y;
        this.width = 20;
        this.height = 20;
        this.sprite = sprite;
        this.callback = callback;
    }
    public function render(g:Graphics) {
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