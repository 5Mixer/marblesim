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
    public function new(x:Float, y:Float, space:Space) {
        body = new Body(BodyType.DYNAMIC);

        body.shapes.add(new Circle(8));
        body.position.setxy(x, y);
        body.setShapeMaterials(nape.phys.Material.ice());
        body.angularVel = 0;
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