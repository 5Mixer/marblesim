package ;

import nape.geom.Vec2;
import nape.space.Space;
import kha.graphics2.Graphics;

class Simulation {
    var space:Space;
    var entities:Array<Entity> = [];
 
    public function new() {
        var gravity = Vec2.weak(0, 600);
        space = new Space(gravity);
 
        start();
    }
 
    public function start() {
        var level = kha.Assets.blobs.level.toString();
        var y = 0;
        var gridSize = 20;
        for (line in level.split("\n")) {
            var x=0;
            for (char in line.split("")) {
                if (char == '#') {
                    entities.push(new Tile(x*20,y*20,space));
                }
                if (char == '\\') {
                    entities.push(new Slope(x*20,y*20,space));
                }

                x++;
            }
            y++;
        }

        entities.push(new Marble(10, 100, 30, space));
    }

    public function update() {
        space.step(1/60);
    }
    public function render(g:Graphics) {
        for (entity in entities) {
            entity.render(g);
        }
    }
}