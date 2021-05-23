package ;

class Model {
    public var activeTile:TileType;
    public var simulation:Simulation;

    public function new() {

    }
    
    public function setTile(tileType:TileType) {
        activeTile = tileType;
    }
    public function play() {
        simulation.start();
    }
    public function stop() {
        simulation.stop();
    }
}