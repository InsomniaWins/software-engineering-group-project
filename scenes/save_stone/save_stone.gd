extends StaticInteractable


onready var _sprite:Sprite = $Sprite
onready var _stop_glow_timer:Timer = $StopGlowTImer
onready var _save_sound_audio_player:AudioStreamPlayer = $SaveSound

func interact():
	SaveManager.save_game()
	_start_glow()
	_save_sound_audio_player.play(0.0)


func _start_glow():
	_sprite.frame = 1
	_stop_glow_timer.start()


func _stop_glow():
	_sprite.frame = 0


func _on_StopGlowTImer_timeout():
	_stop_glow()
