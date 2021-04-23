package;

import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	var simulation:Simulation;
	var graphics:Graphics;
	function new() {

		graphics = new Graphics();

		System.start({title: "Marble Run", width: 800, height: 600}, function (_) {
			Assets.loadEverything(function () {
				init();
				Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
				System.notifyOnFrames(function (framebuffers) { render(framebuffers[0]); });
			});
		});
	}
	function init() {
		simulation = new Simulation();

	}
	function update() {
		simulation.update();
	}

	function render(framebuffer: Framebuffer) {
		var g = framebuffer.g2;
		g.begin();
		graphics.setG2(g);
		simulation.render(graphics);

		g.end();
	}

	public static function main() {
		new Main();
	}
}
