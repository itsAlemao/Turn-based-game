## The Health bar of a player.  
## For position manipulation: the pivot is always in the middle 
class_name HealthBarNode
extends Node

var max_health: int
var cur_health: int
var orig_scale: float

@onready var health_node: Sprite2D = $Health

func set_max_health(max_health_: int):
	max_health = max_health_
	cur_health = max_health_
	
func _ready() -> void:
	orig_scale = health_node.scale.x
	
	#test
	#set_max_health(100)
	#var timer = Timer.new()
	#add_child(timer)
	#timer.wait_time = 1.0
	#timer.one_shot = true
	#timer.start(1.0)
	#timer.timeout.connect(func(): take_damage(50))
	

func take_damage(dmg: int):
	cur_health -= dmg
	
	#Update width of the bar in order to match the ratio between current and max health
	var new_scale = float(cur_health)/max_health*orig_scale
	health_node.scale.x = new_scale
	
	#Play animation fo the damage bar to reduce to the width of the health
	var t: Tween = get_tree().create_tween()
	var prop = t.tween_property($Damage, "scale", Vector2(new_scale, orig_scale), 1.0)
	prop.set_delay(1.0)

## Returns the rect of the bar
func rect() -> Rect2:
	return $Container.get_rect()
