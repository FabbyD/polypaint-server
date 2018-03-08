user = User.new(name: 't', password: 't')
user.save
p user

chatroom = Chatroom.new(name: '1st Room')
chatroom.save
p chatroom

canvas = Canvas.new(name: '1st Canvas', description: 'Premier canevas.')
canvas.user = user
canvas.save
p canvas
