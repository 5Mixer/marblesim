package tile;

import kha.math.FastMatrix3;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import kha.graphics2.Graphics;

class Spring extends Entity {
    var body:Body;
    var gridSize = 20;
    var rotation:Float;
    public function new(x:Int, y:Int, space:Space, rotation:SpringDirection, springCallbackType) {
        body = new Body(BodyType.STATIC);

        body.shapes.add(new nape.shape.Polygon(Polygon.rect(-10, -10, 13, 20)));

        var sensor = new nape.shape.Polygon(Polygon.rect(-10+16, -10, 4, 20));
        sensor.sensorEnabled = true;
        sensor.cbTypes.add(springCallbackType);
        sensor.userData.direction = rotation;
        body.shapes.add(sensor);
       
        body.position.setxy(x*20+10, y*20+10);
        body.rotation = Math.PI /2 * rotation.getIndex();
        body.space = space;
        this.rotation = body.rotation;

        this.x = x;
        this.y = y;

        super();
    }
    override public function render(g:Graphics) {
        g.pushTransformation(g.transformation.multmat(FastMatrix3.translation(x*20 + 10, y*20 + 10)).multmat(FastMatrix3.rotation(rotation)).multmat(FastMatrix3.translation(-x*20 - 10, -y*20 - 10)));
        g.drawScaledImage(kha.Assets.images.spring, x*20, y*20, 20, 20);
        g.popTransformation();
    }
    override public function remove() {
        body.space = null;
    }
}