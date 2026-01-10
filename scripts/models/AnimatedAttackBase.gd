@tool
class_name AnimatedAttackBase
extends Resource


@export var ranged_attack: bool = true:
	set(value):
		ranged_attack = value
		# This tells the editor to refresh the Inspector layout
		notify_property_list_changed()
		
# Frame where animation hits
@export var hit_frame: int

# We do NOT use @export here, because we handle it manually below
var bullet_animation: SpriteFrames

func _get_property_list() -> Array:
	var properties = []
	# Only add the bullet_animation property if ranged_attack is true
	if ranged_attack:
		properties.append({
			"name": "propName",
			"type": PROPERTY_USAGE
		})
	
	return properties
