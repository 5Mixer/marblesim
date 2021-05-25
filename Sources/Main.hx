package;

import kha.input.KeyCode;
import kha.input.Keyboard;
import ui.Toolbox;
import kha.input.Mouse;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	var model:Model;
	var simulation:Simulation;
	var toolbox:Toolbox;
	var input:Input;
	var camera:Camera;

	function new() {
		System.start({title: "Marble Run", width: 800, height: 600}, function (_) {
			Assets.loadEverything(function () {
				for (name in Assets.images.names) {
					Assets.images.get(name).generateMipmaps(1);
				}
				init();
				Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
				System.notifyOnFrames(function (framebuffers) { render(framebuffers[0]); });
			});
		});
	}
	function init() {
		model = new Model();
		input = new Input();
		camera = new Camera();
		input.onClick = function(x,y){
			if (toolbox.pointInside(x,y)) {
				toolbox.onClick(x,y);
			}
		}
		input.onMove = function(x,y) {
			if (input.mouseDown) {
				if (!toolbox.pointInside(x,y)) {
					if (model.activeTile != null) {
						var worldPos = camera.screenToWorld(input.mousePosition);
						simulation.placeTile(Math.floor(worldPos.x/20),Math.floor(worldPos.y/20),model.activeTile);
					}
				}
			}
		}

		toolbox = new Toolbox();
		toolbox.model = model;

		simulation = new Simulation();
		model.simulation = simulation;

		Keyboard.get().notify(function(key){
			if (key == Space) {
				simulation.start();
			}
		},null);

	}
	function update() {
		simulation.update();
		if (input.downKeys.contains(KeyCode.Left) || input.downKeys.contains(KeyCode.A)) {
			camera.moveLeft();
		}
		if (input.downKeys.contains(KeyCode.Right) || input.downKeys.contains(KeyCode.D)) {
			camera.moveRight();
		}
		if (input.downKeys.contains(KeyCode.Up) || input.downKeys.contains(KeyCode.W)) {
			camera.moveUp();
		}
		if (input.downKeys.contains(KeyCode.Down) || input.downKeys.contains(KeyCode.S)) {
			camera.moveDown();
		}
	}

	function render(framebuffer: Framebuffer) {
		var g = framebuffer.g2;
		g.mipmapScaleQuality = Low;
		g.imageScaleQuality = Low;
		g.begin(true,kha.Color.fromValue(0xead2a1));
		camera.transform(g);
		simulation.render(g);
		camera.endTransform(g);
		toolbox.render(g);
		g.end();
	}

	public static function main() {
		new Main();
	}
}
