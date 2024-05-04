extends Node


signal health_reached_zero


var _max_health:int = 4
var _health:int = _max_health


func take_damage(damage_amount:int):
	_health = int(clamp(_health - damage_amount, 0, _max_health))
	if _health == 0:
		emit_signal("health_reached_zero")


func revive_health(heal_amount:int):
	_health = int(clamp(_health + heal_amount, 0, _max_health))

