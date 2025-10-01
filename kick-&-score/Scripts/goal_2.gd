extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_Goal_body_entered"))

func _on_Goal_body_entered(body):
	if body.is_in_group("ball"):
		print("The ball is in goal2!")
