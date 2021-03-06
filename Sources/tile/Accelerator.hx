package tile;

import kha.math.FastMatrix3;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import kha.graphics2.Graphics;

class Accelerator extends Entity {
    var body:Body;
    var rotation:Float;
    var colour = kha.Color.White;
    public function new(x:Int, y:Int, space:Space, rotation:SpringDirection, colour:kha.Color, acceleratorCallbackType) {
        body = new Body(BodyType.STATIC);

        this.colour = colour;

        var sensor = new nape.shape.Polygon(Polygon.rect(-8, -8, 16, 16));
        sensor.sensorEnabled = true;
        sensor.cbTypes.add(acceleratorCallbackType);
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
        g.color = colour;
        g.drawScaledImage(kha.Assets.images.accelerator, x*20, y*20, 20, 20);
        g.color = kha.Color.White;
        g.popTransformation();
    }
    override public function remove() {
        body.space = null;
    }
}