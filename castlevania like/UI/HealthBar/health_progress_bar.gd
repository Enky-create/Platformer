extends Control
@onready var progress_bar:ProgressBar = $MarginContainer/VBoxContainer/ProgressBar
var character:Character
func _ready():
	_on_character_changed()
	PlayerGlobal.character_changed.connect(_on_character_changed)

func _on_character_changed():
	if character != null:
		character.health_changed.disconnect(_update_health)
	character=PlayerGlobal.current_character
	character.health_changed.connect(_update_health)
	_update_health()

func _update_health():
	var new_value=character.health/character.maxhealth * 100
	progress_bar.value = new_value
	
