extends Level

const Magic = preload("res://scenes/left_enemy_magic/left_enemy_magic.tscn")

var _magic_creation_timer:float = 1.0

onready var _boss_animation_player_node:AnimationPlayer = $Boss/BossAnimations
onready var _boss_attack_timer_node:Timer = $Boss/AttackTimer
onready var _boss_node:StaticBody2D = $Boss
onready var _ysort_node:YSort = $YSort
onready var _boss_sprite_node:Sprite = _boss_node.get_node("Sprite")

func _ready():
	if SaveManager.get_detail("defeated_left_boss", false):
		_despawn_left_boss()


func _process(delta):
	if is_instance_valid(_boss_node):
		
		_boss_sprite_node.modulate = lerp(_boss_sprite_node.modulate, Color.white, delta * 5)
		
		if _boss_animation_player_node.current_animation == "attack":
			_magic_creation_timer = max(0.0, _magic_creation_timer - delta)
			
			if _magic_creation_timer == 0:
				_shoot_magic()
				_magic_creation_timer = 1.0
		elif _boss_animation_player_node.current_animation == "death":
			_boss_sprite_node.position += Vector2(
				randf() * 2 - 1,
				randf() * 2 - 1
			)


func _shoot_magic():
	var magic = Magic.instance()
	magic.position = _boss_node.global_position
	magic.velocity = 60 * (SceneManager.get_player().global_position - _boss_node.global_position).normalized()
	_ysort_node.add_child(magic)


func _despawn_left_boss():
	$Boss.queue_free()
	SceneManager.stop_level_music()


func _on_BossAnimations_animation_finished(anim_name):
	match anim_name:
		"attack":
			_boss_animation_player_node.play("idle")
			_boss_attack_timer_node.start()
		"death":
			_despawn_left_boss()
		_:
			pass


func _attack():
	_boss_animation_player_node.play("attack")


func _on_AttackTImer_timeout():
	_attack()


func _on_Boss_boss_died():
	
	SaveManager.set_detail("defeated_left_boss", true)
	
	_boss_attack_timer_node.stop()
	_boss_animation_player_node.play("death")
	
	var player = SceneManager.get_player()
	var add_max_health_amount:int = 16
	var max_health_amount:int = min(
		player._health_manager.get_max_health() + add_max_health_amount,
		player._health_manager.FINAL_MAX_HEALTH
		)
	
	player._health_manager.set_max_health(max_health_amount)
	
	ItemManager.unlocked_items.append(ItemManager.Items.BOW)
	player.change_selected_item()





