//var exampleSocket = new WebSocket("wss://polypaint-pro-staging.herokuapp.com/cable?user_id=1");
var exampleSocket = new WebSocket("ws://localhost:3000/cable?user_id=1");

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
  var string = JSON.stringify(payload)
  console.log('Sending payload: ' + string)
  exampleSocket.send(string)
}

function send_test() {
  var stroke = {
    points_x : [1,2],
    points_y : [1,2],
    color : 'FFFFFF',
    width : 3,
    height : 3,
    shape : 'ellipse'
  }
  var content = {
    stroke: stroke,
    canvas_id: 1
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
