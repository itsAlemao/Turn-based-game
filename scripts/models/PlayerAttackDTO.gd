class_name PlayerAttack 
extends AttackBase

## Name of the attack
@export var Name: String

## Mana cost of the attack
@export_range(0,100) var ManaCost: int

## The icon displayed on the option
@export var icon: Texture2D

var option: AttackOption:
	get():
		var res = AttackOption.new()
		res.icon = icon
		res.mana_cost = ManaCost
		res.name = Name
		res.type = ActionOption.Type.DO_SOMETHING
		return res

#func getOption() -> AttackOption:
