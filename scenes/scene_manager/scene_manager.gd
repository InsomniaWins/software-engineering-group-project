extends Control

var _current_scene:Node = null

onready var _current_scene_node:Control = $CurrentScene
onready var _freed_scenes_node:Control = $FreedScenes

func _ready():
	_current_scene = _current_scene_node.get_child(0)


func get_current_scene() -> Node:
	return _current_scene


func change_scene(new_scene:String):
	var next_scene = load(new_scene).instance()
	var previous_scene = _current_scene
	
	if previous_scene != null:
		_current_scene_node.remove_child(previous_scene)
		_freed_scenes_node.add_child(previous_scene)
		previous_scene.queue_free()
	
	_current_scene_node.add_child(_current_scene)
	_current_scene = next_scene
