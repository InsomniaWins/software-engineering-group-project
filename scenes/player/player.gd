extends KinematicBody2D

const Arrow = preload("res://scenes/arrow/arrow.tscn")

const Bomb = preload("res://scenes/bomb/bomb.tscn")

export var _facing_direction:Vector2 = Vector2.DOWN

var move_speed:float = 64
var velocity:Vector2 = Vector2()
var selected_item:int = ItemManager.Items.SWORD

var _attacking:bool = false
var _knockback_velocity:Vector2 = Vector2()
var _knockback_resistance:float = 0.1
var _movement_input:Vector2 = Vector2()
var _on_stairs:bool = false
var _moving:bool = false
var _can_change_selected_item:bool = false
var _shoot_timer:float = 0.0

onready var _collision_shape = $CollisionShape2D
onready var _interaction_raycast_node = $InteractionRayCast
onready var _attack_animations_player_node = $AttackAnimationsPlayer
onready var _sword_sprite_scaler_node = $SwordSpriteScaler
onready var _sword_sprite_node = _sword_sprite_scaler_node.get_node("SwordSprite")
onready var _health_manager = $HealthManager
onready var _hud:CanvasLayer = $Hud
onready var _status_indicator_node:Control = _hud.get_node("StatusIndicator")
onready var _previous_position:Vector2 = position
onready var _character_sprite_node:AnimatedSprite = $AnimatedSprite
onready var _sword_attack_area_node:Node2D = $SwordAttackArea
onready var _sword_swing_sound_player_node:AudioStreamPlayer = $SwordSwingSound
onready var _change_selected_item_sound_node:AudioStreamPlayer = $ChangeItemSound


func _ready():
	_status_indicator_node.update_selected_item_icon(selected_item)



func _process(delta):
	
	_shoot_timer = max(0.0, _shoot_timer - delta)
	
	if Input.is_action_just_pressed("change_selected_item"):
		change_selected_item()
	
	
	_handle_sprite_animations(delta)
	
	# handle health indicator
	_status_indicator_node.update_hearts(
		_health_manager.get_health(),
		_health_manager.get_max_health()
	)


func get_collision_box() -> CollisionShape2D:
	return _collision_shape


func _physics_process(delta):
	
	_process_movement_input(delta)
	
	# interacting
	if _movement_input.length() > 0:
		_interaction_raycast_node.cast_to = _movement_input.normalized() * 12
	else:
		_interaction_raycast_node.cast_to = _facing_direction * 12
	if Input.is_action_just_pressed("select"):
		_interact()
	
	
	_process_movement(delta)
	
	
	# attacking
	if Input.is_action_just_pressed("attack"):
		attack()
	
	
	# process knockback
	_knockback_velocity = _knockback_velocity.linear_interpolate(Vector2.ZERO, _knockback_resistance)
	if _knockback_velocity.length() < 16:
		_knockback_velocity = Vector2.ZERO
	_knockback_velocity = move_and_slide(_knockback_velocity)


func _interact():
	_interaction_raycast_node.force_raycast_update()
	
	if _interaction_raycast_node.is_colliding():
		var collider = _interaction_raycast_node.get_collider()
		
		if collider.is_in_group("interactable"):
			collider.interact()


func attack():
	
	if _attacking:
		return
	
	match selected_item:
		ItemManager.Items.SWORD:
			_swing_sword()
		ItemManager.Items.BOW:
			_shoot_bow()
		ItemManager.Items.BOMB:
			_throw_bomb()



func _throw_bomb():
	
	if _shoot_timer > 0.0:
		return
	
	_attacking = true
	
	var bomb = Bomb.instance()
	bomb.position = global_position
	get_parent().add_child(bomb)
	
	_shoot_timer = 1.25
	
	_attacking = false


func _shoot_bow():
	
	if _shoot_timer > 0.0:
		return
	
	_attacking = true
	
	var arrow = Arrow.instance()
	arrow.position = global_position
	arrow.direction = _facing_direction
	arrow.set_shooter(self)
	get_parent().add_child(arrow)
	
	_shoot_timer = 1.0
	yield(get_tree().create_timer(0.15), "timeout")
	
	_attacking = false


func change_selected_item(desired_item = null):
	
	if desired_item == null:
		
		selected_item = ItemManager.get_next_available_item(selected_item)
		
	else:
		selected_item = desired_item
	
	_change_selected_item_sound_node.play(0.0)
	_status_indicator_node.update_selected_item_icon(selected_item)


func _swing_sword():
	_can_change_selected_item = false
	_attacking = true
	_attack_animations_player_node.stop()
	_sword_swing_sound_player_node.play()
	
	var attack_area = null
	
	match _facing_direction:
		Vector2.RIGHT:
			_sword_sprite_scaler_node.rotation_degrees = 180
			attack_area = _sword_attack_area_node.get_node("Right")
		Vector2.LEFT:
			_sword_sprite_scaler_node.rotation_degrees = 0
			attack_area = _sword_attack_area_node.get_node("Left")
		Vector2.DOWN:
			_sword_sprite_scaler_node.rotation_degrees = 270
			attack_area = _sword_attack_area_node.get_node("Down")
		Vector2.UP:
			_sword_sprite_scaler_node.rotation_degrees = 90
			attack_area = _sword_attack_area_node.get_node("Up")
	
	_attack_animations_player_node.play("swing_sword")
	
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			body.take_damage(1, _facing_direction * 180)
	
	yield(_attack_animations_player_node, "animation_finished")
	_attacking = false
	_can_change_selected_item = true


func _handle_sprite_animations(_delta:float):
	
	if is_moving():
		
		match _facing_direction:
			Vector2.UP:
				_character_sprite_node.animation = "walk_up"
			Vector2.DOWN:
				_character_sprite_node.animation = "walk_down"
			Vector2.LEFT:
				_character_sprite_node.animation = "walk_left"
			Vector2.RIGHT:
				_character_sprite_node.animation = "walk_right"
		
	else:
		
		match _facing_direction:
			Vector2.UP:
				_character_sprite_node.animation = "idle_up"
			Vector2.DOWN:
				_character_sprite_node.animation = "idle_down"
			Vector2.LEFT:
				_character_sprite_node.animation = "idle_left"
			Vector2.RIGHT:
				_character_sprite_node.animation = "idle_right"
		


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
	
	# set previous position
	_previous_position = position
	
	
	# get velocity
	velocity = Vector2.ZERO
	if !_attacking:
		velocity = _movement_input.normalized() * move_speed
	
	
	# alter velocity if on stairs
	if _on_stairs and velocity.x != 0:
		velocity.x *= 0.5
		velocity.y += sign(velocity.x) * move_speed * 0.5
	
	
	# apply velocity and get velocity after collision
	velocity = move_and_slide(velocity)
	
	
	# set if the player is moving
	_moving = velocity.length() > 0.025
	
	
	# set facing direction if moving
	if is_moving():
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


func is_on_stairs():
	return _on_stairs


func restore_health(heal_amount:int):
	_health_manager.restore_health(heal_amount)


func take_damage(damage_amount:int, knockback:Vector2 = Vector2.ZERO):
	_health_manager.take_damage(damage_amount)
	_knockback_velocity = knockback


func _on_PickupArea_body_entered(body):
	if body.is_in_group("health_pickup"):
		restore_health(1)
		body.queue_free()


func _on_HealthManager_health_reached_zero():
	SceneManager.change_scene("res://scenes/game_over_screen/game_over_screen.tscn")
