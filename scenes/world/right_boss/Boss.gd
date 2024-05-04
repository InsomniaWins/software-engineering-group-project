extends StaticBody2D

signal boss_died

const Bomb = preload("res://scenes/bomb/bomb.tscn")

var _spawn_bomb_timer:float = 0.0
var health:int = 24

onready var _damage_sound_player_node:AudioStreamPlayer = $DamageSound
onready var _boss_sprite_node:Sprite = $Sprite
onready var _boss_animation_player_node:AnimationPlayer = $AnimationPlayer

func _ready():
	$AttackTimer.start(2)

func _process(delta):
	_boss_sprite_node.modulate = lerp(_boss_sprite_node.modulate, Color.white, delta * 5)


func _physics_process(delta):
	if _boss_animation_player_node.current_animation == "attack":
		
		_spawn_bomb_timer = max(0.0, _spawn_bomb_timer - delta)
		
		if _spawn_bomb_timer == 0.0:
			_spawn_bomb_timer = 0.5
			
			_spawn_bomb()

func _spawn_bomb():
	var bomb = Bomb.instance()
	
	var player = SceneManager.get_player()
	if is_instance_valid(player):
		bomb.position = player.global_position
	
	bomb.exceptions.append(self)
	
	get_parent().add_child(bomb)


func take_damage(damage_amount, _kockback_amount):
	
	if health == 0:
		return
	
	health = int(max(0, health - damage_amount))
	
	_damage_sound_player_node.play(0.0)
	_boss_sprite_node.modulate = Color.red
	
	if health == 0:
		emit_signal("boss_died")


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"attack":
			_boss_animation_player_node.play("idle")
			$AttackTimer.start(2)
		"death":
			queue_free()


func _attack():
	_boss_animation_player_node.play("attack")


func _on_AttackTimer_timeout():
	_attack()
