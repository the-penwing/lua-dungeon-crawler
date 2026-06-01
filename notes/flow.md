#logic 
AFTER COMBAT (if player wins):
  1. Show defeated enemies
  2. Show loot dropped
  3. Add loot to inventory
  4. Display: "current health: X/Y  |  potions: Z"
  5. Show Game menu

main menu
1) new game
2) load save file
3) exit

game menu
1) use item
2) change weapon
3) next room
4) prev room
5) rest
6) return to main men

   - B) Only move forward/backward from current room (so from room 2, you can go to 1 or 3)?

2. **When you "rest"** — After resting, does the player:
   - A) Stay in the current room and return to game menu?

3. **"Use item"** in the game menu — This should only show consumables (potions), right? Same logic as in-combat item usage?

4. **"Next room" / "Prev room"** — What happens if:
   - You're in room 4 and choose "next room"? (Error)
   - You're in room 1 and choose "prev room"? (Error)


**Fill in the bracketed sections.** Be specific about:
- What checks you do (e.g., "if current room == 4, show error")
  - it's a dead end you have to go the other way
- What happens when entering a room
  - oh no a < enemy > is attacking you
- How resting works with enemy respawn
  - they don't respawn until you exit and re-enter a room
