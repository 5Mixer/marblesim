package ;

import kha.graphics2.Graphics;

class Cursor {
    public var id = "";
    public var wx:Int = 0;
    public var wy:Int = 0;
    public var name = "";
    public function new () {

    }
    public function render(g:Graphics) {
        g.drawImage(kha.Assets.images.cursor, wx, wy);
        g.font = kha.Assets.fonts.OpenSans_Regular;
        g.fontSize = 22;
        g.color = kha.Color.fromValue(0xffeeeeee);
        g.drawString(name, wx, wy+30);
        g.color = kha.Color.White;
    }
}