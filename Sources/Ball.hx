package ;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.space.Space;

class Ball {
    var radius = 10;
    var body:Body;
    public function new(radius = 10, x:Float, y:Float, space:Space) {
        body = new Body(BodyType.DYNAMIC);

        this.radius = radius;
        body.shapes.add(new Circle(radius));
        body.position.setxy(x, y);
        body.setShapeMaterials(nape.phys.Material.glass());
        body.angularVel = Math.random()-.5;
        body.space = space;
    }
    public function render(g:Graphics) {
        g.drawCircle(body.position.x, body.position.y, radius);
    }
}