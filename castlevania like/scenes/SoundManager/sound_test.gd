extends Node2D
@onready var collision_sound_manager:CollisionSoundManager = $CollisionSoundManager
func _ready():
	collision_sound_manager.play_sound(CharacterTypes.CharacterType.Knight,CharacterTypes.EnemyType.Ghost,Vector2(10,20))
