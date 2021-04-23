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
 
    public function initialise() {
        var w = 6000;
        var h = 900;

        circles = [];
        tiles = [];
        space.clear();

        var level = kha.Assets.blobs.level.toString();
        var y = 0;
        var gridSize = 20;
        for (line in level.split("\n")) {
            var x=0;
            for (char in line.split("")) {
                if (char == '#') {
                    tiles.push(new Tile(x*20,y*20,space));
                }

                x++;
            }
            y++;
        }
 
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
 
        for (i in 0...600) {
            circles.push(new Ball(10, i%30*20,Math.floor(i/30)*20, space));
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