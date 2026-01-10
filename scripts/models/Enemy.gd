extends CharacterNode
class_name Enemy2D

@export var enemy: EnemyDTO

func characterResource() -> Character:
	return enemy
