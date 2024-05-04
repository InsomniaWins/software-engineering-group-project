extends StaticBody2D

signal boss_died

var health:int = 12

onready var _damage_sound_player_node:AudioStreamPlayer = $DamageSound
onready var _boss_sprite_node:Sprite = $Sprite

func take_damage(damage_amount, _kockback_amount):
	
	if health == 0:
		return
	
	health = int(max(0, health - damage_amount))
	
	_damage_sound_player_node.play(0.0)
	_boss_sprite_node.modulate = Color.red
	
	if health == 0:
		emit_signal("boss_died")
