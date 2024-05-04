extends StaticBody2D

signal boss_died

const Magic = preload("res://scenes/left_enemy_magic/left_enemy_magic.tscn")
const Bomb = preload("res://scenes/bomb/bomb.tscn")

var health:int = 100
var _spawn_bomb_timer:float = 0.0

onready var _damage_sound_player_node:AudioStreamPlayer = $DamageSound
onready var _boss_sprite_node:Sprite = $Sprite
onready var _boss_animation_player_node:AnimationPlayer = $AnimationPlayer
onready var _attack_timer_node:Timer = $AttackTimer


func _ready():
	_attack_timer_node.start(5)
	_boss_animation_player_node.play("idle")


func _process(delta):
	_boss_sprite_node.modulate = lerp(_boss_sprite_node.modulate, Color.white, delta * 5)


func _physics_process(delta):
	if _boss_animation_player_node.current_animation == "attack":
		
		_spawn_bomb_timer = max(0.0, _spawn_bomb_timer - delta)
		
		if _spawn_bomb_timer == 0.0:
			_spawn_bomb_timer = 0.5
			
			if randf() <= 0.5:
				_spawn_bomb()
			else:
				_shoot_magic()

func _shoot_magic():
	var magic = Magic.instance()
	magic.position = global_position
	magic.velocity = 90 * (SceneManager.get_player().global_position - global_position).normalized()
	get_parent().add_child(magic)

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
		_attack_timer_node.stop()
		_boss_animation_player_node.play("death")


func _on_AnimationPlayer_animation_finished(anim_name):
	
	match anim_name:
		"attack":
			_boss_animation_player_node.play("idle")
			_attack_timer_node.start(5)
		"death":
			SceneManager.change_scene("res://scenes/titlescreen/titlescreen.tscn")
		"idle":
			pass
		_:
			pass


func _attack():
	_boss_animation_player_node.play("attack")


func _on_AttackTimer_timeout():
	_attack()
