extends CharacterNode
class_name PlayerNode

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _animation_tree: CharacterAnimationTree = $AnimationTree

## The player resource
@export var _player: Player

var attacking: bool = true

func characterResource() -> Character:
	return _player
	
func _ready() -> void:

	var global_library = _animation_player.get_animation_library("")
	
	# Loop through attack resources and generate animations
	for a: PlayerAnimatedAttack in characterResource().attacks():
		var ch_anim: Animation = Utils.create_animation(a.characterAnimation)
		global_library.add_animation(a.attack.ch_anim_name(), ch_anim)

		if a.rangedIsRanged:
			var proj_anim = Utils.create_animation(a.rangedProjectileAnimation)
			global_library.add_animation(a.attack.proj_anim_name(), proj_anim)

	get_tree().create_timer(1.5).timeout.connect(func(): 
		_animation_tree._travel_to_attack()
		print("firing...")
	)
