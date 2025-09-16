extends Character
class_name HeavyKnight
@onready var animation_player = $AnimationPlayer
@onready var state_chart:StateChart = $StateChart
@onready var move_component:MoveComponent = $HorizontalMoveComponent
@onready var orientation_component:OrientationComponent = $OrientationComponent

@export var dodge_speed = 100.0

@export var hitbox_offset = 46
var input_direction:float

var jump_progress
var jump_position
var look_input_direction:float = 1

var _sfx_footsteps = SoundManager.null_instance()


func _ready():
	SoundManager.updated.connect(on_sound_manager_updated)

func on_sound_manager_updated():
	if SoundManager.should_skip_instancing(_sfx_footsteps):
		return
	_sfx_footsteps=SoundManager.instance_on_node("HeavyKnight","Footsteps",self)

func _physics_process(_delta):
	
	if health<=0:
		state_chart.send_event("to death")

func move_character(direction,delta):
	super.move_character(direction,delta)
	if not is_on_floor():
		velocity.y += gravity * delta
		
	input_direction = direction
	
	orientation_component.update_orientation(input_direction)
	
	if input_direction != 0: 
		state_chart.send_event("to run")
	move_component.move(delta,Vector2(input_direction,0))

func jump():
	state_chart.send_event("to jump")

func attack():
	state_chart.send_event("to attack")

func dodge():
	state_chart.send_event("to dodge")

func _sword_swing_sound()->void:
	SoundManager.play("HeavyKnight", "Sword swing")

func _on_run_state_entered():
	animation_player.play("run")
	_sfx_footsteps.trigger()


func _on_dodge_state_entered():
	velocity=Vector2.ZERO
	animation_player.play("roll") # Replace with function body.


func _on_dodge_state_physics_processing(_delta):
	if not animation_player.is_playing():
		state_chart.send_event("to idle")
	velocity.x = orientation_component.look_direction*dodge_speed
	move_and_slide()
	

func _on_idle_state_entered():
	animation_player.play("idle")


func _on_fall_state_entered():
		animation_player.play("jump_to_fall") 


func _on_fall_state_processing(_delta):
	if is_on_floor(): 
		state_chart.send_event("to idle") 


func _on_run_state_processing(delta):
	if !input_direction:
		state_chart.send_event("to idle")


func _on_light_attack_state_entered():
	velocity.x= 0
	animation_player.play("attack_nomovement")



func _on_hard_attack_state_entered():
	if not animation_player.is_playing():
		animation_player.play("attack2_nomovement")


func _on_hard_attack_state_processing(_delta):
	if not animation_player.is_playing():
		state_chart.send_event("to idle")


func _on_jump_state_entered():
	animation_player.play("jump")
	jump_progress=global_position.y
	if  is_on_floor():
		velocity.y = jump_velocity
	


func _on_jump_state_processing(_delta):
	if global_position.y<=jump_progress:
		jump_progress=global_position.y
	else:
		state_chart.send_event("to fall")
		
	if Input.is_action_just_released("jump") and velocity.y < jump_velocity*0.5:
		velocity.y = jump_velocity*0.5
	move_and_slide()

func _on_death_state_entered():
	animation_player.play("death_nomovement")
	PlayerGlobal.character_died(self)


func _on_hurtbox_hitbox_entered(damage):
	state_chart.send_event("to hit")
	health-=damage


func _on_footsteps():
	_sfx_footsteps.trigger_varied()
	
func reset():
	state_chart.send_event("to idle")
	_sfx_footsteps.release()


func _on_hit_state_processing(_delta):
	if(animation_player.is_playing()):
		return
	animation_player.play("hit")
