package ;

import kha.input.Keyboard;
import kha.math.Vector2;
import kha.input.Mouse;

class Input {
    public var mousePosition:Vector2 = new Vector2();
    public var onClick:(x:Int, y:Int)->Void;
    public var onMove:(x:Int, y:Int)->Void;
    public var mouseDown = false;
    public var downKeys = [];
    public function new() {
		Mouse.get().notify(function(b,x,y){
            mousePosition.x = x;
            mousePosition.y = y;
            if (b == 0) {
                mouseDown = true;
                onClick(x, y);
            }
            onMove(x,y);
		},function(b, x, y) {
            mousePosition.x = x;
            mousePosition.y = y;
            if (b == 0) {
                mouseDown = false;
            }
        },function(x,y,dx,dy) {
            mousePosition.x = x;
            mousePosition.y = y;
            onMove(x,y);
		},null, function() {
            downKeys = [];
        });

        Keyboard.get().notify(function (key){
            downKeys.push(key);
        }, function (key) {
            downKeys.remove(key);
        });
    }
}