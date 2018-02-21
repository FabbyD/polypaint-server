var exampleSocket = new WebSocket("ws://localhost:3000/cable?user_id=3");

function send_test() {
    console.log('Sending test.')
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
  exampleSocket.send(JSON.stringify({
    command: "subscribe",
    identifier: JSON.stringify({ channel: "CanvasChannel", room: "patate" })
  }))
};
exampleSocket.onclose = function(event) {
    console.log('Connexion closed.')
}
