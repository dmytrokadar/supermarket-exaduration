extends Node

# Ambient music player — shuffles and loops through tracks
@export var tracks: Array[AudioStream]
@export var volume_db: float = -10.0

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var _shuffled_queue: Array[AudioStream] = []
var _current_index: int = 0

func _ready():
	audio_player.volume_db = volume_db
	audio_player.finished.connect(_on_track_finished)
	_reshuffle_and_play()

func _reshuffle_and_play():
	_shuffled_queue = tracks.duplicate()
	_shuffled_queue.shuffle()
	_current_index = 0
	_play_current()

func _play_current():
	if _shuffled_queue.size() == 0:
		return
	audio_player.stream = _shuffled_queue[_current_index]
	audio_player.play()

func _on_track_finished():
	_current_index += 1
	if _current_index >= _shuffled_queue.size():
		_reshuffle_and_play() # reshuffle when all tracks played
	else:
		_play_current()
