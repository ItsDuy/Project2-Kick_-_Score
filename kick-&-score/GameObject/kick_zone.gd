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
		print("Has the ball")

func _on_ball_exit(body):
	if body.name == "ball":
		is_in_contact_with_ball=false
		ball_body=null

func _process(delta):
	if is_in_contact_with_ball:
		if Input.is_action_pressed("ui_accept"):
			print("Accumulate")
			kick_force += charge_rate*delta
			kick_force = min(max_kick_force,kick_force)
		
		if Input.is_action_just_released("ui_accept"):
			print("Kick the ball")
			kick_ball()
			kick_force=0
			
func kick_ball():
	if ball_body:
		var dir=(ball_body.global_position -global_position).normalized()
		ball_body.apply_impulse(Vector2.ZERO, dir * kick_force)
