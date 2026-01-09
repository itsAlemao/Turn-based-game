extends Node2D

var max_health: int
var cur_health: int
var orig_scale: float

func set_max_health(max_health_: int):
	max_health = max_health_
	cur_health = max_health_
	
func _ready() -> void:
	orig_scale = $Health.scale.x
	set_max_health(100)
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
	$Health.scale.x = new_scale
	
	#Play animation fo the damage bar to reduce to the width of the health
	var t: Tween = get_tree().create_tween()
	var prop = t.tween_property($Damage, "scale", Vector2(new_scale, orig_scale), 1.0)
	prop.set_delay(1.0)
