local spells = {
	fireball = {
		name = "Fireball",
		description = "a ball of fire that shoots out of your hand dealing massive damage.",
		damage = 20,
		heal = 0,
		backfireChance = 5,
		cost = 3,
		effectType = "damaging",
	},
	healing_whisper = {
		name = "Healing Whisper",
		description = "you hear a calming voice that heals your wounds",
		damage = 0,
		heal = 20,
		backfireChance = 0,
		cost = 3,
		effectType = "healing",
	},
}

return spells
