extends Node


func play_sound(sound:AudioStream) -> AudioStreamPlayer:
	var player:AudioStreamPlayer = AudioStreamPlayer.new()
	
	player.stream = sound
	player.connect("finished", player, "queue_free")
	
	add_child(player)
	
	player.play(0.0)
	
	return player
