local game = require("src.game")
local actions = require("src.combat.actions")
local casting = require("src.combat.casting")
local utilise = require("src.combat.utilise")
local enemy_module = require("src.combat.enemy")
local ui = require("src.ui")

local function regenMP()
	game.player.mp = math.min(game.player.mp + 2, game.player.maxMP)
end

local function combatLoop(enemies)
	while #enemies > 0 and game.player.health > 0 do
		-- 1. Display state and clear spell spell cooldown
		ui.displayCombatState(enemies)

		-- 2. Get player action (1-4)
		local choice = actions.getPlayerAction()
		local actionFinished = false
		-- 3. Execute action based on choice
		if choice == 1 then
			actionFinished = actions.choiceAttack(enemies)
		elseif choice == 2 then
			actionFinished = casting.choiceSpell(enemies)
		elseif choice == 3 then
			actionFinished = utilise.choiceItem()
		elseif choice == 4 then
			if actions.attemptFlee() then
				game.player.health = math.ceil(game.player.health * 1.5)
				return "fled"
			end
			-- If flee fails, just continue to enemy turn
		end

		-- 4. Enemy turn (if enemies remain and action compleated)
		if actionFinished then
			for _, enemy in ipairs(enemies) do
				enemy_module.enemyAttack(enemy)
			end
		end
		if choice ~= 2 then
			game.player.spellCooldown = false
		end

		-- Regen MP every turn
		regenMP()
	end

	-- After loop: check result
	if game.player.health <= 0 then
		return false
	else
		return true
	end
end
return {
	regenMP = regenMP,
	combatLoop = combatLoop,
}
