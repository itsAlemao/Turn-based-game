class_name CharacterAnimationTree
extends AnimationTree

func _ready() -> void:
	active = true

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
	
	
	
	
