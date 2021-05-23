package ;

import nape.geom.Vec2;
import nape.space.Space;
import kha.graphics2.Graphics;

class Simulation {
    var space:Space;
    var entities:Array<Entity> = [];
    var marble:Marble;
 
    public function new() {
        var gravity = Vec2.weak(0, 600);
        space = new Space(gravity);
    }
 
    public function placeTile(x,y,tile:TileType) {
        for (entity in entities) {
            if (entity.x == x && entity.y == y) {
                entity.remove();
                entities.remove(entity);
            }
        }
        switch tile {
            case Empty: {};
            case Square: entities.push(new tile.Square(x,y,space));
            case Slope(rotation): entities.push(new tile.Slope(x,y,space,rotation));
        }

    }
    public function start() {
        stop();
        marble = new Marble(10, 100, 30, space);
        entities.push(marble);
    }
    public function stop() {
        if (marble != null)
            marble.remove();
        entities.remove(marble);
        marble = null;
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