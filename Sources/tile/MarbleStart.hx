package tile;

import kha.graphics2.Graphics;

class MarbleStart extends Entity {
    public var colour:kha.Color;
    public function new(x:Int, y:Int, colour:kha.Color) {
        this.x = x;
        this.y = y;
        this.colour = colour;

        super();
    }
    override public function render(g:Graphics) {
        g.color = colour;
        g.drawScaledImage(kha.Assets.images.marble_start, x*20, y*20, 20, 20);
        g.color = kha.Color.White;
    }
    override public function remove() {
    }
}