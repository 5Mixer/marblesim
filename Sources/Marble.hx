package ;

import kha.Assets;
import kha.graphics2.Graphics;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.space.Space;
using kha.graphics2.GraphicsExtension;

class Marble extends Entity {
    var radius = 10;
    public var body:Body;
    public function new(radius = 10, x:Float, y:Float, space:Space) {
        body = new Body(BodyType.DYNAMIC);

        this.radius = radius;
        body.shapes.add(new Circle(radius));
        body.position.setxy(x, y);
        body.setShapeMaterials(nape.phys.Material.glass());
        body.angularVel = 1;
        body.space = space;
        super();
    }
    override public function render(g:Graphics) {
        g.drawScaledImage(Assets.images.marble,body.position.x-10,body.position.y-10,20,20);
    }
    override public function remove() {
        body.space = null;
    }
}