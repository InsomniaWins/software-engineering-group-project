extends Control

var _current_scene:Node = null

onready var _current_scene_node:Control = $CurrentScene
onready var _freed_scenes_node:Control = $FreedScenes



func _ready():
	SceneManager.set_scene_manager(self)
	
	if _current_scene_node.get_child_count() > 0:
		_current_scene = _current_scene_node.get_child(0)


func get_current_scene() -> Node:
	return _current_scene


func change_scene(new_scene:String, player_position=null, player_facing_direction=null):
	var previous_scene = _current_scene
	
	var previous_player_node = null
	
	if previous_scene != null:
		
		previous_player_node = SceneManager.get_player()
		
		_current_scene_node.call_deferred("remove_child", previous_scene)
		previous_scene.queue_free()
	
	call_deferred("finish_scene_change", new_scene, previous_player_node, player_position, player_facing_direction)

func finish_scene_change(new_scene:String, previous_player_node, player_position, player_facing_direction):
	var next_scene:Node = load(new_scene).instance()
	
	_current_scene_node.add_child(next_scene)
	_current_scene = next_scene
	
	var player_node = next_scene.find_node("Player")
	if player_node != null and previous_player_node != null:
		var previous_max_health = previous_player_node._health_manager.get_max_health()
		var previous_health = previous_player_node._health_manager.get_health()
		
		player_node._health_manager.set_max_health(previous_max_health)
		player_node._health_manager.set_health(previous_health)
		
		if player_position != null:
			player_node.global_position = player_position
		
		if player_facing_direction != null:
			player_node.face_direction(player_facing_direction)
	
	
