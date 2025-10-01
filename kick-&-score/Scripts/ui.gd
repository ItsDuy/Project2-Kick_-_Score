extends Node2D

@onready var spr := $Sprite2D
@onready var anim := $AnimationPlayer

func _ready() -> void:
	fit_sprite()
	get_viewport().size_changed.connect(fit_sprite)
	
	anim.play("fade_in")
	await get_tree().create_timer(6.0).timeout
	anim.play("fado_out") 
	await get_tree().create_timer(3.0).timeout

	get_tree().change_scene_to_file("res://UI/menu.tscn")


func fit_sprite() -> void:
	if spr.texture == null:
		return

	var vp_size  = get_viewport_rect().size
	var tex_size = spr.texture.get_size()

	var scale_fill = Vector2(vp_size.x / tex_size.x, vp_size.y / tex_size.y)
	var k_fill = max(scale_fill.x, scale_fill.y)
	spr.scale = Vector2(k_fill, k_fill)

	spr.centered = true
	spr.position = vp_size * 0.5


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://UI/menu.tscn")
