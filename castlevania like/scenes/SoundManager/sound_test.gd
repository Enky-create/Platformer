extends Node2D

func _ready():
	CollisionSoundManager.play_sound(CharacterTypes.CharacterType.Knight,CharacterTypes.CharacterType.Ghost,Vector2(10,20))
