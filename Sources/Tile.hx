package ;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;

class Tile {
    var body:Body;
    public function new(x:Float, y:Float, space:Space) {
        body = new Body(BodyType.STATIC);

        body.shapes.add(new Polygon(Polygon.box(20, 20)));
        body.position.setxy(x, y);
        body.space = space;
    }
    public function render(g:Graphics) {
        g.drawImage(body.position.x-10, body.position.y-10, 20, 20, kha.Assets.images.tile);
    }
}