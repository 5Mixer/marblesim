package ;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import kha.graphics2.Graphics;

class Tile extends Entity {
    var body:Body;
    public function new(x:Int, y:Int, space:Space) {
        body = new Body(BodyType.STATIC);

        body.shapes.add(new nape.shape.Polygon(Polygon.rect(0, 0, 20, 20)));
        body.position.setxy(x*20, y*20);
        body.space = space;

        this.x = x;
        this.y = y;

        super();
    }
    override public function render(g:Graphics) {
        g.drawScaledImage(kha.Assets.images.tile, x*20, y*20, 20, 20);
    }
    override public function remove() {
        body.space = null;
    }
}