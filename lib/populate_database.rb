user = User.new(name: 't', password: 't')
user.save
p user

canvas = Canvas.new(name: '1st Canvas', description: 'Premier canevas.')
canvas.user = user
canvas.save
p canvas

chatroom = Chatroom.new(name: '1st Room')
chatroom.canvas = canvas
chatroom.save
p chatroom

layer = Layer.new()
layer.canvas = canvas
layer.index = 0
layer.uuid = "layer:1stlayer"
layer.save
p layer

pixel_canvas = PixelCanvas.new(name: '1st PixelCanvas')
pixel_canvas.user = user
pixel_canvas.save
p pixel_canvas
