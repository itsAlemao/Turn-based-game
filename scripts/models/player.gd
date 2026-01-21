extends CharacterNode
class_name PlayerNode

@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _projectile: AnimatedSprite2D = $Projectile

## The player resource
@export var _player: Player

func characterResource() -> Character:
	return _player

func _ready() -> void:
	_animation_tree.active = true
	_projectile.z_index = 10

## Plays the attack animation
func do_attack():
	_animation_tree.get("parameters/playback").travel("Attack")	

## Sets the parameters for the attack animation
func customize_attack(target_pos: Vector2):
	var attack_anim = _animation_player.get_animation("Attack")
	var track_idx = attack_anim.find_track("Projectile:position", Animation.TYPE_VALUE)
	#convert the position to a local one for the current node
	attack_anim.track_set_key_value(track_idx, 1, target_pos)
