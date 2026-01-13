@tool
class_name AnimatedAttackBase
extends Resource


@export var characterAnimation: SpriteFrames
@export var hitFrame: int
# toggles on and off the ranged related fields
var rangedIsRanged: bool = false:
	set(value):
		rangedIsRanged = value
		notify_property_list_changed()

var rangedProjectileAnimation: SpriteFrames
var rangedStartingFrame: int

func _get_property_list() -> Array:
	var arr: Array = []

	arr.append({
		"name": "Ranged",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "ranged"
	})

	arr.append({
		"name": "rangedIsRanged",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_DEFAULT,
	})

	if rangedIsRanged:
		arr.append({
			"name": "rangedProjectileAnimation",
			"type": TYPE_OBJECT,
			"hint": PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string": "SpriteFrames",
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		arr.append({
			"name": "rangedStartingFrame",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
		})

	return arr
