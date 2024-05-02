extends KinematicBody2D

const HealthPickup = preload("res://scenes/health_pickup/health_pickup.tscn")

const FORGET_TIMER_INTERVAL:float = 8.0
const ATTACK_TIMER_INTERVAL:float = 0.5

var move_speed:float = 24


var _attack_cooldown_time:float = ATTACK_TIMER_INTERVAL
var _attack_distance = 8.0
var _target_node:Node2D = null
var _time_until_forget_target:float = 0.0
var _player_in_range:bool = false
var _velocity:Vector2 = Vector2.ZERO
var _knockback_velocity:Vector2 = Vector2.ZERO
var _knockback_resistance:float = 0.1
var _attack_damage_amount:int = 1
var _vision_range:float = 48.0

onready var _player_vision_ray_cast:RayCast2D = $PlayerVisionRayCast
onready var _health_manager_node:Node = $HealthManager
onready var _attack_area_node:Area2D = $AttackArea
onready var _sprite_node:AnimatedSprite = $Sprite
onready var _damage_sound_player_node:AudioStreamPlayer = $DamageSound

func _physics_process(delta):
	
	
	_check_player_in_range()
	
	
	# handle player targeting
	if !_player_in_range:
		_time_until_forget_target = max(0, _time_until_forget_target - delta)
		if _time_until_forget_target == 0:
			_forget_target()
	else:
		_time_until_forget_target = FORGET_TIMER_INTERVAL
	
	
	# follow and attack target
	_follow_and_attack_target(delta)
	
	# apply knockback
	_knockback_velocity = _knockback_velocity.linear_interpolate(Vector2.ZERO, _knockback_resistance)
	if _knockback_velocity.length() < 16:
		_knockback_velocity = Vector2.ZERO
	_knockback_velocity = move_and_slide(_knockback_velocity)


func _check_player_in_range():
	_player_in_range
	var player = SceneManager.get_player()
	if is_instance_valid(player):
		_player_vision_ray_cast.cast_to = _vision_range * (player.get_collision_box().global_position - _player_vision_ray_cast.global_position).normalized()
		_player_vision_ray_cast.force_raycast_update()
		
		if _player_vision_ray_cast.is_colliding():
			var collider = _player_vision_ray_cast.get_collider()
			if collider == player:
				_target_node = player
				_player_in_range = true



func take_damage(damage_amount:int, knockback:Vector2 = Vector2.ZERO):
	
	_health_manager_node.take_damage(damage_amount)
	_knockback_velocity = knockback
	
	_damage_sound_player_node.stop()
	_damage_sound_player_node.play(0.0)


func _follow_and_attack_target(delta:float):
	
	if !is_instance_valid(_target_node):
		return
	
	var target_position = _target_node.global_position
	
	if _target_node in _attack_area_node.get_overlapping_bodies():
		_attempt_attack_target(delta)
		return
	
	var move_direction = global_position.direction_to(target_position)
	
	if move_direction.x != 0.0:
		_sprite_node.scale.x = -sign(move_direction.x)
	
	_velocity = move_direction * move_speed
	_velocity = move_and_slide(_velocity)



func _attempt_attack_target(delta:float):
	
	if _attack_cooldown_time > 0.0:
		_attack_cooldown_time = max(0.0, _attack_cooldown_time - delta)
		return
	
	_attack_target()


func _attack_target():
	
	if !is_instance_valid(_target_node):
		return
	
	var attack_direction = (_target_node.global_position - global_position).normalized()
	_target_node.take_damage(_attack_damage_amount, attack_direction * 120)
	
	_attack_cooldown_time = ATTACK_TIMER_INTERVAL


func _forget_target():
	_target_node = null



func _on_HealthManager_health_reached_zero():
	_died()


func _spawn_drops():
	if randf() <= 0.5:
		
		var health_pickup = HealthPickup.instance()
		health_pickup.position = global_position
		get_parent().add_child(health_pickup)
		


func _died():
	
	_spawn_drops()
	
	AudioManager.play_sound(preload("res://sounds/fly_away.ogg"))
	
	queue_free()
