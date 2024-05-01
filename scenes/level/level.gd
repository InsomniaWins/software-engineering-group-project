extends Control
class_name Level

export(NodePath) var _active_camera_path

var _camera_bounds_node:Control
var _camera_bounds:Rect2 = Rect2(Vector2(), ViewportManager.BASE_RESOLUTION)
var active_camera:Camera2D = null

func _ready():
	
	if _active_camera_path != null:
		active_camera = get_node(_active_camera_path)
	
	update_camera_bounds()


func _process(delta):
	update_camera_bounds()


func update_camera_bounds():
	if !is_instance_valid(_camera_bounds_node):
		if !has_node("CameraBounds"):
			return
		_camera_bounds_node = get_node("CameraBounds")
	
	_camera_bounds.position = _camera_bounds_node.rect_global_position
	_camera_bounds.size = _camera_bounds_node.rect_size
	
	if !is_instance_valid(active_camera):
		return
	
	active_camera.limit_left = _camera_bounds.position.x
	active_camera.limit_top = _camera_bounds.position.y
	
	active_camera.limit_right = _camera_bounds.position.x + _camera_bounds.size.x
	active_camera.limit_bottom = _camera_bounds.position.y + _camera_bounds.size.y
