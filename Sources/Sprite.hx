package ;

import kha.math.FastMatrix3;
import kha.Image;
import kha.math.Vector2i;
import kha.graphics2.Graphics;

class Sprite {
    var sourceImage:Image;
    var sourcePos:Vector2i;
    var sourceSize:Vector2i;
    var rotation:Float;

    public function new(sourceImage, sourcePos, sourceSize, ?rotation=0.) {
        this.sourceImage = sourceImage;
        this.sourcePos = sourcePos;
        this.sourceSize = sourceSize;
        this.rotation = rotation;
    }
    public function render(g:Graphics,x:Int,y:Int) {
        g.pushTransformation(FastMatrix3.translation(x + sourceSize.x/2, y + sourceSize.y/2).multmat(FastMatrix3.rotation(rotation)).multmat(FastMatrix3.translation(-x - sourceSize.x/2, -y - sourceSize.y/2)));
        g.drawSubImage(sourceImage, x, y, sourcePos.x, sourcePos.y, sourceSize.x, sourceSize.y);
        g.popTransformation();
    }
}