package ;

class Model {
    public var activeTile:TileType = Square;
    public var activeColour:Int = 0;
    public var simulation:Simulation;

    public function new() {

    }
    
    public function setTile(tileType:TileType) {
        activeTile = tileType;
    }
    public function setColour(colourIndex:Int) {
        activeColour = colourIndex;
    }
    public function play() {
        simulation.start();
    }
    public function stop() {
        simulation.stop();
    }
}