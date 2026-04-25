
extends Node


@export var sounds: Array[AudioStream]
@export var min_minutes: float = 8.0
@export var max_minutes: float = 12.0

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer

func _ready():

	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	start_random_timer()

func start_random_timer():

	var random_time = randf_range(min_minutes * 60, max_minutes * 60)
	timer.start(random_time)
	print("Наступний звук через: ", random_time / 60, " хв.")

func _on_timer_timeout():
	if sounds.size() > 0:

		audio_player.stream = sounds.pick_random()
		audio_player.play()
	

	start_random_timer()
