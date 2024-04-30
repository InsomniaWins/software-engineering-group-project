extends Node

var _scene_manager:Control = null


func get_scene_manager() -> Control:
	return _scene_manager

func set_scene_manager(node:Control):
	_scene_manager = node
