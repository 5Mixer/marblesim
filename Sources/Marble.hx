package ;

import kha.Assets;
import kha.graphics2.Graphics;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.space.Space;
using kha.graphics2.GraphicsExtension;

class Marble extends Entity {
    var radius = 8;
    public var body:Body;
    var colour:kha.Color;

    public function new(x:Float, y:Float, colour:kha.Color, space:Space) {
        body = new Body(BodyType.DYNAMIC);

        this.colour = colour;

        body.shapes.add(new Circle(8));
        body.position.setxy(x, y);
        body.setShapeMaterials(nape.phys.Material.ice());
        body.angularVel = 0;
        body.space = space;
        super();
    }
    override public function render(g:Graphics) {
        g.color = colour;
        g.drawScaledImage(Assets.images.marble,body.position.x-10,body.position.y-10,20,20);
        g.color = kha.Color.White;
    }
    override public function remove() {
        body.space = null;
    }
}