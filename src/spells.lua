local game = require("src.game")

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

local function castFireball(target)
	if game.player.mp < 3 then
		print("you don't have enough MP to cast fireball.")
		return false
	end
	game.player.mp = game.player.mp - 3

	target.health = target.health - 20
	print("fireball was a success!!")
	if math.random(1, 100) <= 5 then
		print("but you got burned!!")
		local selfDamage = math.floor(game.player.health * 0.05)
		game.player.health = game.player.health - selfDamage
		print("you took " .. selfDamage .. " damage from the backfire!")
	end
	return true
end

local function castHealingWhisper()
	if game.player.mp < 3 then
		print("you don't have enough MP to cast healing whisper.")
		return false
	end
	game.player.mp = game.player.mp - 3

	local oldHealth = game.player.health
	game.player.health = math.min(game.player.health + 20, game.player.maxHealth)
	local healedAmount = game.player.health - oldHealth

	print("you healed " .. healedAmount .. " HP")
	print("healing whisper was a success!!")
	return true
end

return {
	fireball = spells.fireball,
	healing_whisper = spells.healing_whisper,
	castFireball = castFireball,
	castHealingWhisper = castHealingWhisper,
}
