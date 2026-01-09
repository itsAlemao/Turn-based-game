## Attach this node to a sprite2D or AnimatedSprite2D in order to display it on top of the sprite
class_name TargetIndicator
extends Sprite2D

## pixels between this sprite and the entity, will be multiplied by the scale property
@export var GAP_PX: int = 3

## How much does the sprite moves in the animation
const ANIM_WIDTH_PX := 5

func _ready() -> void:
	var node = get_parent()
	
	if node is Sprite2D:
		var r = node.get_rect()
		position = Vector2(0, r.position.y - (GAP_PX + get_rect().size.y/2) * scale.y)
	if node is AnimatedSprite2D: # assuming animated sprite has the same height in all frames
		var anim: String = node.animation
		var height = node.sprite_frames.get_frame_texture(anim, 0).get_height()
		position = Vector2(0, - height/2 - (GAP_PX + get_rect().size.y/2) * scale.y)
	
	_up()

# moves up the sprite
func _up():
	var t := get_tree().create_tween()
	await t.tween_property(self, "position", Vector2(position.x, position.y - (ANIM_WIDTH_PX * scale.y)), 0.5).finished
	_down()

# moves down the sprite
func _down():
	var t := get_tree().create_tween()
	await t.tween_property(self, "position", Vector2(position.x, position.y + (ANIM_WIDTH_PX * scale.y)), 0.5).finished
	_up()
