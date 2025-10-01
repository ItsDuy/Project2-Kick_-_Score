extends Node2D

func _ready() -> void:
	var cam = $Camera2D
	var tile_map = $TileMap
	fit(cam, tile_map)
	
func fit(cam: Camera2D, tile_map: TileMap):
	var screen: Vector2i = Vector2(get_window().content_scale_size)
	var used = tile_map.get_used_rect()
	print("Screen: " + str(screen))
	print("Tile map size: " + str(used))
	
	if used.size == Vector2i.ZERO:
		return
		
	var cell_px = tile_map.tile_set.tile_size
	var map_px := Vector2(used.size.x * cell_px.x, used.size.y * cell_px.y)
	# camera.zoom: >1 = thu nhỏ (nhìn thấy nhiều hơn), <1 = phóng to
	var zx := map_px.x / screen.x
	var zy := map_px.y / screen.y
	var z = max(zx, zy)             # để nhìn trọn map
	cam.zoom = Vector2(z, z)

	# đưa camera về tâm của vùng map
	var top_left := tile_map.to_global(tile_map.map_to_local(used.position))
	var bottom_right := tile_map.to_global(tile_map.map_to_local(used.position + used.size))
	var center := (top_left + bottom_right) * 0.5
	cam.global_position = center 
	
