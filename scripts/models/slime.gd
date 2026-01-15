extends CharacterNode
class_name SlimeNode

@export var enemy: EnemyDTO

func _ready() -> void:
	characterResource().stats().health_changed.connect(_on_health_changed)
	
func _on_health_changed(new: int, old: int):
	print(enemy, "Health has changed")
	
func characterResource() -> Character:
	return enemy

func set_default() -> void:
	pass
	
func set_selected() -> void:
	pass
	
