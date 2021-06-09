package tile;

import kha.math.FastMatrix3;
import nape.geom.Vec2;
import nape.geom.Vec2List;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import kha.graphics2.Graphics;

class InnerSlope extends Entity {
    var body:Body;
    var gridSize = 20;
    var rotation:Float;
    var colour:kha.Color;

    public function new(x:Int, y:Int, space:Space, rotation:TileRotation, colour:kha.Color) {
        body = new Body(BodyType.STATIC);

        this.colour = colour;

        for (i in 1...5) {
            var shape = new Vec2List();
            shape.push(Vec2.weak(gridSize-gridSize*Math.cos(Math.PI/2*(i-1)/4)-10, gridSize*Math.sin(Math.PI/2*(i-1)/4)-10));
            shape.push(Vec2.weak(0-10, gridSize-10)); //Bottom left
            shape.push(Vec2.weak(gridSize-gridSize*Math.cos(Math.PI/2*i/4)-10, gridSize*Math.sin(Math.PI/2*i/4)-10));
            body.shapes.add(new Polygon(shape));
        }

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
        g.drawScaledSubImage(kha.Assets.images.tiles, 150, 0, 50, 50, x*20, y*20, 20, 20);
        g.color = kha.Color.White;
        g.popTransformation();
    }
    override public function remove() {
        body.space = null;
    }
}