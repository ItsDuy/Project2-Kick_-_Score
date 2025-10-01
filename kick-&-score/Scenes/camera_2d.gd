extends Camera2D

const PADDING := 0.05
@onready var tm: TileMap = $"../TileMap"

func _ready():
	make_current()
	_fit_to_tilemap()
	get_viewport().size_changed.connect(_fit_to_tilemap)

func _fit_to_tilemap() -> void:
	var r  : Rect2i  = tm.get_used_rect()
	var ts : Vector2 = Vector2(tm.tile_set.tile_size)

	var map_px   : Vector2 = Vector2(r.size) * ts
	var origin_px: Vector2 = Vector2(r.position) * ts

	var vp  : Vector2 = get_viewport_rect().size
	var pad : float   = 1.0 - PADDING
	var factor : float = min((vp.x * pad) / map_px.x, (vp.y * pad) / map_px.y)

	zoom = Vector2(factor, factor)

	var map_center: Vector2 = origin_px + map_px * 0.5
	global_position = map_center

	limit_left   = int((r.position.x) * ts.x)
	limit_top    = int((r.position.y) * ts.y)
	limit_right  = int((r.position.x + r.size.x) * ts.x)
	limit_bottom = int((r.position.y + r.size.y) * ts.y)
