package tile;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import kha.graphics2.Graphics;

class Square extends Entity {
    public var body:Body;
    var colour:kha.Color;

    public function new(x:Int, y:Int, space:Space, colour:kha.Color) {
        body = new Body(BodyType.STATIC);

        this.colour = colour;

        body.shapes.add(new nape.shape.Polygon(Polygon.rect(-10, -10, 20, 20)));
        body.position.setxy(x*20+10, y*20+10);
        body.space = space;

        this.x = x;
        this.y = y;

        super();
    }
    override public function render(g:Graphics) {
        g.color = colour;
        g.drawScaledImage(kha.Assets.images.tile, x*20, y*20, 20, 20);
        g.color = kha.Color.White;
    }
    override public function remove() {
        body.space = null;
    }
}