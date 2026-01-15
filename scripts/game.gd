extends Node

var queue: Array = []
var n_players: int
var n_enemies: int 


@onready var players: Node = $Characters/Players
@onready var enemies: Node = $Characters/Enemies
@onready var camera: FightCamera = $FightCamera

var actionControlScene = preload("res://scenes/actionControl.tscn")
var healthBarScene = preload("res://scenes/health_bar.tscn")
var targetIndicatorScene = preload("res://scenes/target_indicator.tscn")

## the character doing the action
var cur_character: CharacterNode
## The position in which the character is registered, when he moves around he then needs to come back here
var cur_character_pos: Vector2

## the attack being used by a player
var player_attack: PlayerAnimatedAttack

## The attack being used by an enemy
var enemy_attack: EnemyAttackDTO

## if true, starts listening for user input to choose the target 
var is_choosing_target: bool
## Emitted when the user selects the target
signal target_selected
## the target of the attack
var target: ChPos
## Sprite that displays the currently selected target
var indicator_node: TargetIndicator

## the turns passed in the current round
var turns = 0

## the rounds passed
var rounds = 0


## Array of possible positions for players
var p_pos: Array[ChPos] = [
	ChPos.new(Vector2(-388, 198), 0),
	ChPos.new(Vector2(-588, 77), 1),
	ChPos.new(Vector2(-528, 352), 2),
	ChPos.new(Vector2(-450, -70), 3),
]

## Array of possible positions for enemies 
var e_pos: Array[ChPos] = [
	ChPos.new(Vector2(518, 352), 0),
	ChPos.new(Vector2(378, 198), 1),
	ChPos.new(Vector2(598, 77), 2),
	ChPos.new(Vector2(460, -70), 3),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		
	print("Fight started!")
	n_players = players.get_child_count(false)
	n_enemies = enemies.get_child_count(false)
	
	players.child_entered_tree.connect(_setup_new_character)
	players.child_exiting_tree.connect(_remove_character)
	enemies.child_entered_tree.connect(_setup_new_character)
	enemies.child_exiting_tree.connect(_remove_character)
	
	for p in players.get_children():
		if p is PlayerNode:
			_setup_new_character(p)
	for e in enemies.get_children():
		if e is SlimeNode:
			_setup_new_character(e)

	await get_tree().create_timer(1).timeout
	process_fight()

func _process(_delta: float) -> void:
	if is_choosing_target:
		if Input.is_action_just_pressed("menu_down"):
			_change_target(Direction.DOWN)
		if Input.is_action_just_pressed("menu_up"):
			_change_target(Direction.UP)
		if Input.is_action_just_pressed("menu_enter"):
			is_choosing_target = false
			indicator_node.queue_free()
			target_selected.emit()
			
# Moves the selection of the target up and down, can be used for players and enemies
func _change_target(dir: Direction):
	var direction: int = 1 if dir == Direction.DOWN else -1
	var arr = e_pos if cur_character is PlayerNode else p_pos
	var idx: int = target.spacial_idx
	var next_target: ChPos
	while true: # if there is no character on that space, the function will be called recursively until a character is found
		idx += direction
		next_target = arr[posmod(idx, arr.size())]
		if next_target.ch != null:
			break
			
	target.ch.remove_child(indicator_node)
	next_target.ch.add_child(indicator_node)
	target = next_target

## Creates a new queue, ordering entities by speed
func fill_queue():
	turns = 0
	queue.clear()
	queue.append_array(players.get_children())
	queue.append_array(enemies.get_children())
	#print(queue[1].player.get_stats().Speed)
	queue.sort_custom(func(a: CharacterNode,b: CharacterNode): return a.characterResource().stats().Speed > b.characterResource().stats().Speed)


## main function that runs the fight
func process_fight():
	while n_players != 0 and n_enemies != 0:
		
		turns += 1
		# when everyone played their turn, a new queue is created
		if queue.is_empty():
			fill_queue()
			rounds += 1
		
		# select the next entity to act
		cur_character = queue.pop_front()
		print(cur_character.characterResource().Character_name, "'s turn")
		_move_to_attack_pos(cur_character)
		await get_tree().create_timer(0.5).timeout
		
		#select the attack
		var ac: ActionControl
		if cur_character is SlimeNode:
			var att: Array = cur_character.characterResource().attacks()
			enemy_attack = att.get(randi() % att.size()) #extract a random attack
		else:
			ac = actionControlScene.instantiate()
			_adjustPosition(ac)
			camera.add_child(ac)
			ac.setAttacks(cur_character.characterResource().attacks())
			ac.action_decided.connect(func(att: PlayerAnimatedAttack): player_attack=att)
			await ac.action_decided
			print("Attack: ", player_attack.attack.Name)
		
		#select the target
		if cur_character is SlimeNode:
			while true:
				target = p_pos[posmod(randi(), p_pos.size())]
				if target.ch != null:
					break
			
		else:
			indicator_node = targetIndicatorScene.instantiate()
			target = e_pos[0]
			target.ch.add_child(indicator_node)
			is_choosing_target = true
			await target_selected
			indicator_node.queue_free()
				
		print("Target selcted, prepare for firing...")
		await get_tree().create_timer(1.5).timeout	
		
		_fire()
		await get_tree().create_timer(0.5).timeout
		_return_to_original_pos(cur_character)
		await get_tree().create_timer(0.5).timeout
		
		# free resources
		if ac != null: # if i instantiated that node
			ac.queue_free()
			
		
		# clearing variables for next turn
		cur_character = null
		cur_character_pos = Vector2.ZERO
		player_attack = null
		enemy_attack = null
		target = null
			
			
	if n_players == 0:
		print("You lose! (how lol)")
	if n_enemies == 0:
		print("You win!")
	
	
const PLAYER_ATT_POS = Vector2(-109.0, 141.0)
const ENEMY_ATTACK_POS = Vector2(96.0, 146.0)
# Moves the node to the spot from which they will perform their action
func _move_to_attack_pos(node: CharacterNode):
	cur_character_pos = node.position
	var t: Tween = get_tree().create_tween()
	if node is PlayerNode:
		t.tween_property(node, "position", PLAYER_ATT_POS, 0.5)
	if node is SlimeNode:
		t.tween_property(node, "position", ENEMY_ATTACK_POS, 0.5)


# Returns the node to its original position 
func _return_to_original_pos(node: CharacterNode):
	var t: Tween = get_tree().create_tween()
	t.tween_property(node, "position", cur_character_pos, 0.5)

# fires the chosen attack from the current character to the target, then assigns the fields to null
func _fire() -> void:

	if player_attack != null:
		(cur_character as PlayerNode).change_animation(player_attack.attack.Name)

	var dmg: int = player_attack.attack.Damage if player_attack != null else enemy_attack.Damage
	target.ch.characterResource().stats().CurHealth -= dmg
	
	print("Attack (", 
	player_attack.attack.Name if cur_character.is_in_group("players") else "???",
	") has been fired from ", cur_character.characterResource().Character_name, " to ", target.ch.characterResource().Character_name)

	
# adjusts the position of the action menu
func _adjustPosition(node: ActionControl):
	node.position.x = -614.0
	node.position.y = -332.0
	

func _setup_new_character(node: CharacterNode):
	if node is PlayerNode:
		n_players += 1
		_add_bar(node)

	if node is SlimeNode: #all enemies are slimes...
		n_enemies += 1
	
	_set_position(node)


func _remove_character(node: CharacterNode):
	node.queue_free()
	
	if node is PlayerNode:
		n_players -= 1
		
	if node is SlimeNode: #all enemies are slimes...
		n_enemies -= 1


# sets the node coordinates, used when adding a new node and not having a proper position for it
func _set_position(node: CharacterNode):
	if node is PlayerNode:
		for p in p_pos:
			if p.ch == null:
				node.position = p.pos
				p.ch = node
				break
				
	if node is SlimeNode:
		for p in e_pos:
			if p.ch == null:
				node.position = p.pos
				p.ch = node
				break
		
func _add_bar(player_node: PlayerNode):
	var bar_node: HealthBarNode = healthBarScene.instantiate()
	bar_node.scale = Vector2(4,4)
	bar_node.set_max_health(player_node.characterResource().stats().MaxHealth)
	player_node.characterResource().stats().health_changed.connect(func(new, old): bar_node.take_damage(old-new))
	camera.add_bar(bar_node)


class ChPos:
	var pos: Vector2
	var spacial_idx: int
	var ch: CharacterNode
	func _init(pos_: Vector2, spacial_idx_: int, ch_ : CharacterNode = null) -> void:
		pos = pos_
		spacial_idx = spacial_idx_
		ch = ch_

enum Direction { UP, DOWN }
