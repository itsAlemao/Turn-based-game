extends Character
class_name EnemyDTO

@export var _stats: EnemyStatsResource
@export var _attacks: Array[EnemyAttackDTO]

func stats() -> StatsBase:
	return _stats
	
func attacks() -> Array[EnemyAttackDTO]:
	return _attacks
