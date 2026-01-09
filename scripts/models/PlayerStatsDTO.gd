class_name PlayerStats 
extends StatsBase

signal mana_changed(new: int, old: int)

@export_range(0, 9999) var MaxMana: int
@export_range(0, 9999) var CurMana: int:
	set(value):
		value = clamp(value, 0, CurMana)
		if value == CurMana:
			return
		var old = CurMana
		CurMana = value
		mana_changed.emit(CurMana, old)
@export_range(1,100) var Level: int
