extends CharacterBody2D
class_name  Ghost
@export var group:String
var player:Character = null
@onready var timer = $Timer

@onready var markers = %markers
@onready var state_chart = $StateChart
@onready var animation_player = $AnimationPlayer
@export var projectile:PackedScene
@export var max_health=1
var health:int:
	set(value):
		var val=clamp(value,0,max_health)
		if(val==0):
			queue_free()
		health=val
@export var search_distance:int=30
@export var attack_speed:int=100
@export var search_speed:int=50
@onready var search_border:Vector2= Vector2(self.position.x-search_distance,self.position.x+search_distance)
var all_spawn_positions:Array[Node]
func _ready():
	all_spawn_positions=markers.get_children()
	health =  max_health
	PlayerGlobal.character_changed.connect(on_character_changed)
	
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
	animation_player.play("idle") 


func _on_hurtbox_hitbox_entered(damage):
	health=-damage 


func _on_timer_timeout():
	for marker in all_spawn_positions:
		var projectile_instance = projectile.instantiate()
		if player != null:
			projectile_instance.direction = (player.global_position-marker.global_position).normalized()
			projectile_instance.global_position = marker.global_position
		marker.add_child(projectile_instance)

func _on_distant_attack_state_entered():
	timer.start() # Replace with function body.

func on_character_changed():
	if player != null:
		player = PlayerGlobal.current_character
