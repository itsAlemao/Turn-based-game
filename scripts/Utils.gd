extends Node

class Action:
	const COLOR_DEFAULT: Color = "#00000000" #transparent
	const COLOR_SELECTED: Color = "#63606d91" #yellow-ish
	const COLOR_ACTIVATED: Color = "#8a7d6b7f" #brown-ish

func xprint_verbose(slf: Object, ...args):
	var className = slf.get_class()
	var msg = " ".join(args) 
	print_verbose(className, ": ", msg)
