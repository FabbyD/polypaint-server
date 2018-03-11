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

function remove_stroke(id) {
    console.log('removing stroke ' + id)
    var data = JSON.stringify({
      action: "erase",
      content: {
        stroke: {
          id: id
        }
      }
    })
    send("message", CHANNEL, ROOM, data)
}

function modify_stroke(id) {
  var stroke = {
    id : id,
    points_x : [1,2],
    points_y : [1,2],
    color : '000000',
    width : 5,
    height : 5,
    shape : 'ellipse',
    stroke_type : 'circle'
  }
  var content = {
    canvas_id: 1,
    stroke: stroke
  }
 
  var data = JSON.stringify({
    action: "modify_stroke",
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

function remove_image(id) {
  var image = {
    id: id
  }
  var content = {
    image: image
  }
  var data = JSON.stringify({
    action: "remove_image",
    content: content
  })
  send("message", CHANNEL, ROOM, data)
}

function modify_image(id) {
  var image = {
    id: id,
    pos_x : 1,
    pos_y : 5
  }
  var content = {
    canvas_id: 1,
    image: image
  }
 
  var data = JSON.stringify({
    action: "modify_image",
    content: content
  })
  send("message", CHANNEL, ROOM, data)
}

function send_textbox() {
  var textbox = {
    content: "Une belle textbox",
    pos_x: 50,
    pos_y: 50
  }
  var content = {
    textbox: textbox,
    canvas_id: 1
  }
  var data = JSON.stringify({
    action: "add_textbox",
    content: content
  })
  send("message", CHANNEL, ROOM, data)
}

function modify_textbox(id) {
  var textbox = {
    id: id,
    content: "Une belle textbox modifiée",
    pos_x: 100,
    pos_y: 50
  }
  var content = {
    textbox: textbox,
    canvas_id: 1
  }
  var data = JSON.stringify({
    action: "modify_textbox",
    content: content
  })
  send("message", CHANNEL, ROOM, data)
}

function remove_textbox(id) {
  var textbox = {
    id: id,
    content: "Une belle textbox modifiée",
    pos_x: 100,
    pos_y: 50
  }
  var content = {
    textbox: textbox,
    canvas_id: 1
  }
  var data = JSON.stringify({
    action: "remove_textbox",
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
  if (data.type != "ping") {
      console.log(data)
  }
  if (data.type == "confirm_subscription") {
  	var input = document.querySelector('input[type=file]');
    input.style.display = 'block'
    send_textbox()
  } else if (data.type == null) {
    action = data.message.action 
    if (action == 'draw') {
      //remove_stroke(data.message.stroke.id)
    } else if (action == 'add_image') {
      modify_image(data.message.image.id)
    } else if (action == 'add_textbox') {
      setTimeout(function() {
        modify_textbox(data.message.textbox.id)
      }, 2000)
    } else if (action == 'modify_textbox') {
      setTimeout(function() {
        remove_textbox(data.message.textbox.id)
      }, 2000)
    } else {
      console.log('Unknown action')
    }
  }
}
exampleSocket.onopen = function(event) {
  console.log('Connexion opened.')
  send("subscribe", CHANNEL, ROOM)
};
exampleSocket.onclose = function(event) {
    console.log('Connexion closed.')
}
