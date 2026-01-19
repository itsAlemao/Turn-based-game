extends CharacterNode
class_name PlayerNode

@onready var animation_tree: AnimationTree = $AnimationTree

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var attacking: bool = false

## The player resource
@export var _player: Player

func characterResource() -> Character:
	return _player
	
func _ready() -> void:
	#attacking = true
	animation_tree.get("parameters/playback").travel("Attack")	
