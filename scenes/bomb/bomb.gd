extends Node2D

const EXPLODE_SOUND:AudioStream = preload("res://sounds/bomb_explode.wav")

var exceptions:Array = []
var explode_damage:int = 4

var _knockback_force:float = 200

onready var blast_radius_node:Area2D = $BlastRadius

func explode():
	
	var _audio_player_node = AudioManager.play_sound(EXPLODE_SOUND)
	
	for area in blast_radius_node.get_overlapping_areas():
		if area.is_in_group("hit_box"):
			_damage_entity(area.get_parent())
	
	for body in blast_radius_node.get_overlapping_bodies():
		if body.is_in_group("player"):
			_damage_entity(body)
	
	queue_free()


func _damage_entity(entity):
	
	if entity in exceptions:
		return
	
	var knockback:Vector2 = (entity.global_position - global_position).normalized() * _knockback_force
	entity.take_damage(explode_damage, knockback)


func _on_ExplodeTimer_timeout():
	explode()
