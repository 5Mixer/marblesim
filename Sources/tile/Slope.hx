package tile;

import kha.math.FastMatrix3;
import nape.geom.Vec2;
import nape.geom.Vec2List;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import kha.graphics2.Graphics;

class Slope extends Entity {
    var body:Body;
    var gridSize = 20;
    var rotation:Float;
    public function new(x:Int, y:Int, space:Space, rotation:TileRotation) {
        body = new Body(BodyType.STATIC);

        var shape = new Vec2List();
        shape.push(Vec2.weak(0-10, -10));
        shape.push(Vec2.weak(0-10, gridSize-10));
        shape.push(Vec2.weak(gridSize-10, gridSize-10));

        body.shapes.add(new Polygon(shape));
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
        g.drawScaledImage(kha.Assets.images.slope, x*20, y*20, 20, 20);
        g.popTransformation();
    }
    override public function remove() {
        body.space = null;
    }
}