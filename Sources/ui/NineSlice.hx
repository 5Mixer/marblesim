package ui;

import kha.graphics2.Graphics;
import kha.Image;

class NineSlice {
    var radiusSize:Int;
    var sourceImageEdgeLength:Int;
    var image:Image;
    public function new(radiusSize:Int, image:Image) {
        if (image.width != image.height) {
            throw 'nine slice requires square image';
        }

        sourceImageEdgeLength = image.width - (radiusSize * 2);
        if (sourceImageEdgeLength < 0) {
            throw 'radius size too large for provided image';
        }

        this.radiusSize = radiusSize;
        this.image = image;
    }
    public function render(g:Graphics, x:Int, y:Int, width:Int, height:Int) {
        // Upper-left quadrant
        g.drawSubImage(image, x, y, 0, 0, radiusSize, radiusSize);

        // Upper-middle quadrant
        g.drawScaledSubImage(image, radiusSize, 0, sourceImageEdgeLength, radiusSize, x+radiusSize, y, width-2*radiusSize, radiusSize);

        // Upper-right quadrant
        g.drawSubImage(image, x + width - radiusSize, y, image.width - radiusSize, 0, radiusSize, radiusSize);


        // Middle-left quadrant
        g.drawScaledSubImage(image, 0, radiusSize, radiusSize, sourceImageEdgeLength, x, y+radiusSize, radiusSize, height-2*radiusSize);

        // Middle-middle quadrant
        g.drawScaledSubImage(image, radiusSize, radiusSize, sourceImageEdgeLength, sourceImageEdgeLength, x+radiusSize, y+radiusSize, width-2*radiusSize, height-2*radiusSize);

        // Middle-right quadrant
        g.drawScaledSubImage(image, radiusSize+sourceImageEdgeLength, radiusSize, radiusSize, sourceImageEdgeLength, x+width-radiusSize, y+radiusSize, radiusSize, height-2*radiusSize);


        // Bottom-left quadrant
        g.drawSubImage(image, x, y + height - radiusSize, 0, image.height-radiusSize, radiusSize, radiusSize);

        // Bottom-middle quadrant
        g.drawScaledSubImage(image, radiusSize, radiusSize+sourceImageEdgeLength, sourceImageEdgeLength, radiusSize, x+radiusSize, y+height-radiusSize, width-2*radiusSize, radiusSize);

        // Bottom-right quadrant
        g.drawSubImage(image, x + width - radiusSize, y + height - radiusSize, image.width - radiusSize, image.height-radiusSize, radiusSize, radiusSize);
    }
}