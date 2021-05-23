package ui;

import kha.math.Vector2i;
import kha.graphics2.Graphics;

class Toolbox {
    var toolButtons:Array<Button> = [];
    var position:Vector2i;
    var size:Vector2i;
    public var model:Model;

    var slice:NineSlice;

    public function new() {
        position = new Vector2i(0, 0);
        size = new Vector2i(450, 60);
        
        slice = new NineSlice(20, kha.Assets.images.nineSlice);

        var emptySprite = new Sprite(kha.Assets.images.empty, new Vector2i(0,0), new Vector2i(20, 20), 3 * Math.PI / 2);
        var slopeButton3 = new Button(10, 10, emptySprite, function() {
            model.setTile(TileType.Empty);
        });
        toolButtons.push(slopeButton3);

        var tileSprite = new Sprite(kha.Assets.images.tile, new Vector2i(0,0), new Vector2i(20, 20));
        var tileButton = new Button(10+30*1, 10, tileSprite, function() {
            model.setTile(TileType.Square);
        });
        toolButtons.push(tileButton);

        var slopeSprite = new Sprite(kha.Assets.images.slope, new Vector2i(0,0), new Vector2i(20, 20));
        var slopeButton = new Button(10+30*2, 10, slopeSprite, function() {
            model.setTile(TileType.Slope(UpRight));
        });
        toolButtons.push(slopeButton);

        var slopeSprite1 = new Sprite(kha.Assets.images.slope, new Vector2i(0,0), new Vector2i(20, 20), Math.PI / 2);
        var slopeButton1 = new Button(10+30*3, 10, slopeSprite1, function() {
            model.setTile(TileType.Slope(DownRight));
        });
        toolButtons.push(slopeButton1);

        var slopeSprite2 = new Sprite(kha.Assets.images.slope, new Vector2i(0,0), new Vector2i(20, 20), 2 * Math.PI / 2);
        var slopeButton2 = new Button(10+30*4, 10, slopeSprite2, function() {
            model.setTile(TileType.Slope(DownLeft));
        });
        toolButtons.push(slopeButton2);

        var slopeSprite3 = new Sprite(kha.Assets.images.slope, new Vector2i(0,0), new Vector2i(20, 20), 3 * Math.PI / 2);
        var slopeButton3 = new Button(10+30*5, 10, slopeSprite3, function() {
            model.setTile(TileType.Slope(UpLeft));
        });
        toolButtons.push(slopeButton3);


        var springSprite = new Sprite(kha.Assets.images.tile, new Vector2i(0,0), new Vector2i(20, 20));
        var springButton = new Button(10+30*6, 10, springSprite, function() {
            model.setTile(TileType.Spring(Right));
        });
        toolButtons.push(springButton);
        var springSprite2 = new Sprite(kha.Assets.images.tile, new Vector2i(0,0), new Vector2i(20, 20), Math.PI/2);
        var springButton2 = new Button(10+30*7, 10, springSprite2, function() {
            model.setTile(TileType.Spring(Down));
        });
        toolButtons.push(springButton2);
        var springSprite3 = new Sprite(kha.Assets.images.tile, new Vector2i(0,0), new Vector2i(20, 20), 2*Math.PI/2);
        var springButton3 = new Button(10+30*8, 10, springSprite3, function() {
            model.setTile(TileType.Spring(Left));
        });
        toolButtons.push(springButton3);
        var springSprite4 = new Sprite(kha.Assets.images.tile, new Vector2i(0,0), new Vector2i(20, 20), 3*Math.PI/2);
        var springButton4 = new Button(10+30*9, 10, springSprite4, function() {
            model.setTile(TileType.Spring(Up));
        });
        toolButtons.push(springButton4);
    }
    public function pointInside(x:Int,y:Int) {
        return x > position.x && y > position.y && x < position.x + size.x && y < position.y + size.y;
    }
    public function onClick(x,y) {
        if (pointInside(x, y)) {
            for (toolButton in toolButtons) {
                if (x > toolButton.x && y > toolButton.y && x < toolButton.x + toolButton.width && y < toolButton.y + toolButton.height) {
                    toolButton.onClick();
                }
            }
        }
    }
    public function render(g:Graphics) {
        slice.render(g,position.x, position.y, size.x, size.y);

        for (toolButton in toolButtons) {
            toolButton.render(g);
        }
    }
}