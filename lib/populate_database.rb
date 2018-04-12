user = User.new(name: 't', password: 't')
user.save
p user

canvas = Canvas.new(name: '1st Canvas', description: 'Premier canevas.')
canvas.user = user
canvas.save
p canvas

layer = Layer.new()
layer.canvas = canvas
layer.index = 0
layer.uuid = "layer:1stlayer"
layer.save
p layer

chatroom = Chatroom.new(name: '1st Room')
chatroom.canvas = canvas
chatroom.save
p chatroom

waiting_room = Chatroom.new(name: 'Waiting Room')
waiting_room.save
p waiting_room

pixel_canvas = PixelCanvas.new(name: '1st PixelCanvas')
pixel_canvas.user = user
pixel_canvas.save
p pixel_canvas
