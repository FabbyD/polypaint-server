# polypaint-server
Server for PolyPaint Pro (LOG3900-12)

## Installation

See [here][1].

## HTTP API Routes

**signup**
```
POST http://localhost:3000/users
{
  "user": {
    "name": "username",
    "password": "password"
  }
}
```

Response
```
{
  "user": {
    "id": "<USER_ID>"
  }
}
```

**login**
```
POST http://localhost:3000/login
{
  "session": {
    "name": "username",
    "password": "password"
  }
}
```

Response
```
{
  "user": {
    "id": "<USER_ID>"
  }
}
```

**logout**
```
DELETE http://localhost:3000/logout
```

## WebSocket messages
Before sending messages to the server, a WebSocket connection must be established.
```
http://localhost:3000/cable?user_id=<USER_ID>
```

Where USER_ID is replaced with the user's id returned by the server when successfully logged in. Obviously not really safe, but well.. it's academic.

Example of connection done in JavaScript.
```js
var exampleSocket = new WebSocket("ws://localhost:3000/cable?user_id=1");
exampleSocket.onmessage = function (event) {
  var data = JSON.parse(event.data)
  console.log(data)
}
```

If the connection was succesful you should receive a confirmation from server that looks like this:
```js
Object { type: "welcome" }
```

Note that if you wait too long before registering your onmessage listener (or whatever similar concept in C# or other languages), you might not receive the response. It's not a big deal. An error should occur if the connexion fails (first line) so you'll know if things go south.

Next step is to subscribe to a Chatroom:
```js
exampleSocket.send(JSON.stringify(
  {
    command: "subscribe",
    identifier: "{ \"channel\": \"ChatroomChannel\", \"room\": \"1st Room\" }"
  }
));
```

And the server should answer with:
```js
Object { identifier: "{ \"channel\": \"ChatroomChannel\" }", type: "confirm_subscription" }
```

From now on, you should be able to send messages like so:
```js
exampleSocket.send(JSON.stringify(
  {
    command: "message",
    identifier: "{ \"channel\": \"ChatroomChannel\" }",
    "data": "{ \"action\": \"message\", \"content\": \"<THE MESSAGE YOU WANT TO SEND>\"}"
  }
));
```

### Message Structure
This structure is what Rails ActionCable (the WebSocket library) expects.

```
command: "message"
```
The command key is used to tell Rails what to do. `"message"` tells it that the client is trying to send data to the server. It has nothing to do with the name of the channel whatsoever. Possible values for this field are:

- `"subcribe"`
- `"message"`
- And maybe others I am not aware of.

```
identifier: "{ \"channel\": \"ChatroomChannel\", \"room\": \"1st Room\" }"
```
The value besides the `identifier` key is a **string** (even though it is built like a json) used in Rails to keep track of all broadcasting channels. It is very important to use the exact same key as the one used when subscribing earlier. Even  one space missing will cause Rails to fail to find the channel you are trying to send data on.

```
"data": "{ \"action\": \"message\", \"content\": \"<THE MESSAGE YOU WANT TO SEND>\"}"
```
The last entry in the json message is `data`. It also is a **string** built as a json. This json includes an `action` key that corresponds to a method in the Channel's implementation (see [chatroom_channel.rb][2]) and a `content` key and this is where you will put the data you want to send.

The best way to build the last two fields to make sure they are compliant with the ActionCable protocol is to redundantly jsonify them like so:
```
JSON.stringify({
  command: "message",
  identifier: JSON.stringify({ channel: "ChatroomChannel" }),
  "data": JSON.stringify({ action: "message", content: "<THE MESSAGE YOU WANT TO SEND>"})
})
```

This avoids the the need for multiple backslashes.

[1]: docs/installation.md
[2]: app/channels/chatroom_channel.rb#L10
