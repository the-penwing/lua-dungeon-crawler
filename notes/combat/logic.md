#logic
# Combat Logic
Combat is turn-based:
1. Player chooses an action (Attack, Cast Spell, Use Item, Flee)
2. Player executes action
3. Enemy takes damage (if attacked) or player heals (if item used)
4. Enemy attacks back (if still alive)
5. Repeat until enemy dead or player flees/dies

**Think about what functions you need:**

1. `playerAttack(enemy)` – Player attacks an enemy, deals damage
2. `useItem(itemName)` – Player uses a consumable (healing potion)
3. `enemyAttack(enemy)` – Enemy attacks player, deals damage
4. `combat(enemy)` – Main combat loop that calls the above


**Figure Out**
1. How does the player choose an action? (Text input, menu, etc.)
  - Menu
2. How do you handle weapon damage? (Look up in items table?)
  - Look up damage in table and percentage chance of hits for each type of attack
3. What happens if the player tries to flee? (Always succeeds? Percentage chance?)
  - 75% Fail Rate


**On weapon damage + hit chance:**
- When player attacks, what weapon are they using? 
  - track equipped weapon in `game.player`
- Each weapon has different damage—how do you look it up?
  - Store Weapon Referance

**Weapons**:
- Rusty Sword 75%
- Bow 80%
- Longsword 95%
**Spells**:
- Fireball (20DMG with a 5% chance of 5% Damage to self) 95%
- Healing Whisper (Self) 100%

**On flee:**
- 25% fail rate means 75% success rate
- When flee fails, does enemy still get a turn? Or does player take damage and stay in combat?
  - Enemy Still Gets A Turn
- When flee succeeds, does player get teleported to previous room or just escape the combat loop?
  - previous room

**On the menu:**
- What are the exact options? (Attack, Use Item, Flee, ... anything else?)
  - Attack
  - Use Item
  - Spell
  - Flee
- How does player select? (Type number? Type word?)
  - Number

**Also, tracking equipped weapon:**
- Right now `game.player.inventory` has all items mixed. How do you know which weapon is equipped?
  - Add `game.player.equippedWeapon` field

**First question:** For `enemyAttack(enemy)`, do you want:
- All enemies have a **single hit chance** (like 80%)?
- Or does each enemy type (bat, goblin, skeleton, dragon) have their own hit chance?

- Bat 65%
- Goblin 70%
- Skeleton 75%
- Dragon 80%

Looking at your `enemies.lua`, I only see `damage` defined, no `hitChance`. So:

**Do you need to:**
1. Add a `hitChance` field to each enemy in `enemies.lua`?
Yes
2. Then update `enemyAttack()` to use it?
Yes

**And for the Dragon's two attacks:**
- When Dragon attacks, does it randomly pick between "small" (5 DMG) and "big" (15 DMG)?
- Or does it alternate? Or something else?

- Small
- Small
- Small
- Big

