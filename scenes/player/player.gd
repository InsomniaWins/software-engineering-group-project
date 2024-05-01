extends KinematicBody2D


var _movement_input:Vector2 = Vector2()

var move_speed:float = 64
var velocity:Vector2 = Vector2()
var _on_stairs:bool = false
var _moving:bool = false


onready var _previous_position:Vector2 = position
onready var _character_sprite_node:AnimatedSprite = $AnimatedSprite

func _process(delta):
	_handle_sprite_animations(delta)


func _physics_process(delta):
	_process_movement_input(delta)
	_process_movement(delta)


func _handle_sprite_animations(delta):
	if is_moving():
		_character_sprite_node.playing = true
	else:
		_character_sprite_node.playing = false
		_character_sprite_node.frame = 0
	


func is_moving():
	return _moving


func _process_movement_input(delta:float):
	_movement_input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	_movement_input.x = Input.get_action_strength("right") - Input.get_action_strength("left")


func _process_movement(delta:float):
	
	_previous_position = position
	velocity = _movement_input.normalized() * move_speed
	
	_moving = velocity.length() > 0
	
	if _on_stairs and velocity.x != 0:
		velocity.x *= 0.5
		velocity.y += sign(velocity.x) * move_speed * 0.5
	
	move_and_slide(velocity)
	_movement_input = Vector2()

func is_on_stairs():
	return _on_stairs