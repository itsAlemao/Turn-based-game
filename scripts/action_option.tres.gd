class_name ActionOption
extends Control

enum Type{
	DO_SOMETHING,
	SHOW_MORE_ACTIONS
}

@export var icon: Texture2D
@export var option_name: String
@export_group("Action")
@export var action_type: Type = Type.SHOW_MORE_ACTIONS
@export_range(0,100) var mana_cost: int

@onready var action_icon_node: TextureRect = $HBoxContainer/ActionIcon
@onready var name_node: Label = $HBoxContainer/Name
@onready var mana_cost_node: Label = $HBoxContainer/ManaCost
@onready var mana_icon: TextureRect = $HBoxContainer/manaIcon
@onready var mana_icon_placeholder: VSeparator = $HBoxContainer/VSeparator ## TODO inutile
@onready var background: ColorRect = $Background

var selected: bool = false
var activated: bool = false

func _ready() -> void:		
	Utils.xprint_verbose(self, "Option ", self.name, ": _ready()")
	var opt = AttackOption.new()
	opt.icon = icon
	opt.name = option_name
	opt.mana_cost = mana_cost
	opt.type = action_type
	load_data(opt)
		
## Loads data into the child nodes, so they can display it
func load_data(dto: AttackOption):
	
	name_node.text = dto.name
	action_icon_node.texture = dto.icon

	if (dto.type == 0):
		if (dto.mana_cost == 0):
			mana_icon.hide()
			mana_icon_placeholder.hide()
			mana_cost_node.text = "Free"
		else:
			mana_icon.show()
			mana_icon_placeholder.hide()
			mana_cost_node.text = str(dto.mana_cost)
	else: # not a real action, it will show more actions
		mana_cost_node.hide()
		mana_icon.hide()
		mana_icon_placeholder.hide()
	
func setSelected() -> void:
	background.color = Utils.Action.COLOR_SELECTED
	
func setActive() -> void:
	background.color = Utils.Action.COLOR_ACTIVATED

func setDefault() -> void:
	background.color = Utils.Action.COLOR_DEFAULT
