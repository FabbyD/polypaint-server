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

function send_stroke() {
  var stroke = {
    points_x : [1,2],
    points_y : [1,2],
    color : 'FFFFFF',
    width : 3,
    height : 3,
    shape : 'ellipse',
    stroke_type : 'circle'
  }
  var content = {
    canvas_id: 1,
    stroke: stroke
  }
 
  var data = JSON.stringify({
    action: "draw",
    content: content
  })
  send("message", CHANNEL, ROOM, data)
}

function send_image(blob) {
  var image = {
    pos_x : 1,
    pos_y : 1,
    data: blob
  }
  var content = {
    canvas_id: 1,
    image: image
  }
 
  var data = JSON.stringify({
    action: "add_image",
    content: content
  })
  send("message", CHANNEL, ROOM, data)
}

function previewFile() {
  var preview = document.querySelector('img');
  var file    = document.querySelector('input[type=file]').files[0];
  var reader  = new FileReader();

  reader.addEventListener("load", function () {
    preview.src = reader.result;
	send_image(reader.result)
  }, false);

  if (file) {
    reader.readAsDataURL(file);
  }
}

exampleSocket.onmessage = function (event) {
  var data = JSON.parse(event.data)
  if (data.type != "ping") console.log(data)
  if (data.type == "confirm_subscription") {
  	var input = document.querySelector('input[type=file]');
    input.style.display = 'block'
    send_stroke()
  }
}
exampleSocket.onopen = function(event) {
  console.log('Connexion opened.')
  send("subscribe", CHANNEL, ROOM)
};
exampleSocket.onclose = function(event) {
    console.log('Connexion closed.')
}
