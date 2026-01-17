extends Node

const DEFAULT_FRAME_SPEED: float = 7.0

class Action:
	const COLOR_DEFAULT: Color = "#00000000" #transparent
	const COLOR_SELECTED: Color = "#63606d91" #yellow-ish
	const COLOR_ACTIVATED: Color = "#8a7d6b7f" #brown-ish

func xprint_verbose(slf: Object, ...args):
	var className = slf.get_class()
	var msg = " ".join(args) 
	print_verbose(className, ": ", msg)

## Creates an Animation object, if no anim_name is provided, it will use the first name it finds in the SpriteFrames
func create_animation(frames: SpriteFrames, anim_name: String = frames.get_animation_names().get(0), fps: float = DEFAULT_FRAME_SPEED) -> Animation:
	# create Animation
	var anim := Animation.new()
	anim.loop_mode = Animation.LOOP_NONE
	var track_index: int = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_index, "AnimatedSprite2D:frame")
	anim.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)

	# Populate keys from SpriteFrames
	var frame_count = frames.get_frame_count(anim_name)
	print("frame_count: ", frame_count)
	var duration_per_frame = 1.0 / fps
	for i in range(frame_count):
		var time = i * duration_per_frame
		anim.track_insert_key(track_index, time, i)

	# set length
	anim.length = frame_count * duration_per_frame
	
	return anim
