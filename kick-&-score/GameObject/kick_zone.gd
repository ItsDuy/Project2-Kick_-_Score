extends Area2D

# Signal emitted when the player catches the ball
signal ball_caught

var is_in_contact_with_ball =false
var kick_force =0
var max_kick_force=10000
var charge_rate=7500
var ball_body=null

func _ready():
	# Connect the "body_entered" signal of the Area2D to a function
	connect("body_entered",Callable( self, "_on_ball_entered"))
	connect("body_exited",Callable( self, "_on_ball_exit"))

# Function called when a body enters the Area2D
func _on_ball_entered(body):
	if body.name == "ball":
		is_in_contact_with_ball=true
		ball_body=body

func _on_ball_exit(body):
	if body.name == "ball":
		is_in_contact_with_ball=false
		ball_body=null
