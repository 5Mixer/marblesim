package ;

import kha.math.Vector2i;
import kha.input.Mouse;

class Input {
    public var mousePosition:Vector2i = new Vector2i();
    public var onClick:(x:Int, y:Int)->Void;
    public var onMove:(x:Int, y:Int)->Void;
    public var mouseDown = false;
    public function new() {
		Mouse.get().notify(function(b,x,y){
            if (b == 0) {
                mouseDown = true;
                onClick(x, y);
            }
		},function(b, x, y) {
            if (b == 0) {
                mouseDown = false;
            }
        },function(x,y,dx,dy) {
            onMove(x,y);
		},null);

    }
}