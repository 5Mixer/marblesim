package ui;

import haxe.ui.events.MouseEvent;
import haxe.ui.components.Button;
import haxe.ui.containers.Box;

@:build(haxe.ui.macros.ComponentMacros.build("design/Main.xml"))
class Main extends Box {
	public var model:Model;

	public function new() {
		super();

		var playButton = new Button();
		// playButton.icon = kha.Assets.images.slope;
		playButton.text = "Play";
		playButton.onClick = function(event:MouseEvent) {
			model.play();
		}
		toolbuttons.addComponent(playButton);

		var stopButton = new Button();
		// stopButton.icon = kha.Assets.images.slope;
		stopButton.text = "Stop";
		stopButton.onClick = function(event:MouseEvent) {
			model.stop();
		}
		toolbuttons.addComponent(stopButton);

		var slopeButton = new Button();
		slopeButton.icon = kha.Assets.images.slope;
		slopeButton.onClick = function(event:MouseEvent) {
			model.setTile(TileType.Slope);
		}
		toolbuttons.addComponent(slopeButton);

		var tileButton = new Button();
		tileButton.padding = 5;
		tileButton.icon = kha.Assets.images.tile;
		tileButton.onClick = function(event:MouseEvent) {
			model.setTile(TileType.Tile);
		}
		toolbuttons.addComponent(tileButton);
	}
} 
