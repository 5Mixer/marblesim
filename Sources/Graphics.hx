package ;

using kha.graphics2.GraphicsExtension;

class Graphics {
    var g:kha.graphics2.Graphics;
    public function new() {

    }
    public function setG2(g:kha.graphics2.Graphics) {
        this.g = g;
    }
    public function drawCircle(x:Float,y:Float,r) {
        // g.fillCircle(x, y ,r);
        g.drawScaledImage(kha.Assets.images.marble,x-r, y-r,2*r,2*r);
    }
    public function drawImage(x:Float,y:Float,width,height,image) {
        g.drawScaledImage(image,x, y, width, height);
    }
}