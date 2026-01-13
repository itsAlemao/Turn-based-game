class_name Player extends Character

## Player's attacks
@export var Attacks: Array[PlayerAnimatedAttack]

## Player's stats
@export var Stats: PlayerStats

func stats() -> StatsBase:
	return Stats
	
func attacks() -> Array:
	return Attacks
