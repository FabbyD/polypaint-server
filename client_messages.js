var exampleSocket = new WebSocket("ws://localhost:3000/cable?user_id=2");
exampleSocket.onmessage = function (event) {
  var data = JSON.parse(event.data)
  if (data.type != "ping") console.log(data)
}
exampleSocket.send(JSON.stringify({ command: "subscribe", identifier: "{ \"channel\": \"ChatroomChannel\" }"}));
exampleSocket.send(JSON.stringify({ command: "message",   identifier: "{ \"channel\": \"ChatroomChannel\" }", "data": "{ \"action\": \"message\", \"content\": \"salut\"}" }));
