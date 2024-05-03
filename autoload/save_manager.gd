extends Node

const SAVE_DIRECTORY:String = "user://saves"

var current_save:Dictionary = new_save()


func new_save() -> Dictionary:
	var return_save = {}
	
	# save details holds info which can be serialized without custom code
	# this info is typically used for sequencing levels to prevent sequence breaking
	# i.e bool, int, dictionary, string, etc.
	# they should be set using the SaveManager.set_detail(detail_name, detail_value) function
	# they should be read using the SaveManager.get_detail(detail_name, default_value) function
	return_save["save_details"] = {}
	
	# any other information should be handled in the save_game() and load_game() functions
	
	return return_save


func save_game():
	
	# make sure save directory exists
	var directory = Directory.new()
	if !directory.dir_exists(SAVE_DIRECTORY):
		directory.make_dir_recursive(SAVE_DIRECTORY)
	
	
	# create file
	var file = ConfigFile.new()
	
	
	
	# save current scene
	current_save["current_scene"] = SceneManager.get_current_scene().filename
	file.set_value("save_data", "current_scene", current_save["current_scene"])
	
	
	
	# save player info
	var player = SceneManager.get_player()
	
	if player != null:
		file.set_value("save_data", "player_selected_item", player.selected_item)
		file.set_value("save_data", "player_health", player._health_manager.get_health())
		file.set_value("save_data", "player_max_health", player._health_manager.get_max_health())
		file.set_value("save_data", "player_position", player.global_position)
		file.set_value("save_data", "player_facing_direction", player.get_facing_direction())
	else:
		file.set_value("save_data", "player_selected_item", ItemManager.Items.SWORD)
		file.set_value("save_data", "player_health", 9)
		file.set_value("save_data", "player_max_health", 9)
		file.set_value("save_data", "player_position", Vector2.ZERO)
		file.set_value("save_data", "player_facing_direction", Vector2.DOWN)
	
	
	# save unlocked items
	file.set_value("save_data", "unlocked_items", ItemManager.unlocked_items)
	
	
	
	# save saveDetails
	file.set_value("save_data", "save_details", var2str(current_save.save_details))
	
	
	
	# save file
	file.save(SAVE_DIRECTORY.plus_file("save.sav"))



func load_game():
	if !save_exists():
		printerr("could not load save!")
		return
	
	# make new empty save
	current_save = new_save()
	
	
	var file = ConfigFile.new()
	var load_status:int = file.load(SAVE_DIRECTORY.plus_file("save.sav"))
	
	if load_status != OK:
		printerr("could not load file!")
		return ERR_BUG
	
	
	
	# load save details
	var loaded_details = file.get_value("save_data", "save_details", {})
	
	if loaded_details is String:
		loaded_details = str2var(loaded_details)
		
		for key in loaded_details:
			current_save["save_details"][key] = loaded_details[key]
	
	
	
	# load unlocked items
	ItemManager.unlocked_items = file.get_value("save_data", "unlocked_items", [ItemManager.Items.SWORD])
	
	
	
	# load current scene
	var current_scene = file.get_value("save_data", "current_scene", null)
	if current_scene == null:
		printerr("Could not load current_scene from save_data!")
		get_tree().quit()
	
	SceneManager.change_scene(current_scene)
	
	yield(SceneManager, "scene_ready")
	
	
	
	
	# load player info
	var player = SceneManager.get_player()
	if player == null:
		printerr("Player is null and cannot load player info!")
		get_tree().quit()
	
	player._health_manager._max_health = file.get_value("save_data", "player_max_health", 9)
	player._health_manager._health = file.get_value("save_data", "player_health", 9)
	player.global_position = file.get_value("save_data", "player_position", Vector2.ZERO)
	player.face_direction(file.get_value("save_data", "player_facing_direction", Vector2.DOWN))
	player.selected_item = file.get_value("save_data", "player_selected_item", ItemManager.Items.SWORD)
	player._status_indicator_node.update_selected_item_icon(player.selected_item)
	
	
	
	# finished loading
	return OK



func set_detail(detail_name:String, detail_value):
	current_save["save_details"][detail_name] = detail_value



func get_detail(detail_name:String, default_value):
	if current_save["save_details"] == null or !current_save["save_details"].has(detail_name):
		return default_value
	
	return current_save["save_details"][detail_name]



func save_exists():
	var directory = Directory.new()
	return directory.file_exists(SAVE_DIRECTORY.plus_file("save.sav"))
