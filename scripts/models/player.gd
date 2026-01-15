extends CharacterNode
class_name PlayerNode

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _animated_sprite: AnimatedSprite2D = $Player
@onready var _animation_tree: AnimationTree = $AnimationTree

## The player resource
@export var _player: Player

var attacking: bool = true

func characterResource() -> Character:
	return _player
	
func _ready() -> void:
	_animation_tree.active = true
	# _animation_player.current_animation = "Idle"

	# var global_library = _animation_player.get_animation_library("")	
	# for a: PlayerAnimatedAttack in characterResource().attacks():
	# 	var anim = Utils.create_animation(a.characterAnimation, "default")
	# 	global_library.add_animation(a.attack.Name, anim)
	# var anim: Animation = create_animation()

	# for att: PlayerAnimatedAttack in _player.attacks():
	# 	Animation.new()
	# 	global_library.add_animation(att.attack.Name, att.characterAnimation)
	
	get_tree().create_timer(3.0).timeout.connect(func(): 
		attacking = false
	)
	

## Sets the new animation that will be played by the character
func change_animation(anim_name: String) -> void:
	print("looking for ", anim_name, ", i have: ", _animation_player.get_animation_library("").get_animation_list())	
	_animation_player.play("anim2")
