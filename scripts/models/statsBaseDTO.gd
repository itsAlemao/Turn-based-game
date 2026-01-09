class_name StatsBase
extends Resource

signal health_changed(new: int, old: int)

@export_range(0, 9999) var MaxHealth: int
@export_range(0, 9999) var CurHealth: int:
	set(value):
		value = clamp(value, 0, MaxHealth)
		if value == CurHealth:
			return
		var old = CurHealth
		CurHealth = value
		health_changed.emit(CurHealth, old)
@export_range(0, 9999) var Attack: int
@export_range(0, 9999) var Defense: int
@export_range(0, 9999) var Speed: int
