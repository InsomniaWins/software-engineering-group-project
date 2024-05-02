extends Control

signal scene_ready

var _current_scene:Node = null

onready var _level_music_player_node:AudioStreamPlayer = $LevelMusic
onready var _current_scene_node:Control = $CurrentScene
onready var _freed_scenes_node:Control = $FreedScenes



func _ready():
	SceneManager.set_scene_manager(self)
	
	if _current_scene_node.get_child_count() > 0:
		_current_scene = _current_scene_node.get_child(0)


func get_current_scene() -> Node:
	return _current_scene


func change_scene(new_scene_path:String, player_position = null, player_facing_direction = null):
	
	# make sure scene change happens on an "idle" frame
	call_deferred("change_scene_deferred", new_scene_path, player_position, player_facing_direction)


func _copy_information_between_levels(previous_level, next_level):
	
	# copy player info over and set player position/direction
	var previous_player_node = previous_level.find_node("Player")
	var player_node = next_level.find_node("Player")
	if player_node != null and previous_player_node != null:
		var previous_max_health = previous_player_node._health_manager.get_max_health()
		var previous_health = previous_player_node._health_manager.get_health()
		
		player_node._health_manager.set_max_health(previous_max_health)
		player_node._health_manager.set_health(previous_health)
	
	
	# handle level music playing/pausing/stopping
	if !next_level.level_music.empty():
		var current_music = _level_music_player_node.stream
		var next_music = load(next_level.level_music)
		
		if current_music != next_music:
			_level_music_player_node.stream = next_music
			_level_music_player_node.play()
	


func change_scene_deferred(new_scene_path:String, player_position = null, player_facing_direction = null):
	
	# remove previous scene
	var previous_scene = _current_scene
	if previous_scene != null:
		_current_scene_node.remove_child(previous_scene)
		_freed_scenes_node.add_child(previous_scene)
		previous_scene.queue_free()
	
	
	
	# add current scene
	var next_scene:Node = load(new_scene_path).instance()
	_current_scene_node.add_child(next_scene)
	_current_scene = next_scene
	
	
	
	# handle information that should communicate between levels
	if next_scene is Level:
		_copy_information_between_levels(previous_scene, _current_scene)
	else:
		# stop level music as scene is not a level
		_level_music_player_node.stop()
		_level_music_player_node.stream = null
	
	
	
	# set player position and facing direction
	var player_node = SceneManager.get_player()
	if player_position != null:
		player_node.global_position = player_position
	
	if player_facing_direction != null:
		player_node.face_direction(player_facing_direction)
	
	
	
	# finished changing scene
	emit_signal("scene_ready")
