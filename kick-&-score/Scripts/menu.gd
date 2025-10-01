extends Node2D

@onready var start_btn = $Control/VBoxContainer/Start
@onready var option_btn = $Control/VBoxContainer/Options
@onready var quit_btn = $Control/VBoxContainer/Quit

func _ready() -> void:
	start_btn.pressed.connect(start_btn_pressed)
	quit_btn.pressed.connect(quit_btn_pressed)
	
func start_btn_pressed() -> void:
	print("Button clicked")
	get_tree().change_scene_to_file("res://Scenes/tilemap.tscn")
	
func quit_btn_pressed() -> void:
	print("Quit")
	get_tree().quit()
