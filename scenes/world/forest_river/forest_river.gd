extends Level

func _ready():
	var defeated_left_boss = SaveManager.get_detail("defeated_left_boss", false)
	var defeated_right_boss = SaveManager.get_detail("defeated_right_boss", false)
	
	if defeated_left_boss and defeated_right_boss:
		_open_passage_to_final_boss()


func _open_passage_to_final_boss():
	
	var tile_map:TileMap = $TileMap
	tile_map.set_cell(17, 2, 0)
	tile_map.set_cell(18, 2, 0)
	
