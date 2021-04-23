package ;

import kha.Scheduler;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import nape.util.Debug;

class Simulation {
    var space:Space;
    var debug:Debug;
    var circles:Array<Ball> = [];
    var tiles:Array<Tile> = [];
 
    public function new() {
 
        // Create a new simulation Space.
        //   Weak Vec2 will be automatically sent to object pool.
        //   when used as argument to Space constructor.
        var gravity = Vec2.weak(0, 600);
        space = new Space(gravity);
 
        initialise();
    }
 
    function initialise() {
        var w = 6000;
        var h = 900;
 
        // Create the floor for the simulation.
        //   We use a STATIC type object, and give it a single
        //   Polygon with vertices defined by Polygon.rect utility
        //   whose arguments are (x, y) of top-left corner and the
        //   width and height.
        //
        //   A static object does not rotate, so we don't need to
        //   care that the origin of the Body (0, 0) is not in the
        //   centre of the Body's shapes.
        var floor = new Body(BodyType.STATIC);
        floor.shapes.add(new Polygon(Polygon.rect(50, (h - 50), (w - 100), 1)));
        floor.space = space;
 
        // Create a tower of boxes.
        //   We use a DYNAMIC type object, and give it a single
        //   Polygon with vertices defined by Polygon.box utility
        //   whose arguments are the width and height of box.
        //
        //   Polygon.box(w, h) === Polygon.rect((-w / 2), (-h / 2), w, h)
        //   which means we get a box whose centre is the body origin (0, 0)
        //   and that when this object rotates about its centre it will
        //   act as expected.
        for (i in 0...16) {
            var box = new Body(BodyType.DYNAMIC);
            box.shapes.add(new Polygon(Polygon.box(16, 32)));
            box.position.setxy((w / 2), ((h - 50) - 32 * (i + 0.5)));
            box.space = space;
        }
 
        // Create the rolling ball.
        //   We use a DYNAMIC type object, and give it a single
        //   Circle with radius 50px. Unless specified otherwise
        //   in the second optional argument, the circle is always
        //   centered at the origin.
        //
        //   we give it an angular velocity so when it touched
        //   the floor it will begin rolling towards the tower.
        for (i in 0...500) {
            circles.push(new Ball(10, Math.random()*900, Math.random()*400, space));

        }
        for (i in 0...60){
            tiles.push(new Tile(Math.random()*500, 300+Math.random()*500,space));

        }
    }

    public function update() {
        space.step(1/60);
    }
    public function render(g:Graphics) {
        for (ball in circles) {
            ball.render(g);
        }
        for (tile in tiles) {
            tile.render(g);
        }
        // for (box in boxes){
        //     g.fillRect(box.position.x,box.position.y,box.shapes.)
        //     for (shape in box.shapes) {
        //         shape.
        //     }
        //     box.rotation;
        //     box.position;
        //     box.shapes.
        // }

    }
}