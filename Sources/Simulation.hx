package ;

import kha.math.Vector2i;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.space.Space;
import kha.graphics2.Graphics;

class Tile {
    public var x:Int;
    public var y:Int;
    public var tile:TileType;
    public function new (x, y, tile) {
        this.x = x;
        this.y = y;
        this.tile = tile;
    }
}

class Simulation {
    var space:Space;
    var entities:Array<Entity> = [];
    var marbleStarts:Array<tile.MarbleStart> = [];

    public var marbleType:CbType;
    public var springType:CbType;
    public var acceleratorType:CbType;

    public var sendMessage:(data:String)->Void;

    var tilemap:Array<Tile> = [];
 
    public function new() {
        var gravity = Vec2.weak(0, 600);
        space = new Space(gravity);

        marbleType = new CbType();
        springType = new CbType();
        acceleratorType = new CbType();

        kha.System.notifyOnCutCopyPaste(function() {
            return serialise();
        }, function() {
            return serialise();
        }, function(data) {
            load(data);
        });

        var collisions = new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, marbleType, springType, function(callback) {
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

        var collisions = new InteractionListener(CbEvent.ONGOING, InteractionType.ANY, marbleType, acceleratorType, function(callback) {
            var acceleratorForce = 20;
            if (callback.int2.castShape.userData.direction == SpringDirection.Up) {
                callback.int1.castBody.velocity.y += -acceleratorForce;
            }else if (callback.int2.castShape.userData.direction == SpringDirection.Down) {
                callback.int1.castBody.velocity.y += acceleratorForce;
            }else if (callback.int2.castShape.userData.direction == SpringDirection.Right) {
                callback.int1.castBody.velocity.x += acceleratorForce;
            }else if (callback.int2.castShape.userData.direction == SpringDirection.Left) {
                callback.int1.castBody.velocity.x += -acceleratorForce;
            }
        }, 0);
        space.listeners.add(collisions);

    }

    function serialiseTile(tile:Tile) {
        var id = switch tile.tile {
            case Empty: 0;
            case Marble: 1;
            case Square: 2;
            case Slope(rotation): switch rotation {
                case UpRight: 3;
                case DownRight: 4;
                case DownLeft: 5;
                case UpLeft: 6;
            };
            case InnerSlope(rotation): switch rotation {
                case UpRight: 7;
                case DownRight: 8;
                case DownLeft: 9;
                case UpLeft: 10;
            };
            case OuterSlope(rotation): switch rotation {
                case UpRight: 11;
                case DownRight: 12;
                case DownLeft: 13;
                case UpLeft: 14;
            };
            case Spring(rotation): switch rotation {
                case Right: 15;
                case Down: 16;
                case Left: 17;
                case Up: 18;
            };
            case Accelerator(rotation): switch rotation {
                case Right: 19;
                case Down: 20;
                case Left: 21;
                case Up: 21;
            };
        };
        return id + ',' + tile.x + ',' +tile.y + '\n';
    }
    public function loadTileData(components:Array<String>) {
        var x = Std.parseInt(components[1]);
        var y = Std.parseInt(components[2]);
        var tile:TileType = switch Std.parseInt(components[0]) {
            case 0: Empty;
            case 1: Marble;
            case 2: Square;
            case 3: Slope(UpRight);
            case 4: Slope(DownRight);
            case 5: Slope(DownLeft);
            case 6: Slope(UpLeft);
            case 7: InnerSlope(UpRight);
            case 8: InnerSlope(DownRight);
            case 9: InnerSlope(DownLeft);
            case 10: InnerSlope(UpLeft);
            case 11: OuterSlope(UpRight);
            case 12: OuterSlope(DownRight);
            case 13: OuterSlope(DownLeft);
            case 14: OuterSlope(UpLeft);
            case 15: Spring(Right);
            case 16: Spring(Down);
            case 17: Spring(Left);
            case 19: Spring(Right);
            case 20: Accelerator(Right);
            case 21: Accelerator(Down);
            case 22: Accelerator(Left);
            case 23: Accelerator(Right);
            default: Empty;
        };
        placeTile(x, y, tile, false);
    }

    public function serialise() {
        var string = "1\n";
        for (tile in tilemap) {
            string += serialiseTile(tile);
        }
        return string;
    }
    public function load(string:String) {
        var lines = string.split("\n");
        var version = lines[0];
        if (version == "1") {
            for (line in lines) {
                loadTileData(line.split(","));
            }
        }
    }
 
    public function placeTile(x,y,tile:TileType,?send=true) {
        if (send) {
            sendMessage("1,1,"+serialiseTile(new Tile(x, y, tile)));
        }

        // O(n), fixup DS.
        var replace = false;
        for (tile in tilemap) {
            if (tile.x == x && tile.y == y) {
                tilemap.remove(tile);
                break;
            }
        }

        if (tile != TileType.Empty) {
            tilemap.push(new Tile(x, y, tile));
        }

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
            case Accelerator(rotation): entities.push(new tile.Accelerator(x,y,space,rotation,acceleratorType));
            case Slope(rotation): entities.push(new tile.Slope(x,y,space,rotation));
            case InnerSlope(rotation): entities.push(new tile.InnerSlope(x,y,space,rotation));
            case OuterSlope(rotation): entities.push(new tile.OuterSlope(x,y,space,rotation));
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