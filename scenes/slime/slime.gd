extends KinematicBody2D

const FORGET_TIMER_INTERVAL = 8.0

var move_speed:float = 24

var _attack_distance = 8.0
var _target_node:Node2D = null
var _time_until_forget_target:float = 0.0
var _player_in_range:bool = false
var _velocity:Vector2 = Vector2()


func _physics_process(delta):
	
	
	# handle player targeting
	if !_player_in_range:
		_time_until_forget_target = max(0, _time_until_forget_target - delta)
		if _time_until_forget_target == 0:
			_forget_target()
	else:
		_time_until_forget_target = FORGET_TIMER_INTERVAL
	
	
	# follow and attack target
	_follow_and_attack_target(delta)



func _follow_and_attack_target(delta:float):
	
	if !is_instance_valid(_target_node):
		return
	
	var target_position = _target_node.global_position
	
	var distance_to_target = global_position.distance_to(target_position)
	
	if distance_to_target <= _attack_distance:
		_attack_target(delta)
		return
	
	var move_direction = global_position.direction_to(target_position)
	
	_velocity = move_direction * move_speed
	_velocity = move_and_slide(_velocity)



func _attack_target(delta:float):
	pass


func _forget_target():
	_target_node = null


func _on_AgroRange_body_entered(body):
	if body.is_in_group("player"):
		_target_node = body
		_player_in_range = true


func _on_AgroRange_body_exited(body):
	if body.is_in_group("player"):
		_player_in_range = false
