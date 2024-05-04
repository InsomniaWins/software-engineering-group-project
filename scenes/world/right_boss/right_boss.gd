extends Level

onready var _boss_node:StaticBody2D = $YSort/Boss
onready var _boss_animation_player_node:AnimationPlayer = _boss_node.get_node("AnimationPlayer")


func _ready():
	if SaveManager.get_detail("defeated_right_boss", false):
		_despawn_right_boss()


func _despawn_right_boss():
	_boss_node.queue_free()
	SceneManager.stop_level_music()


func _on_Boss_boss_died():
	SaveManager.set_detail("defeated_right_boss", true)
	
	_boss_animation_player_node.play("death")
	$YSort/Boss/AttackTimer.stop()
	
	var player = SceneManager.get_player()
	var add_max_health_amount:int = 32
	var max_health_amount:int = int(min(
		player._health_manager.get_max_health() + add_max_health_amount,
		player._health_manager.FINAL_MAX_HEALTH
		))
	
	player._health_manager.set_max_health(max_health_amount)
	
	ItemManager.unlocked_items.append(ItemManager.Items.BOMB)
	player.change_selected_item(ItemManager.Items.BOMB)
