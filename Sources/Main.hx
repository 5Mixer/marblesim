package;

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
		input.onClick = function(x,y){
			if (toolbox.pointInside(x,y)) {
				toolbox.onClick(x,y);
			}else{
				if (model.activeTile != null) {
					simulation.placeTile(Math.floor(x/20),Math.floor(y/20),model.activeTile);
				}
			}
		}
		input.onMove = function(x,y) {
			if (input.mouseDown) {
				if (!toolbox.pointInside(x,y)) {
					if (model.activeTile != null) {
						simulation.placeTile(Math.floor(x/20),Math.floor(y/20),model.activeTile);
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
	}

	function render(framebuffer: Framebuffer) {
		var g = framebuffer.g2;
		g.mipmapScaleQuality = Low;
		g.imageScaleQuality = Low;
		g.begin(true,kha.Color.fromValue(0xead2a1));
		simulation.render(g);
		toolbox.render(g);
		g.end();
	}

	public static function main() {
		new Main();
	}
}
