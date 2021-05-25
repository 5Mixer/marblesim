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

        var emptySprite  = new Sprite(kha.Assets.images.tiles, new Vector2i(0,0),   new Vector2i(50, 50));
        var squareSprite = new Sprite(kha.Assets.images.tiles, new Vector2i(50,0),  new Vector2i(50, 50));
        var slopeSprite  = new Sprite(kha.Assets.images.tiles, new Vector2i(100,0), new Vector2i(50, 50));
        var springSprite = new Sprite(kha.Assets.images.spring, new Vector2i(0,0),  new Vector2i(20, 20));
        var marbleSprite = new Sprite(kha.Assets.images.marble_start, new Vector2i(0,0),  new Vector2i(20, 20));

        toolButtons.push(new Button(10+30*0, 10, emptySprite,  tileButtonCallback(TileType.Empty)));
        toolButtons.push(new Button(10+30*1, 10, squareSprite, tileButtonCallback(TileType.Square)));

        toolButtons.push(new Button(10+30*2, 10, slopeSprite.rotated(Math.PI*0/2), tileButtonCallback(Slope(UpRight))));
        toolButtons.push(new Button(10+30*3, 10, slopeSprite.rotated(Math.PI*1/2), tileButtonCallback(Slope(DownRight))));
        toolButtons.push(new Button(10+30*4, 10, slopeSprite.rotated(Math.PI*2/2), tileButtonCallback(Slope(DownLeft))));
        toolButtons.push(new Button(10+30*5, 10, slopeSprite.rotated(Math.PI*3/2), tileButtonCallback(Slope(UpLeft))));

        toolButtons.push(new Button(10+30*6, 10, springSprite.rotated(Math.PI*0/2), tileButtonCallback(Spring(Right))));
        toolButtons.push(new Button(10+30*7, 10, springSprite.rotated(Math.PI*1/2), tileButtonCallback(Spring(Down))));
        toolButtons.push(new Button(10+30*8, 10, springSprite.rotated(Math.PI*2/2), tileButtonCallback(Spring(Left))));
        toolButtons.push(new Button(10+30*9, 10, springSprite.rotated(Math.PI*3/2), tileButtonCallback(Spring(Up))));
        toolButtons.push(new Button(10+30*10, 10, marbleSprite, tileButtonCallback(Marble)));
    }
    function tileButtonCallback(tileType:TileType) {
        return function() {
            model.setTile(tileType);
        }
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