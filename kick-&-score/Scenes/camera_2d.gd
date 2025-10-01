# Camera2D.gd  (gắn vào node Camera2D)
extends Camera2D

@export var tilemap_path: NodePath
@export var padding: float = 24.0 

@onready var tm: TileMap = get_node(tilemap_path)

func _ready() -> void:
	make_current()
	await get_tree().process_frame
	_fit_to_tilemap()
	get_viewport().size_changed.connect(_fit_to_tilemap) 

func _fit_to_tilemap() -> void:
	if tm == null:
		return

	var used: Rect2i = tm.get_used_rect()     
	if used.size == Vector2i.ZERO:
		return

	var tl_local: Vector2 = tm.map_to_local(used.position)
	var br_local: Vector2 = tm.map_to_local(used.position + used.size)
	var size_local: Vector2 = (br_local - tl_local).abs()

	var center_global: Vector2 = tm.to_global(tl_local + size_local * 0.5)
	global_position = center_global

	var vp: Vector2 = get_viewport_rect().size
	if vp.x <= 0.0 or vp.y <= 0.0:
		return

	var target_w = max(1.0, vp.x - padding * 2.0)
	var target_h = max(1.0, vp.y - padding * 2.0)
	var zoom_factor = max(size_local.x / target_w, size_local.y / target_h)
	zoom = Vector2(zoom_factor, zoom_factor)

	var tl_global: Vector2 = tm.to_global(tl_local)
	var br_global: Vector2 = tm.to_global(br_local)
	limit_left   = int(min(tl_global.x, br_global.x))
	limit_top    = int(min(tl_global.y, br_global.y))
	limit_right  = int(max(tl_global.x, br_global.x))
	limit_bottom = int(max(tl_global.y, br_global.y))
