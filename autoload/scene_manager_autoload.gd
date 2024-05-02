extends Node

var _scene_manager:Control = null

func get_scene_manager() -> Control:
	return _scene_manager

func set_scene_manager(node:Control):
	_scene_manager = node

func change_scene(scene_path:String, player_position=null, player_facing_direction=null):
	_scene_manager.change_scene(scene_path, player_position, player_facing_direction)

func get_current_scene():
	return _scene_manager.get_current_scene()

func get_player():
	
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() == 0:
		return null
	
	return player_nodes[0]
