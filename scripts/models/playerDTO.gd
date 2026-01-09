class_name Player extends Character

## Player's attacks
@export var Attacks: Array[PlayerAttack]

## Player's stats
@export var Stats: PlayerStats

func stats() -> StatsBase:
	return Stats

func characterResource() -> Character:
	return null
	
func attacks() -> Array:
	return Attacks
