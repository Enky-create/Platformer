extends Node2D
class_name Level
@onready var default_camera_2d:PhantomCamera2D = %PhantomCamera2D
@onready var music_bank:MusicBank = $MusicBank
var default_camera_priority = 10
var current_camera
func _ready():
	call_deferred("_set_camera_target")
	current_camera = default_camera_2d
	default_camera_2d.set_priority(default_camera_priority)
	default_camera_2d.set_tween_on_load(false)
	default_camera_2d.set_inactive_update_mode(1) #NEVER
	PlayerGlobal.connect("character_changed",_set_camera_target)
	MusicManager.loaded.connect(_on_music_manager_loaded)

func _on_music_manager_loaded():
	MusicManager.play("Ambient", "Ambient")

func _set_camera_target():
	default_camera_2d.set_follow_target(PlayerGlobal.current_character)
func _change_camera(camera:PhantomCamera2D):
	current_camera.set_priority(0)
	camera.set_priority(default_camera_priority)


func _on_camera_switch_area_change_camera(camera):
	_change_camera(camera)


func _on_camera_switch_area_return_to_deafault():
	_change_camera(default_camera_2d)
