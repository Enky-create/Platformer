extends Node2D
class_name Level
@onready var phantom_camera_2d:PhantomCamera2D = %PhantomCamera2D
@onready var music_bank:MusicBank = $MusicBank

func _ready():
	call_deferred("_set_camera_target")
	PlayerGlobal.connect("character_changed",_set_camera_target)
	MusicManager.loaded.connect(_on_music_manager_loaded)

func _on_music_manager_loaded():
	MusicManager.play("Ambient", "Ambient")

func _set_camera_target():
	phantom_camera_2d.set_follow_target(PlayerGlobal.current_character)
