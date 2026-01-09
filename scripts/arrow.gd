extends Sprite2D

@export var ref: Sprite2D 

## Scale of this sprite
@export var SCALE: int = 4
## pixels between this sprite and the entity, will be multiplied by the SCALE property
@export var GAP: int = 0

func _ready() -> void:
	if ref != null:
		ref.texture.get_height()
		var r: Rect2 = Utils.get_global_rect(ref)
		var upper_y = r.get_center().y * texture.get_height()/2
		
