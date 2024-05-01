extends KinematicBody2D

var move_speed:float = 64
var velocity:Vector2 = Vector2()

var _facing_direction:Vector2 = Vector2.DOWN
var _knockback_velocity:Vector2 = Vector2()
var _knockback_resistance:float = 0.1
var _movement_input:Vector2 = Vector2()
var _on_stairs:bool = false
var _moving:bool = false


onready var _health_manager = $HealthManager
onready var _hud:CanvasLayer = $Hud
onready var _health_indicator_node:Control = _hud.get_node("HealthIndicator")
onready var _previous_position:Vector2 = position
onready var _character_sprite_node:AnimatedSprite = $AnimatedSprite


func _process(delta):
	_handle_sprite_animations(delta)
	
	# handle health indicator
	_health_indicator_node.update_hearts(
		_health_manager.get_health(),
		_health_manager.get_max_health()
	)


func _physics_process(delta):
	_process_movement_input(delta)
	_process_movement(delta)
	
	# process knockback
	_knockback_velocity = _knockback_velocity.linear_interpolate(Vector2.ZERO, _knockback_resistance)
	if _knockback_velocity.length() < 16:
		_knockback_velocity = Vector2.ZERO
	_knockback_velocity = move_and_slide(_knockback_velocity)


func _handle_sprite_animations(_delta:float):
	
	match _facing_direction:
		Vector2.UP:
			_character_sprite_node.animation = "walk_up"
		Vector2.DOWN:
			_character_sprite_node.animation = "walk_down"
		Vector2.LEFT:
			_character_sprite_node.animation = "walk_left"
		Vector2.RIGHT:
			_character_sprite_node.animation = "walk_right"
	
	if is_moving():
		_character_sprite_node.playing = true
	else:
		_character_sprite_node.playing = false
		_character_sprite_node.frame = 0


func is_moving():
	return _moving


func _process_movement_input(_delta:float):
	_movement_input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	_movement_input.x = Input.get_action_strength("right") - Input.get_action_strength("left")


func face_direction(new_direction:Vector2):
	
	if abs(new_direction.x) > abs(new_direction.y):
		if new_direction.x > 0:
			_facing_direction = Vector2.RIGHT
		else:
			_facing_direction = Vector2.LEFT
	else:
		if new_direction.y > 0:
			_facing_direction = Vector2.DOWN
		else:
			_facing_direction = Vector2.UP


func get_facing_direction() -> Vector2:
	return _facing_direction


func _process_movement(_delta:float):
	
	_previous_position = position
	velocity = _movement_input.normalized() * move_speed
	
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x < 0:
			_facing_direction = Vector2.LEFT
		elif velocity.x > 0:
			_facing_direction = Vector2.RIGHT
	else:
		if velocity.y < 0:
			_facing_direction = Vector2.UP
		elif velocity.y > 0:
			_facing_direction = Vector2.DOWN
	
	if _on_stairs and velocity.x != 0:
		velocity.x *= 0.5
		velocity.y += sign(velocity.x) * move_speed * 0.5
	
	velocity = move_and_slide(velocity)
	
	_moving = velocity.length() > 0.025
	
	_movement_input = Vector2()

func is_on_stairs():
	return _on_stairs

func take_damage(damage_amount:int, knockback:Vector2 = Vector2.ZERO):
	_health_manager.take_damage(damage_amount)
	_knockback_velocity = knockback




