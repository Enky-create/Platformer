
extends Node2D
class_name CollisionSoundManager

@export var sound_mappings: Array[SoundMapping] = []
var sound_map: Dictionary = {}
var active_sounds: Dictionary = {}

func _ready():
	_build_sound_map()

func _build_sound_map():
	for mapping in sound_mappings:
		var key = _get_key(mapping.character, mapping.enemy)
		sound_map[key] = mapping
		active_sounds[key] = 0  # Счётчик активных звуков

func _get_key(character, enemy) -> String:
	return str(character) + ":" + str(enemy)

func get_mapping(character, enemy) -> SoundMapping:
	var key = _get_key(character, enemy)
	return sound_map.get(key, null)

func play_sound(character, enemy, position: Vector2):
	var key = _get_key(character, enemy)
	var mapping = get_mapping(character, enemy)
	
	if mapping:
		# Проверяем лимит активных звуков
		if active_sounds[key] < mapping.max_instances:
			_play_sound(mapping, position)
			active_sounds[key] += 1
		else:
			print("Sound limit reached for:", key)
	else:
		print("Sound not found for character:", character, "and enemy:", enemy)

func _play_sound(mapping: SoundMapping, position: Vector2):
	if mapping.sounds.size() == 0:
		print("No sounds available for mapping:", mapping)
		return
	
	# Выбираем случайный звук из списка
	var sound = mapping.sounds[randi() % mapping.sounds.size()]
	
	# Создаём и настраиваем AudioStreamPlayer2D
	var audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)
	audio_player.stream = sound
	audio_player.volume_db = linear_to_db(mapping.volume)
	audio_player.pitch_scale = mapping.pitch
	audio_player.global_position = position  # Устанавливаем позицию
	audio_player.play()
	audio_player.connect("finished", Callable(self, "_on_sound_finished").bind(audio_player, _get_key(mapping.character, mapping.enemy)))

func _on_sound_finished(audio_player: AudioStreamPlayer2D, key: String):
	active_sounds[key] -= 1
	audio_player.queue_free()
