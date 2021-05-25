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
    var renderSize:Vector2i = new Vector2i(20, 20);

    public function new(sourceImage, sourcePos, sourceSize, ?rotation=0.) {
        this.sourceImage = sourceImage;
        this.sourcePos = sourcePos;
        this.sourceSize = sourceSize;
        this.rotation = rotation;
    }
    public function render(g:Graphics,x:Int,y:Int) {
        g.pushTransformation(FastMatrix3.translation(x + renderSize.x/2, y + renderSize.y/2).multmat(FastMatrix3.rotation(rotation)).multmat(FastMatrix3.translation(-x - renderSize.x/2, -y - renderSize.y/2)));
        g.drawScaledSubImage(sourceImage, sourcePos.x, sourcePos.y, sourceSize.x, sourceSize.y, x, y, renderSize.x, renderSize.y);
        g.popTransformation();
    }
    public function rotated(angle:Float) {
        return new Sprite(sourceImage, sourcePos, sourceSize, angle);
    }
}