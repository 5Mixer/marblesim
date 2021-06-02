package;

import js.html.Storage;
import js.html.InputElement;
import js.html.TextAreaElement;
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

	var cursorID = "";
	var name = "";
	var lastMouseSend = 0.;

	var connected = false;

	var cursors:Map<String,Cursor> = [];

	function new() {
		System.start({title: "Marble Run", width: 800, height: 600}, function (_) {
			cursorID = getID();

			#if js
			var canvas = cast(js.Browser.document.getElementById('khanvas'), js.html.CanvasElement);
			canvas.width = Math.floor(js.Browser.window.innerWidth - 30);
			canvas.height = Math.floor(js.Browser.window.innerHeight - 80);
			canvas.addEventListener('contextmenu', function(event){ event.preventDefault();}); 

			if (js.Browser.getLocalStorage() != null) {
				if (Browser.getLocalStorage().getItem('id') != null) {
					cursorID = Browser.getLocalStorage().getItem('id');
				}else{
					Browser.getLocalStorage().setItem('id', cursorID);
				}
			}

			#end

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
			if (ws != null && kha.Scheduler.time() - lastMouseSend > .1) {
				var worldPos = camera.screenToWorld(input.mousePosition);
				ws.send("2,"+world+","+cursorID+","+worldPos.x+","+worldPos.y+","+name);
				lastMouseSend = kha.Scheduler.time();
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

		reconnect();
	}
	function getID() {
		var symbols = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		var id = "";
		for (i in 0...6) {
			id += symbols.charAt(Math.floor(Math.random()*symbols.length));
		}
		return id;
	}
	function reconnect() {
		trace("Reconnecting!");

		var server = "localhost";
		var secure = false;
		#if js
			world = Browser.location.hash.split(",")[0];
			server = Browser.location.hostname;
			if (Browser.location.protocol == 'https:') {
				secure = true;
			}
		#end

		ws = new WebSocket((secure ? "wss" : "ws") + "://"+server+":"+(secure ? 443 : 80)+"/ws/");
        ws.onopen = function() {
            ws.send("0,"+world);
			connected = true;
        };
		ws.onmessage = function(message) {
			connected = true;

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
					if (components[0] == "2") {
						if (!cursors.exists(components[1])) {
							cursors.set(components[1], new Cursor());
						}
						cursors.get(components[1]).wx = Std.parseInt(components[2]);
						cursors.get(components[1]).wy = Std.parseInt(components[3]);
						if (components.length == 5) {
							cursors.get(components[1]).name = (components[4]);
						}
					}
				};
			};
		};
		ws.onclose = function() {
			trace("Lost connection!");
			connected = false;
			reconnect();
		}
		simulation.sendMessage = function(data) {
			ws.send("1,"+world+","+data);
		}
		Scheduler.addTimeTask(function(){
			if (connected) {
				ws.send('ping');
			}
		},0,1);
	}

	function update() {
		#if js
		if (world != Browser.location.hash.split(",")[0]) {
			trace("Hash changed");
			cursors = [];
			simulation.clear();
			world = Browser.location.hash.split(",")[0];
			ws.send("0,"+world);
		}
		name = cast(Browser.document.getElementById("username"),InputElement).value;
		trace(name);
		if (name == null)
			name="";
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
		for (cursor in cursors.iterator()) {
			cursor.render(g);
		}
		camera.endTransform(g);
		toolbox.render(g);

		if (!connected) {
			g.font = kha.Assets.fonts.OpenSans_Regular;
			g.fontSize = 70;
			g.color = kha.Color.Red;
			g.drawString("Not connected", 100, 100);
			g.color = kha.Color.White;
		}

		g.end();
	}

	public static function main() {
		new Main();
	}
}
