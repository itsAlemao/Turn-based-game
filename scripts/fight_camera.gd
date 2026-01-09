extends Camera2D
class_name FightCamera

# Margins and gap for health bars, will be multiplied by the bar's scale
const BOTTOM_MARGIN_PX = 5
const LEFT_MARGIN_PX = 5
const GAP_PX = 5

var bottom_left_corner
var n_bars = 0

func _ready() -> void:
	var corner: Vector2 = self.position
	var size = self.get_viewport_rect().size
	corner.x -= size.x/2
	corner.y += size.y/2
	bottom_left_corner = corner

	#testing
	#var t = Timer.new()
	#t.one_shot = true
	#add_child(t)
	#t.start(1.0)
	#t.timeout.connect(func():
		#var a: Resource = load("res://scenes/health_bar.tscn")
		#var b = a.instantiate()
		#var c = a.instantiate()
		#add_bar(b)
		#add_bar(c)
		#print("Barra aggiunta a", b.rect())
	#)

## Adds a bar to the camera, it is assumed that the bar is already of the right scale
func add_bar(bar_node: HealthBarNode):
	
	#Positioning the bar in the bottom left, and giving it a margin of half its length + cusotm margin, 
	#The calculated margin is then multiplied by scale
	
	#Gap is added from the second bar
	var gap =  GAP_PX * int(n_bars > 0)
	# previous bars  occupy the space of a whole bar + the gap.  
	var previous_bars_px = n_bars * (gap + bar_node.rect().size.x / (2 if n_bars == 0 else 1)) 
	var pos: Vector2 = Vector2(
		bottom_left_corner.x + ((bar_node.rect().size.x/2 + LEFT_MARGIN_PX + previous_bars_px) * bar_node.scale.x),
		bottom_left_corner.y - ((bar_node.rect().size.y/2 + BOTTOM_MARGIN_PX) * bar_node.scale.x)
	)
	print("size: ", bar_node.rect())
	print("Bar center position: ", pos)
	self.add_child(bar_node)
	bar_node.position = pos
	n_bars += 1
