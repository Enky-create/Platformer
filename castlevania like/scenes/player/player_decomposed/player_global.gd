extends Node2D
class_name Player
signal character_changed()
signal all_characters_dead()
@export var pull:CharacterPull
@export var characters:Array[Character] = []
var current_index:int = 0
var current_character:Character
var pull_position = Vector2(-5000,5000)
var current_character_position:Vector2
func _ready():
	current_character_position = get_tree().get_first_node_in_group("spawn").global_position
	for scene in pull.characters:
		var character = scene.instantiate()
		add_child(character)
		character.position=pull_position
		characters.append(character)
		character.set_process(false)
		character.set_physics_process(false)
	set_active_character(current_index)

func set_active_character(index:int):
	# Деактивируем текущего персонажа, если он существует
	if characters.size() > 0:
		if characters[current_index]:
			characters[current_index].reset()
			characters[current_index].set_process(false)
			characters[current_index].set_physics_process(false)
			characters[current_index].global_position=pull_position
			
	
	# Устанавливаем нового персонажа по индексу
	current_index = index
	current_character = characters[current_index]
	current_character.global_position = current_character_position
	# Активируем нового персонажа
	current_character.set_process(true)
	current_character.set_physics_process(true)
	

# Метод для переключения на следующего персонажа
func switch_to_next_character():
	var next_index = (current_index + 1) % characters.size()
	set_active_character(next_index)
	character_changed.emit()


# Обработка ввода игрока и передача команд текущему персонажу
func _physics_process(delta):
	if characters.size() > 0:
		current_character = characters[current_index]
		current_character.move_character(Input.get_axis("left_walk","right_walk"),delta)
		if Input.is_action_just_pressed("jump"):
			current_character.jump()
		if Input.is_action_just_pressed("attack"):
			current_character.attack()
		if Input.is_action_just_pressed("dodge"):
			current_character.dodge()
		if Input.is_action_just_pressed("switch_character"):
			switch_to_next_character()
	

func character_died(character:Character):
	characters.erase(character)
	character.queue_free()
	if characters.size()>0:
		switch_to_next_character()
	else:
		all_characters_dead.emit()
	
