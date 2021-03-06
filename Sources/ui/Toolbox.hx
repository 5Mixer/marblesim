package ui;

import kha.math.Vector2i;
import kha.graphics2.Graphics;

class Toolbox {
    var selectedButton:Button;
    var selectedColourButton:Button;
    var position:Vector2i;
    var size:Vector2i;
    public var model:Model;

    var selectionIndex = 0;

    var slice:NineSlice;
    var buttons:Array<Button>;
    var colourButtons:Array<Button>;

    public function new() {
        position = new Vector2i(0, 0);
        size = new Vector2i(800, 120);
        
        slice = new NineSlice(20, kha.Assets.images.nineSlice);

        var emptySprite  = new Sprite(kha.Assets.images.tiles, new Vector2i(0,0),   new Vector2i(50, 50));
        var squareSprite = new Sprite(kha.Assets.images.tiles, new Vector2i(50,0),  new Vector2i(50, 50));
        var slopeSprite  = new Sprite(kha.Assets.images.tiles, new Vector2i(100,0), new Vector2i(50, 50));
        var innerSlopeSprite  = new Sprite(kha.Assets.images.tiles, new Vector2i(150,0), new Vector2i(50, 50));
        var outerSlopeSprite  = new Sprite(kha.Assets.images.tiles, new Vector2i(200,0), new Vector2i(50, 50));
        var springSprite = new Sprite(kha.Assets.images.spring, new Vector2i(0,0),  new Vector2i(20, 20));
        var marbleSprite = new Sprite(kha.Assets.images.marble_start, new Vector2i(0,0),  new Vector2i(20, 20));
        var acceleratorSprite = new Sprite(kha.Assets.images.accelerator, new Vector2i(0,0),  new Vector2i(20, 20));

        buttons = [
            new Button("Eraser", emptySprite,  tileButtonCallback(TileType.Empty)),
            new Button("Marble", marbleSprite, tileButtonCallback(Marble)),
            new Button("Square", squareSprite, tileButtonCallback(TileType.Square)),

            new Button("Slope", slopeSprite.rotated(Math.PI*0/2), tileButtonCallback(Slope(UpRight))),
            new Button("Slope", slopeSprite.rotated(Math.PI*3/2), tileButtonCallback(Slope(UpLeft))),
            new Button("Slope", slopeSprite.rotated(Math.PI*1/2), tileButtonCallback(Slope(DownRight))),
            new Button("Slope", slopeSprite.rotated(Math.PI*2/2), tileButtonCallback(Slope(DownLeft))),

            new Button("Inner Slope", innerSlopeSprite.rotated(Math.PI*0/2), tileButtonCallback(InnerSlope(UpRight))),
            new Button("Inner Slope", innerSlopeSprite.rotated(Math.PI*3/2), tileButtonCallback(InnerSlope(UpLeft))),
            new Button("Inner Slope", innerSlopeSprite.rotated(Math.PI*1/2), tileButtonCallback(InnerSlope(DownRight))),
            new Button("Inner Slope", innerSlopeSprite.rotated(Math.PI*2/2), tileButtonCallback(InnerSlope(DownLeft))),

            new Button("Outer Slope", outerSlopeSprite.rotated(Math.PI*0/2), tileButtonCallback(OuterSlope(UpRight))),
            new Button("Outer Slope", outerSlopeSprite.rotated(Math.PI*3/2), tileButtonCallback(OuterSlope(UpLeft))),
            new Button("Outer Slope", outerSlopeSprite.rotated(Math.PI*1/2), tileButtonCallback(OuterSlope(DownRight))),
            new Button("Outer Slope", outerSlopeSprite.rotated(Math.PI*2/2), tileButtonCallback(OuterSlope(DownLeft))),

            new Button("Spring", springSprite.rotated(Math.PI*0/2), tileButtonCallback(Spring(Right))),
            new Button("Spring", springSprite.rotated(Math.PI*2/2), tileButtonCallback(Spring(Left))),
            new Button("Spring", springSprite.rotated(Math.PI*3/2), tileButtonCallback(Spring(Up))),
            new Button("Spring", springSprite.rotated(Math.PI*1/2), tileButtonCallback(Spring(Down))),

            new Button("Accelerator", acceleratorSprite.rotated(Math.PI*0/2), tileButtonCallback(Accelerator(Right))),
            new Button("Accelerator", acceleratorSprite.rotated(Math.PI*2/2), tileButtonCallback(Accelerator(Left))),
            new Button("Accelerator", acceleratorSprite.rotated(Math.PI*3/2), tileButtonCallback(Accelerator(Up))),
            new Button("Accelerator", acceleratorSprite.rotated(Math.PI*1/2), tileButtonCallback(Accelerator(Down)))
        ];
        
        colourButtons = [];
        var index = 0;
        for (colour in Colours.palette) {
            colourButtons.push(new Button("Colour "+(index+1), squareSprite.coloured(colour), colourButtonCallback(index)));
            index++;
        }
        selectedButton = buttons[2];
        selectedColourButton = colourButtons[0];
    }
    function tileButtonCallback(tileType:TileType) {
        return function() {
            model.setTile(tileType);
        }
    }
    function colourButtonCallback(colour:Int) {
        return function() {
            model.setColour(colour);
        }
    }
    public function pointInside(x:Int,y:Int) {
        return x > position.x && y > position.y && x < position.x + size.x && y < position.y + size.y;
    }
    public function onClick(x,y) {
        if (pointInside(x, y)) {
            for (component in buttons) {
                if (component is Button) {
                    if (x > component.x && y > component.y && x < component.x + component.width && y < component.y + component.height) {
                        component.onClick();
                        selectedButton = component;
                    }
                }
            }
            for (component in colourButtons) {
                if (component is Button) {
                    if (x > component.x && y > component.y && x < component.x + component.width && y < component.y + component.height) {
                        component.onClick();
                        selectedColourButton = component;
                    }
                }
            }
        }
    }
    public function render(g:Graphics) {
        slice.render(g,position.x, position.y, size.x, size.y);

        var x = 0;
        for (component in buttons) {
            if (component is Button) {
                component.x = 10+(x++)*30;
                component.y = 10;

                if (component == selectedButton) {
                    g.color = kha.Color.fromValue(0x22000000);
                    g.fillRect(component.x, component.y, 20, 20);
                    g.color = kha.Color.White;
                }

                if (component != buttons[0]) { // Don't change the eraser colour from white.
                    component.sprite.colour = Colours.palette[model.activeColour];
                }
                component.render(g, component.x, component.y);
            }
        }
        if (selectedButton != null) {
            g.font = kha.Assets.fonts.OpenSans_Regular;
            g.fontSize = 22;
            g.color = kha.Color.fromValue(0xffeeeeee);
            g.drawString(selectedButton.label, selectedButton.x, selectedButton.y + 25);
            g.color = kha.Color.White;
        }

        var x = 0;
        for (component in colourButtons) {
            if (component is Button) {
                component.x = 10+(x++)*30;
                component.y = 70;

                if (component == selectedColourButton) {
                    g.color = kha.Color.Black;
                    g.drawRect(component.x, component.y, 20, 20);
                    g.color = kha.Color.White;
                }

                component.render(g, component.x, component.y);
            }
        }
    }
}