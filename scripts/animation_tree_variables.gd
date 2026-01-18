class_name CharacterAnimationTree
extends AnimationTree

const PROJECTILE_TRAVEL_TIME_SEC: float = 2
const CHANNEL_TIME_SEC: float = 1

#animation state
var _should_end_charging: bool = false

func _ready() -> void:
	active = true
	#sets a time (CHANNEL_TIME_SEC) for the charging animation
	animation_finished.connect(func(anim_name: String):
		print(anim_name)
		if anim_name == "Attack - ToCharge":
			get_tree().create_timer(CHANNEL_TIME_SEC).timeout.connect(func(): _should_end_charging = true)
	)
	

func do_attack(att: PlayerAnimatedAttack, target_pos: Vector2) -> void:
	var ch_anim: AnimationNodeAnimation = _get_attack_ch_node()
	ch_anim.animation = att.attack.ch_anim_name()
	
	if att.rangedIsRanged:
		var proj_anim: AnimationNodeAnimation = _get_attack_ch_node()
		proj_anim.animation = att.attack.proj_anim_name()
		#add frames condition
		#move the projectile to the target position
	else:
		pass #move character to the target position
	
	_customize_projectile_anim(target_pos)
	_travel_to_attack()



func _get_attack_ch_node() -> AnimationNodeAnimation:
	return get("tree_root").get_node("Attack").get_node("Character") 
	
func _get_attack_proj_node() -> AnimationNodeAnimation:
	return get("tree_root").get_node("Attack").get_node("Projectile")  
	
func _travel_to_attack() -> void:
	# var attack_blend_tree: AnimationNodeBlendTree = get("tree_root").get_node("Attack")
	var playback: AnimationNodeStateMachinePlayback = get("parameters/playback")
	playback.travel("Attack")
	print("attacking i think...")
	
func _customize_projectile_anim(target_pos:Vector2, seconds: float = PROJECTILE_TRAVEL_TIME_SEC) -> void:
	var player_anim: Animation = get_node(anim_player).player_anim.get_animation("Attack - Shooting")
	var idx = player_anim.find_track("Projectile:position", Animation.TYPE_VALUE)
	player_anim.track_set_key_value(idx, 1, target_pos)

	
	
