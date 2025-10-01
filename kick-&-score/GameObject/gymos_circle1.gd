# GymosCircle.gd - Attach this to a Node2D that's a child of your character
extends Node2D

@export var radius = 10
@export var segments = 32
@export var color:Color = Color(0.0, 0.1, 0.4, 0.7)
@export var line_width = 3.0
@export var rotation_speed = 1.0
var current_rotation = 0.0

func _process(delta):
	# Rotate the circle
	current_rotation += delta * rotation_speed
	queue_redraw()

func _draw():
	var points = PackedVector2Array()
	var angle_delta = 2 * PI / segments
	
	for i in range(segments + 1):
		var angle = i * angle_delta + current_rotation
		var point = Vector2(cos(angle), sin(angle)) * radius
		points.append(point)
	
	# Draw the circle
	for i in range(segments):
		draw_line(points[i], points[i+1], color, line_width)
