extends Control
class_name ActionControl

signal action_decided(att: PlayerAnimatedAttack)

@onready var base_actions: VBoxContainer = $BaseAction
@onready var specific_actions: VBoxContainer = $SpecificAction
@onready var attack_action: Control = $BaseAction/AttackAction
@onready var strumenti_action: Control = $BaseAction/StrumentiAction

var optionScene = preload("res://scenes/action_option.tscn")

# dati per gestire la selezione
var _base_index: int = 0
var _base_active: bool = false
var _spec_index: int
 # array for resources of base attacks, stored in the same order as the children nodes
var _base_ch: Array
 # array for resources of specific attacks, stored in the same order as the children nodes
var _spec_ch: Array[Attack]
var _base_count: int 
var _spec_count: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_base_ch = base_actions.get_children().filter(func(e): return e is ActionOption)
	_base_count = _base_ch.size()
	_base_ch[0].setSelected()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		
	if Input.is_action_just_pressed("menu_up"):
		Utils.xprint_verbose(self, "Menu up")
		if _base_active:
			_spec_ch.get(_spec_index).node.setDefault()
			_spec_index = posmod(_spec_index+1, _spec_count)
			_spec_ch.get(_spec_index).node.setSelected()
		else:
			_base_ch.get(_base_index).setDefault()
			_base_index = posmod(_base_index+1, _base_count)
			_base_ch.get(_base_index).setSelected()
			
	if Input.is_action_just_pressed("menu_down"):
		Utils.xprint_verbose(self, "Menu down")
		if _base_active:
			_spec_ch.get(_spec_index).node.setDefault()
			_spec_index = posmod(_spec_index-1, _spec_count)
			_spec_ch.get(_spec_index).node.setSelected()
		else:
			_base_ch.get(_base_index).setDefault()
			_base_index = posmod(_base_index-1, _base_count)
			_base_ch.get(_base_index).setSelected()
			
	if Input.is_action_just_pressed("menu_enter"):
		Utils.xprint_verbose(self, "Menu enter")
		if _base_active:
			action_decided.emit(_spec_ch.get(_spec_index).res)
			hide()
		else:
			_base_ch.get(_base_index).setActive()
			_base_active = true
			_spec_index = 0
			_spec_ch.get(_spec_index).node.setSelected()
			specific_actions.show()
			# show other attacks
			
	if Input.is_action_just_pressed("menu_back"):
		Utils.xprint_verbose(self, "Menu back")
		if _base_active:
			_spec_ch.get(_spec_index).node.setDefault()
			specific_actions.hide()
			_base_active = false
			
			
## Sets the current attacks avaliable for the player
func setAttacks(attacks: Array[PlayerAnimatedAttack]):
	#clears spefific actions
	for c in specific_actions.get_children():
		specific_actions.remove_child(c)
	
	# adds attacks to the specific container
	for att in attacks:
		var n: ActionOption = optionScene.instantiate()
		specific_actions.add_child(n)	
		n.load_data(att.attack.option)
		_spec_ch.append(Attack.new(n, att))
		
	_spec_count = _spec_ch.size()
	_spec_index = 0
		
		
class Attack:
	var node: ActionOption
	var res: PlayerAnimatedAttack
	func _init(n: ActionOption, r: PlayerAnimatedAttack) -> void:
		node = n
		res = r
