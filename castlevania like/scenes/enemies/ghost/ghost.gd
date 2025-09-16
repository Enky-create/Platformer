extends CharacterBody2D
class_name  Ghost
@export var group:String
var player:Character = null
@onready var timer = $Timer
@export var type:CharacterTypes.CharacterType=CharacterTypes.CharacterType.Ghost
@onready var markers = %markers
@onready var state_chart = $StateChart
@onready var animation_player = $AnimationPlayer
@export var projectile:PackedScene
@export var max_health=25
var health:int:
	set(value):
		health+=value
		health=clamp(health,0,max_health)
		if(health==0):
			queue_free()
@export var max_random_position:Vector2=Vector2(100,15)
@export var search_distance:int=30
@export var attack_speed:int=100
@export var search_speed:int=50
@export var distance_for_close_attack = 30
@onready var search_border:Vector2= Vector2(self.position.x-search_distance,self.position.x+search_distance)
var all_spawn_positions:Array[Node]
@export var attack_count=2
@export var _curent_attack_count=0
@export var distant_attack_count=2
var _current_distant_attack =0

var _instance: PooledAudioStreamPlayer2D = SoundManager.null_instance_2d()

func _ready():
	all_spawn_positions=markers.get_children()
	health =  max_health
	PlayerGlobal.character_changed.connect(on_character_changed)
	SoundManager.updated.connect(on_sound_manager_updated)

func on_sound_manager_updated() -> void:
	# The method call below is an inbuilt guard-clause that'll help us avoid 
	# instancing an audio event when the SoundManager has not loaded, or when 
	# we've already replaced our Null instance with a real one further down.
	if SoundManager.should_skip_instancing(_instance):
		return
		
	_instance = SoundManager.instance_on_node("ghost", "ghostly_breath", self)
	

func _increase_atack_count():
	_curent_attack_count+=1

func _physics_process(_delta):
	if player:
		if player.global_position.x > self.global_position.x :
			scale.x=-1
		else:
			scale.x=1
func _on_searching_animation():
	_instance.trigger_varied()

func _on_player_detector_body_entered(body:Character):
	if body==null: return
	player = body

func _on_search_state_physics_processing(delta):
	var search_direction=-1
	if position.x<=search_border.x:
		search_direction=1
	if position.x>=search_border.y:
		search_direction=-1
	velocity.x+= search_direction*search_speed*delta
	move_and_slide()
	if(player!=null):
		state_chart.send_event("to attack mode")

func _on_search_state_entered():
	animation_player.play("search") 
	

func _on_hurtbox_hitbox_entered(damage):
	health=-damage 
	state_chart.send_event("to stunlock")

func _on_timer_timeout():
	_current_distant_attack+=1
	for marker in all_spawn_positions:
		var projectile_instance = projectile.instantiate()
		if player != null:
			projectile_instance.direction = (player.global_position-marker.global_position).normalized()
			projectile_instance.global_position = marker.global_position
		marker.add_child(projectile_instance)

func _on_distant_attack_state_entered():
	_on_timer_timeout()
	timer.start()

func on_character_changed():
	if player != null:
		player = PlayerGlobal.current_character

func _on_distant_attack_state_exited():
	timer.stop()
	_current_distant_attack=0

func _on_disappear_state_entered():
	animation_player.play("vanish")

func _on_disappear_state_processing(_delta):
	if animation_player.is_playing():
		return
	var offset = Vector2(randi_range(-max_random_position.x,max_random_position.x),randi_range(0,0))
	global_position = player.global_position + offset
	state_chart.send_event("to Appear")

func _on_appear_state_entered():
	animation_player.play("appear")
func _on_appear_state_processing(_delta):
	if animation_player.is_playing():
		return
	var rand_state = randi_range(0,1)
	match(rand_state):
		0: state_chart.send_event("to Attack")
		1: state_chart.send_event("to distant attack")
	

func _on_distant_attack_state_processing(_delta):
	if _current_distant_attack> distant_attack_count:
		state_chart.send_event("to Attack")
	if global_position.distance_to(player.global_position)< distance_for_close_attack:
		state_chart.send_event("to Teleport")

func _on_move_closer_state_processing(delta):
	velocity = global_position.direction_to(player.global_position) * attack_speed
	if global_position.distance_to(player.global_position)< distance_for_close_attack:
		state_chart.send_event("to Melee Attack")
	move_and_slide()

func _on_melee_attack_state_entered():
	animation_player.play("attack")
	
func _on_melee_attack_state_processing(_delta):
	if animation_player.is_playing():
		return
	if position.distance_to(player.position) < distance_for_close_attack/2:
		state_chart.send_event("to Teleport")
		_curent_attack_count=0
	if _curent_attack_count <= attack_count:
		state_chart.send_event("to Attack")
	if(_curent_attack_count>attack_count):
		state_chart.send_event("to Teleport")
		_curent_attack_count=0


func _on_move_closer_state_exited():
	velocity=Vector2.ZERO


func _on_stunlock_state_entered():
	animation_player.play("stunlock")
	


func _on_stunlock_state_processing(delta):
	if global_position.distance_to(player.global_position) > distance_for_close_attack:
		state_chart.send_event("to Teleport") 
	var player:Character = PlayerGlobal.current_character
	velocity = player.global_position.direction_to(global_position) * attack_speed*1.5
	move_and_slide()
