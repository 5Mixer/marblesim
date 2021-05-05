package ;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import kha.graphics2.Graphics;

class Tile extends Entity {
    var body:Body;
    public function new(x:Float, y:Float, space:Space) {
        body = new Body(BodyType.STATIC);

        body.shapes.add(new Polygon(Polygon.box(20, 20)));
        body.position.setxy(x, y);
        body.space = space;
        super();
    }
    override public function render(g:Graphics) {
        g.drawScaledImage(kha.Assets.images.tile, body.position.x-10, body.position.y-10, 20, 20);
    }
}