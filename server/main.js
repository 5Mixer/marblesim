var worlds = {}

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
        console.log(msg)

        var components = msg.split(',')
        var type = components[0]
        if (type == 1) {
            // 1, worldId, blockChange
            socket.world = components[1];

            var data = components.slice(2);
            setTile(socket.world, data);
            sockets.forEach(s => {
                if (s.world == socket.world && s != socket) {
                    s.send(msg)
                }
            });

        }
    });
    
    socket.on('close', function() {
        sockets = sockets.filter(s => s !== socket);
    });
});