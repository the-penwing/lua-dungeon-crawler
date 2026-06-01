# 2-Hour Dungeon Crawler Tasks — Detailed Guide

You have all the code and docs already. Pick **one or two** of these based on your available time and energy.

---

## Task 1: Finish `gameMenu()` (30-45 min) ⭐ START HERE

**Goal:** Display the game menu, show player stats and current room, and return the player's choice.

### What the Menu Should Display

When `gameMenu()` is called, the screen should show:

```
--- Room 2: A small square room. ---

Player Stats:
  Health: 85/100
  MP: 12/20
  Equipped Weapon: Rusty Sword

Game Menu:
1) Use Item
2) Change Weapon
3) Next Room
4) Prev Room
5) Rest
6) Quit to Main Menu

Enter choice (1-6):
```

### Step-by-Step Implementation

#### Step 1: Get Current Room Info
```
currentRoom = game.player.currentRoom
roomDescription = rooms[currentRoom].description
```

Use `rooms[currentRoom]` to fetch the room object, then access `.description`.

#### Step 2: Get Equipped Weapon Name
```
equippedWeaponId = game.player.equippedWeapon
equippedWeaponData = items.getItemById(equippedWeaponId)
weaponName = equippedWeaponData.name
```

You already have `items.getItemById()` — it takes an item ID string and returns the full item data with the `.name` field.

#### Step 3: Display Everything
Use `print()` to show:
- Room number and description
- Player health (current/max)
- Player MP (current/max)
- Equipped weapon name
- Menu options 1-6

#### Step 4: Get Valid Input
Loop until player enters 1-6:
```
repeat
    io.write("Enter choice (1-6): ")
    choice = tonumber(io.read())
    if choice >= 1 and choice <= 6 then
        validChoice = true
    else
        print("Invalid choice!")
    end
until validChoice == true
```

#### Step 5: Return the Choice
```
return choice
```

Return the number (1-6) so `mainLoop()` can handle it.

### Reference Code

Look at these existing functions for the pattern:

- **`src/combat/actions.lua`** — `getPlayerAction()` function shows exactly how to:
  - Display a numbered menu
  - Loop until valid input
  - Return the choice
  
- **`src/ui.lua`** — `displayGameState()` shows how to format player stats nicely
  
- **`src/rooms.lua`** — Shows room structure: `rooms[1].description`, `rooms[1].enemies`, etc.

### Common Mistake to Avoid

Don't try to implement the logic for each choice yet! Just display the menu and return the number. `mainLoop()` will handle what happens when the player picks option 3 vs option 5.

---

## Task 2: Implement Room Navigation (next/prev) (45-60 min)

**Goal:** Let the player move between rooms, with boundary checks.

### Game Rules
- Rooms are numbered 1-4 (linear progression)
- Player can move forward or backward
- Room 1: Can only go forward (to room 2)
- Rooms 2-3: Can go forward or backward
- Room 4: Can only go backward (dead end/boss room)

### What Should Happen

**If player chooses "Next Room" (choice == 3):**
```
Current room: 2
Next room would be: 3

If room 3 exists and currentRoom < 4:
  - Update game.player.currentRoom to 3
  - Show "You move to the next room..."
  - Call ui.displayRoomDescription() or print the new room's description
  - Check if room has enemies
    - If yes: Trigger combat
    - If no: Show "No enemies here."
  - Return to gameMenu()

If currentRoom == 4:
  - Print: "This is the final room. You must go back."
  - Return to gameMenu()
```

**If player chooses "Prev Room" (choice == 4):**
```
Current room: 2
Prev room would be: 1

If currentRoom > 1:
  - Update game.player.currentRoom to 1
  - Show "You move back to the previous room..."
  - Show room description
  - Check if room has enemies
    - If yes: Trigger combat
    - If no: Show "No enemies here."
  - Return to gameMenu()

If currentRoom == 1:
  - Print: "You're at the entrance. You can't go back further."
  - Return to gameMenu()
```

### Step-by-Step Implementation

#### Step 1: Check Boundaries
```
if choice == 3 then  -- Next room
    if game.player.currentRoom == 4 then
        print("This is the final room. You must go back.")
        return  -- Don't move, stay in loop
    else
        game.player.currentRoom = game.player.currentRoom + 1
    end
elseif choice == 4 then  -- Prev room
    if game.player.currentRoom == 1 then
        print("You're at the entrance. You can't go back further.")
        return
    else
        game.player.currentRoom = game.player.currentRoom - 1
    end
end
```

#### Step 2: Show New Room Description
```
print("\nYou enter a new room...")
print(rooms[game.player.currentRoom].description)
```

#### Step 3: Check for Enemies
```
local roomEnemies = rooms[game.player.currentRoom].enemies

if #roomEnemies > 0 then
    print("Oh no! " .. roomEnemies[1].name .. " is attacking you!")
    local result = combat.loop.combatLoop(roomEnemies)
    -- Handle post-combat (loot, rest, save)
else
    print("No enemies here. You rest easy.")
end
```

### Reference Code

- **`src/rooms.lua`** — Shows room structure. Access via `rooms[1]`, `rooms[2]`, etc.
- **`game.lua`** — `game.player.currentRoom` is the field you update

### Key Points

- Always update `game.player.currentRoom` **before** checking for enemies
- Use `#roomEnemies > 0` to check if the array has enemies (# is Lua's length operator)
- After combat, you'll need to handle loot and post-combat options (Task 6)

---

## Task 3: Implement Weapon Switching (45-60 min)

**Goal:** Let player equip any weapon currently in their inventory.

### What Should Happen

**If player chooses "Change Weapon" (choice == 2):**

```
Current inventory:
  - Rusty Sword (x1)
  - Healing Potion (x1)
  - Gold Coin (x5)

Weapons available to equip:
  1) Rusty Sword - Damage: 5, Hit Chance: 75%

If player picks 1:
  - "You equip the Rusty Sword!"
  - game.player.equippedWeapon = "rustysword"
  - Return to gameMenu()

If no weapons in inventory:
  - "You have no weapons to equip!"
  - Return to gameMenu()
```

### Step-by-Step Implementation

#### Step 1: Filter Weapons from Inventory
```
local weaponsInInventory = {}

for i, inventoryItem in ipairs(game.player.inventory) do
    local itemData = items.getItemById(inventoryItem.id)
    
    -- Check if this item is a weapon
    if itemData and items.items.weapons[itemData.id] then
        table.insert(weaponsInInventory, {
            index = i,
            id = inventoryItem.id,
            data = itemData
        })
    end
end
```

**Explanation:**
- Loop through `game.player.inventory` (each item has an `id` and `quantity`)
- Use `items.getItemById()` to get the full item data
- Check if the item exists in `items.items.weapons` table
- If it's a weapon, add it to your `weaponsInInventory` list

#### Step 2: Display Weapons with Stats
```
if #weaponsInInventory == 0 then
    print("You have no weapons to equip!")
    return
end

print("\nAvailable Weapons:")
for i, weapon in ipairs(weaponsInInventory) do
    print(i .. ") " .. weapon.data.name 
        .. " - Damage: " .. weapon.data.damage 
        .. ", Hit Chance: " .. weapon.data.hitChance .. "%")
end
print((#weaponsInInventory + 1) .. ") Cancel")
```

#### Step 3: Get Player's Choice
```
io.write("Choose weapon (1-" .. (#weaponsInInventory + 1) .. "): ")
local choice = tonumber(io.read())

if choice == #weaponsInInventory + 1 then
    print("Returning to menu...")
    return
elseif choice and choice >= 1 and choice <= #weaponsInInventory then
    local selectedWeapon = weaponsInInventory[choice]
    game.player.equippedWeapon = selectedWeapon.id
    print("You equipped " .. selectedWeapon.data.name .. "!")
else
    print("Invalid choice!")
end
```

### Reference Code

- **`src/items.lua`** — Shows `items.weapons` table structure
- **`src/combat/utilise.lua`** — `choiceItem()` function shows a similar pattern:
  - Filter inventory by type
  - Display options with stats
  - Get player choice
  - Apply the choice
  
This is almost identical, just replacing "consumables" with "weapons"

### Key Points

- `items.items.weapons` is a table of all weapon definitions
- To check if an item is a weapon, see if it exists in `items.items.weapons`
- `weapon.data.name`, `weapon.data.damage`, `weapon.data.hitChance` are the stats
- Always include a "Cancel" option so player can back out
- Update `game.player.equippedWeapon` with the weapon's **ID** (e.g., `"longsword"`), not the name

---

## Task 4: Implement Item Usage (60-90 min)

**Goal:** Let player use consumable items (potions) outside of combat to heal.

### What Should Happen

**If player chooses "Use Item" (choice == 1):**

```
Current inventory:
  - Rusty Sword (x1)
  - Healing Potion (x2)
  - Gold Coin (x5)

Consumable items:
  1) Healing Potion (x2)

If player picks 1:
  - "You drink a Healing Potion!"
  - Health: 75/100 → 90/100 (healed by 15 HP)
  - Inventory: Healing Potion (x1) — one consumed
  - Return to gameMenu()

If no consumables:
  - "You have no consumable items!"
  - Return to gameMenu()
```

### Step-by-Step Implementation

#### Step 1: Filter Consumables from Inventory
```
local consumables = {}

for i, inventoryItem in ipairs(game.player.inventory) do
    local itemData = items.getItemById(inventoryItem.id)
    
    -- Check if this item is a consumable
    if itemData and itemData.type == "consumable" then
        table.insert(consumables, {
            index = i,
            id = inventoryItem.id,
            quantity = inventoryItem.quantity,
            data = itemData
        })
    end
end
```

**Explanation:**
- Loop through inventory
- Get full item data with `items.getItemById()`
- Check if `itemData.type == "consumable"` (potions have this field)
- Store the consumable with its inventory index (you'll need this to remove it)

#### Step 2: Display Consumables
```
if #consumables == 0 then
    print("You have no consumable items!")
    return
end

print("\nConsumable Items:")
for i, consumable in ipairs(consumables) do
    print(i .. ") " .. consumable.data.name .. " (x" .. consumable.quantity .. ")")
end
print((#consumables + 1) .. ") Cancel")
```

#### Step 3: Get Player's Choice
```
io.write("Use item (1-" .. (#consumables + 1) .. "): ")
local choice = tonumber(io.read())

if choice == #consumables + 1 then
    return
elseif choice and choice >= 1 and choice <= #consumables then
    local selectedConsumable = consumables[choice]
    useConsumable(selectedConsumable)
else
    print("Invalid choice!")
end
```

#### Step 4: Apply Item Effect
```
local function useConsumable(consumable)
    -- Handle based on item ID
    if consumable.id == "healingpotion" then
        local healAmount = consumable.data.heal  -- Should be 15
        game.player.health = math.min(
            game.player.health + healAmount,
            game.player.maxHealth
        )
        print("You drank a " .. consumable.data.name .. "!")
        print("Health restored to " .. game.player.health .. "/" .. game.player.maxHealth)
    end
    
    -- Decrement quantity in actual inventory
    local inventorySlot = game.player.inventory[consumable.index]
    inventorySlot.quantity = inventorySlot.quantity - 1
    
    -- Remove if empty
    if inventorySlot.quantity == 0 then
        table.remove(game.player.inventory, consumable.index)
    end
end
```

### Reference Code

- **`src/combat/utilise.lua`** — Has `choiceItem()` and `useItem()` functions
  - `choiceItem()` filters inventory and gets choice (copy this)
  - `useItem()` applies the effect and removes from inventory (copy this logic)
- **`src/items.lua`** — `healing_potion` has `type = "consumable"` and `heal = 15`

### Key Points

- Healing potion heals **15 HP** (not 20), cap at max health
- Always use `math.min()` to prevent healing over max
- Store the inventory **index** so you can remove the item after using it
- Decrement quantity, and remove the slot if quantity reaches 0
- You can literally copy-paste most of `src/combat/utilise.lua`

---

## Task 5: Implement Resting (30-45 min)

**Goal:** Let player rest in a room to heal and regain MP.

### What Should Happen

**If player chooses "Rest" (choice == 5):**

```
Before rest:
  Health: 60/100
  MP: 5/20

After rest:
  "You take a moment to rest..."
  Health: 66/100 (60 + 10% = 66)
  MP: 6/20 (5 + 5% = 5.25 → 5, rounded down)
  
Then return to gameMenu()
```

### Step-by-Step Implementation

#### Step 1: Calculate Healing
```
if choice == 5 then  -- Rest
    -- Heal 10% of current health
    local healAmount = math.floor(game.player.health * 0.10)
    game.player.health = game.player.health + healAmount
    
    -- Cap at max
    game.player.health = math.min(game.player.health, game.player.maxHealth)
```

**Explanation:**
- `math.floor()` rounds down (so 60 * 0.10 = 6 HP healed)
- Add to current health
- Use `math.min()` to cap at max health

#### Step 2: Calculate MP Regen
```
    -- Regen 5% of current MP
    local mpRegenAmount = math.floor(game.player.mp * 0.05)
    game.player.mp = game.player.mp + mpRegenAmount
    
    -- Cap at max
    game.player.mp = math.min(game.player.mp, game.player.maxMP)
```

#### Step 3: Display Result
```
    print("\nYou rest for a moment...")
    print("Health: " .. game.player.health .. "/" .. game.player.maxHealth)
    print("MP: " .. game.player.mp .. "/" .. game.player.maxMP)
end
```

### Reference Code

- **`src/combat/loop.lua`** — `regenMP()` function shows the MP regen pattern
  - Uses `math.min()` to cap at max

### Key Points

- Use `math.floor()` to round down (standard in games)
- Health heals by **10%** of current health
- MP regens by **5%** of current MP
- Always cap results at max values
- This is the simplest task — about 10 lines of code

---

## Task 6: Post-Combat Flow (90-120 min) ⭐ MOST COMPLEX

**Goal:** After combat ends, show loot, let player use items/rest/save, then return to menu.

### What Should Happen

```
=== COMBAT VICTORY ===
You defeated: Bat, Bat, Goblin

Loot Gained:
  - Gold Coin (x2)
  - Gold Coin (x1)

Current Status:
  Health: 45/100
  Potions: 1

Post-Combat Menu:
1) Use Item
2) Rest
3) Save Game
4) Continue

Enter choice (1-4):
```

### Step-by-Step Implementation

#### Step 1: Show Defeated Enemies
```
local function displayPostCombatSummary(defeatedEnemies)
    print("\n=== VICTORY ===")
    print("You defeated:")
    for _, enemy in ipairs(defeatedEnemies) do
        print("  - " .. enemy.name)
    end
end
```

Wait — there's a problem. Your combat system **removes** enemies from the array as they die. So you won't have the defeated enemy list.

**Solution:** Either:
- A) Modify `combat/loop.lua` to track defeated enemies
- B) For now, just print "You won!" and move on

For your first pass, do option B:
```
local function showPostCombatFlow()
    print("\n=== VICTORY ===")
    print("Combat ended! You won.")
    print("\nCurrent Status:")
    print("  Health: " .. game.player.health .. "/" .. game.player.maxHealth)
    
    -- Count potions
    local potionCount = 0
    for _, item in ipairs(game.player.inventory) do
        if item.id == "healingpotion" then
            potionCount = item.quantity
            break
        end
    end
    print("  Potions: " .. potionCount)
    
    print("\nPost-Combat Menu:")
    print("1) Use Item")
    print("2) Rest")
    print("3) Save Game")
    print("4) Continue to Room")
    
    io.write("Enter choice (1-4): ")
    local choice = tonumber(io.read())
    return choice
end
```

#### Step 2: Handle Post-Combat Choices
```
repeat
    local postChoice = showPostCombatFlow()
    
    if postChoice == 1 then
        -- Call your useItem() logic (from Task 4)
        choiceItem()
    elseif postChoice == 2 then
        -- Call your rest logic (from Task 5)
        -- Heal 10%, regen 5% MP
    elseif postChoice == 3 then
        -- Save game
        require("src.save").saveGame("savegame.json")
        print("Game saved!")
    elseif postChoice == 4 then
        -- Exit post-combat, return to gameMenu()
        break
    end
until false
```

#### Step 3: Call from mainLoop()
In your `mainLoop()`, after combat:
```
if #roomEnemies > 0 then
    local result = combat.loop.combatLoop(roomEnemies)
    if result then  -- Player won
        showPostCombatFlow()  -- Loop until they choose to continue
    else  -- Player died
        print("You died!")
        return  -- Return to main menu
    end
end
```

### Reference Code

- **`src/save.lua`** — `saveGame()` function. Call it with `saveGame("savegame.json")`
- **Task 4 & 5** — Reuse your item usage and rest logic

### Key Points

- Post-combat is a **loop**, not a single choice
- Player can use items, rest multiple times before continuing
- If player dies, return to main menu (game over)
- Save the game before or after, doesn't matter much
- You'll iterate on this once you playtest

---

## Recommended Order

1. **Task 1: gameMenu()** ← Do this first, everything depends on it
2. **Task 2 or 3** ← Either room navigation or weapon switching (either order)
3. **Task 4 or 5** ← Item usage or resting (either order)
4. **Task 6** ← Post-combat flow (only after core menu works)

**Estimated times:**
- Task 1: 30 min
- Tasks 2-5: 45-60 min each
- Task 6: 90 min

In 2 hours, you can likely complete Tasks 1-3. That gets you a playable skeleton!

---

## Testing as You Go

After each task, test it in `main.lua`:

```lua
-- After Task 1 only:
mainLoop()  -- Test gameMenu() displays correctly

-- After Task 2 added:
mainLoop()  -- Test room movement and boundary checks

-- After Task 3 added:
mainLoop()  -- Equip a weapon, check game.player.equippedWeapon updates
```

Print debug info if needed:
```lua
print("DEBUG: currentRoom = " .. game.player.currentRoom)
print("DEBUG: equippedWeapon = " .. game.player.equippedWeapon)
```

---

## Files You'll Edit

- `main.lua` — Add all the functions here

## Files You'll Reference (don't edit)

- `src/game.lua` — Player state
- `src/rooms.lua` — Room data
- `src/items.lua` — Item definitions
- `src/combat/` — Combat system
- `src/save.lua` — Save/load functions
- `src/ui.lua` — Display functions

Good luck! You've got this.