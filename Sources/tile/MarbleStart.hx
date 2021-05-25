package tile;

import kha.graphics2.Graphics;

class MarbleStart extends Entity {
    public function new(x:Int, y:Int) {
        this.x = x;
        this.y = y;

        super();
    }
    override public function render(g:Graphics) {
        g.drawScaledImage(kha.Assets.images.marble_start, x*20, y*20, 20, 20);
    }
    override public function remove() {
    }
}