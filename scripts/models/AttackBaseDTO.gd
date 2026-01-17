## Base class for attacks, common to players and enemies
@abstract class_name AttackBase
extends Resource

@export_range(0,9999) var Damage: int

@abstract func ch_anim_name() -> String

@abstract func proj_anim_name() -> String
