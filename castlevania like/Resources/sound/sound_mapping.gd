extends Resource
class_name SoundMapping

@export var character: CharacterTypes.CharacterType  # Тип из CharacterType
@export var enemy: CharacterTypes.EnemyType      # Тип из EnemyType
@export var sounds: Array[AudioStream] = []  # Список вариантов звуков
@export var volume: float = 1.0  # Громкость (от 0 до 1)
@export var pitch: float = 1.0   # Высота звука
@export var max_instances: int = 3  # Максимальное количество одновременно воспроизводимых звуков
