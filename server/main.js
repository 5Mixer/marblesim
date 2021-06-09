var fs = require('fs');

var worlds = {};
var savefile = 'save.json';
var lockfile = 'lock.json'

var lockedRooms = [''];

var cursorsEnabled = false;

if (fs.existsSync(savefile)) {
    worlds = JSON.parse(fs.readFileSync(savefile));
    lockedRooms = JSON.parse(fs.readFileSync(lockfile))
}

function setTile(world, data) {
    var tile = data[0]
    var x = data[1]
    var y = data[2]
    if (worlds[world] != null) {
        let i = 0;
        for (let entry of worlds[world]) {
            if (entry[1] == x && entry[2] == y) {
                worlds[world].splice(i, 1);
                break;
            }
            i++;
        }
        worlds[world].push(data);
    }else{
        worlds[world] = [data];
    }
}

const WebSocket = require('ws');
const server = new WebSocket.Server({
    port: 4050
});

let sockets = [];
server.on('connection', function(socket) {
    sockets.push(socket);
    socket.world = '1'
    
    socket.on('message', function(msg) {
        // messageType,messageData
        var components = msg.split(',')
        var type = components[0]
        if (type == '0') { // 'hello
            socket.world = components[1];
            if (socket.cursor == "gdtTzN") {
                return
            }
            if (worlds[socket.world] != null && socket.world != "" && socket.world != null) {
                var worldMessage = "0,\n1\n"; // 'world' message, v1.
                for (let tile of worlds[socket.world])
                    worldMessage += tile.join(",")+"\n"
                socket.send(worldMessage);

                if (lockedRooms.indexOf(socket.world) != -1) {
                    socket.send('locked');
                }
            }
        }
        if (type == '1') {
            // 1, worldId, blockChange
            socket.world = components[1];

            var data = components.slice(2);

            if (socket.world == '' || socket.world == null || socket.world == "#demo") {
                return;
            }

            setTile(socket.world, data);
            sockets.forEach(s => {
                if (s.world == socket.world && s != socket) {
                    s.send(msg)
                }
            });
        }
        if (type == '2') {
            // 2, worldId, cursor, wx, wy, name
            var data = components.slice(2);
            socket.world = components[1];

            if (socket.cursor != null && socket.name != null && socket.name != components[5]) {
                console.log("id '" + socket.cursor+ "' changed name from '"+socket.name+"' to '"+components[5]+"'")
            }
            socket.cursor = components[2];
            socket.name = components[5];

            if (cursorsEnabled == false)
                return;

            sockets.forEach(s => {
                if (s.world == socket.world && s != socket) {
                    s.send("2,"+data.join(","))
                }
            });
        }
    });
    
    socket.on('close', function() {
        sockets = sockets.filter(s => s !== socket);
    });
});

function saveSync() {
    fs.writeFileSync(savefile, JSON.stringify(worlds));

    console.log("Saved.");
}
var index = 0;
setInterval(function() {
    index++;
    fs.writeFile("autosave" + (index % 6) +".json", JSON.stringify(worlds), (err) => {
        if (err)
            console.log(err);
    });
    fs.writeFile("save.json", JSON.stringify(worlds), (err) => {
        if (err)
            console.log(err);
    });
}, 40000);

function exitHandler(options, exitCode) {
    saveSync();
    if (options.cleanup) console.log('clean');
    if (exitCode || exitCode === 0) console.log(exitCode);
    if (options.exit) process.exit();
}

//do something when app is closing
process.on('exit', exitHandler.bind(null,{cleanup:true}));

//catches ctrl+c event
process.on('SIGINT', exitHandler.bind(null, {exit:true}));

// catches "kill pid"
process.on('SIGUSR1', exitHandler.bind(null, {exit:true}));
process.on('SIGUSR2', exitHandler.bind(null, {exit:true}));

//catches uncaught exceptions
process.on('uncaughtException', exitHandler.bind(null, {exit:true}));