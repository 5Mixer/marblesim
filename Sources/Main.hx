package;

import js.Browser;
import hx.ws.WebSocket;
import hx.ws.Types;
import kha.input.KeyCode;
import kha.input.Keyboard;
import ui.Toolbox;
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

	var world = "0";
	var ws:WebSocket;

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

		#if js world = Browser.location.hash.split(",")[0]; #end

		ws = new WebSocket("ws://localhost:4050");
        ws.onopen = function() {
            ws.send("0,"+world);
        };
		ws.onmessage = function(message) {
			switch (message) {
                case BytesMessage(content): {};
                case StrMessage(content): {
					trace("Received " + content);
					var components = content.split(",");
					if (components[0] == "0") {
						simulation.load(content.split("\n").slice(1).join("\n"));
					}
					if (components[0] == "1") {
						var lines = content.split("\n");
						simulation.loadTileData(components.slice(2));
					}
				};
			};
		};
		simulation.sendMessage = function(data) {
			ws.send("1,"+world+","+data);
		}

	}
	function update() {
		#if js
		if (world != Browser.location.hash.split(",")[0]) {
			trace("Hash changed");
			simulation.clear();
			world = Browser.location.hash.split(",")[0];
			ws.send("0,"+world);
		}
		#end
		
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
		var xOffset = camera.position.x % 20;
		var yOffset = camera.position.y % 20;
		for (x in 0...Math.ceil(kha.Window.get(0).width/20)) {
			g.fillRect(x*20+xOffset, 0, 1, kha.Window.get(0).height);
		}
		for (y in 0...Math.ceil(kha.Window.get(0).height/20)) {
			g.fillRect(0, y*20+yOffset, kha.Window.get(0).width, 1);
		}

		camera.transform(g);
		simulation.render(g);
		if (!toolbox.pointInside(Math.floor(input.mousePosition.x),Math.floor(input.mousePosition.y))) {
			g.color = kha.Color.fromValue(0x22000000);
			var worldPos = camera.screenToWorld(input.mousePosition);
			g.fillRect(Math.floor(worldPos.x/20)*20, Math.floor(worldPos.y/20)*20, 20, 20);
			g.color = kha.Color.White;
		}
		camera.endTransform(g);
		toolbox.render(g);
		g.end();
	}

	public static function main() {
		new Main();
	}
}
