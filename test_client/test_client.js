var exampleSocket = new WebSocket("ws://localhost:3000/cable?user_id=1");

var CHANNEL = "ImageChannel"
var ROOM = "Patate"

function send(cmd, channel, room, data) {
  var payload = {
    command: cmd,
    identifier: JSON.stringify({ channel: channel, room: room })
  }
  if (data) {
    payload["data"] = data
  }
  var string = JSON.stringify(payload)
  console.log('Sending payload: ' + string)
  exampleSocket.send(string)
}

function send_test() {
  var stroke = {
    points : '[(1,1), (2,2) ]',
    color : 'FFFFFF',
    width : 3,
    shape : 'Circle'
  }
  var content = {
    stroke: stroke,
    image_id: 1
  }
 
  var data = JSON.stringify({
    action: "draw",
    content: content
  })
  send("message", CHANNEL, ROOM, data)
}

exampleSocket.onmessage = function (event) {
  var data = JSON.parse(event.data)
  if (data.type != "ping") console.log(data)
  if (data.type == "confirm_subscription") {
      send_test()
  }
}
exampleSocket.onopen = function(event) {
  console.log('Connexion opened.')
  send("subscribe", CHANNEL, ROOM)
};
exampleSocket.onclose = function(event) {
    console.log('Connexion closed.')
}
