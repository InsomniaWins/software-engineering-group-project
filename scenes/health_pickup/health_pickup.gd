extends KinematicBody2D


var _velocity:Vector2 = Vector2.ZERO


func _physics_process(delta):
	move(delta)


func move(delta:float):
	_velocity = move_and_slide(_velocity)
	_velocity *= 0.25


func set_velocity(new_velocity:Vector2):
	_velocity = new_velocity
