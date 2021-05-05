package;

import kha.input.Mouse;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	var simulation:Simulation;
	var ui:ui.Main;

	function new() {

		System.start({title: "Marble Run", width: 800, height: 600}, function (_) {
			Assets.loadEverything(function () {
				init();
				Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
				System.notifyOnFrames(function (framebuffers) { render(framebuffers[0]); });
			});
		});
	}
	function init() {
		haxe.ui.Toolkit.init();

		ui = new ui.Main();
		haxe.ui.core.Screen.instance.addComponent(ui);

		simulation = new Simulation();
		Mouse.get().notify(function(b,x,y){
			// simulation.start();
		},null,null);

	}
	function update() {
		simulation.update();
	}

	function render(framebuffer: Framebuffer) {

		var g = framebuffer.g2;
		g.begin(true,kha.Color.fromValue(0xead2a1));
		simulation.render(g);
		haxe.ui.core.Screen.instance.renderTo(g);
		g.end();
	}

	public static function main() {
		new Main();
	}
}
