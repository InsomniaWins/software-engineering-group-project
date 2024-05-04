extends StaticBody2D

signal boss_died

var health:int = 12

onready var _damage_sound_player_node:AudioStreamPlayer = $DamageSound

func take_damage(damage_amount, kockback_amount):
	
	if health == 0:
		return
	
	health = max(0, health - 1)
	
	_damage_sound_player_node.play(0.0)
	get_parent()._boss_sprite_node.modulate = Color.red
	
	if health == 0:
		emit_signal("boss_died")
