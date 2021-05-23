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
    public function new(x:Int, y:Int, space:Space) {
        body = new Body(BodyType.STATIC);

        var shape = new Vec2List();
        shape.push(Vec2.weak(0, 0));
        shape.push(Vec2.weak(0, gridSize));
        shape.push(Vec2.weak(gridSize, gridSize));

        body.shapes.add(new Polygon(shape));
        body.position.setxy(x*20, y*20);
        body.space = space;

        this.x = x;
        this.y = y;

        super();
    }
    override public function render(g:Graphics) {
        g.drawScaledImage(kha.Assets.images.slope, x*20, y*20, 20, 20);
    }
    override public function remove() {
        body.space = null;
    }
}