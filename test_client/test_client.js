var exampleSocket = new WebSocket("ws://10.200.22.191:3000/cable?user_id=3");

var CHANNEL = "CanvasChannel"
var ROOM = "Patate"

function send(cmd, channel, room, data) {
  var payload = {
    command: cmd,
    identifier: JSON.stringify({ channel: channel, room: room })
  }
  if (data) {
    payload["data"] = data
  }
  exampleSocket.send(JSON.stringify(payload))
}

function send_test() {
  console.log('Sending test.')
  var data = JSON.stringify({
    action: "draw",
    content: "beau content"
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
