package ;

import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.space.Space;
import kha.graphics2.Graphics;

class Simulation {
    var space:Space;
    var entities:Array<Entity> = [];
    var marbleStarts:Array<tile.MarbleStart> = [];

    public var marbleType:CbType;
    public var springType:CbType;
 
    var collisions:InteractionListener;
    public function new() {
        var gravity = Vec2.weak(0, 600);
        space = new Space(gravity);

        marbleType = new CbType();
        springType = new CbType();

        collisions = new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, marbleType, springType, function(callback) {
            var springForce = 500;
            if (callback.int2.castShape.userData.direction == SpringDirection.Up) {
                callback.int1.castBody.velocity.y = -springForce;
            }else if (callback.int2.castShape.userData.direction == SpringDirection.Down) {
                callback.int1.castBody.velocity.y = springForce;
            }else if (callback.int2.castShape.userData.direction == SpringDirection.Right) {
                callback.int1.castBody.velocity.x = springForce;
            }else if (callback.int2.castShape.userData.direction == SpringDirection.Left) {
                callback.int1.castBody.velocity.x = -springForce;
            }
        }, 0);
        space.listeners.add(collisions);
    }
 
    public function placeTile(x,y,tile:TileType) {
        for (entity in entities) {
            if (entity.x == x && entity.y == y) {
                entity.remove();
                if (entity is tile.MarbleStart)
                    marbleStarts.remove(cast entity);
                entities.remove(entity);
            }
        }
        switch tile {
            case Marble: {
                var marbleStart = new tile.MarbleStart(x,y);
                marbleStarts.push(marbleStart);
                entities.push(marbleStart);
            }
            case Empty: {};
            case Square: {
                var square = new tile.Square(x,y,space);
                entities.push(square);
            }
            case Spring(rotation): entities.push(new tile.Spring(x,y,space,rotation,springType));
            case Slope(rotation): entities.push(new tile.Slope(x,y,space,rotation));
            case InnerSlope(rotation): entities.push(new tile.InnerSlope(x,y,space,rotation));
        }

    }
    public function start() {
        stop();
        for (marble in marbleStarts) {
            var marble = new Marble(marble.x*20+10, marble.y*20+10, space);
            marble.body.cbTypes.add(marbleType);

            entities.push(marble);
        }
    }
    public function stop() {
        for (entity in entities)
            if (entity is Marble)
                entity.remove();
        entities = entities.filter((e) -> !(e is Marble));

        for (marble in marbleStarts) {
            entities.push(marble);
        }
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