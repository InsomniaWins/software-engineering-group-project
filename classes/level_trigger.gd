extends Area2D
class_name LevelTrigger

export(String, FILE, "*.tscn") var scene_path:String = ""
export(Vector2) var player_position = Vector2()
export(Vector2) var player_facing_direction = Vector2.DOWN

func _ready():
	var _connect_result
	_connect_result = self.connect("body_entered", self, "_on_body_entered")
	_connect_result = self.connect("body_exited", self, "_on_body_exited")


func _on_body_exited(_body):
	pass


func _on_body_entered(body):
	
	if scene_path.empty():
		return
	
	if body.is_in_group("player"):
		SceneManager.change_scene(scene_path, player_position, player_facing_direction)


