local items = {
  weapons = {
    rusty_sword = {
      name = 'Rusty Sword',
      id = 'rustysword',
      type = 'weapon',
      hitChance = 75,
      damage = 5,
    },
    bow = { name = 'Bow', id = 'bow', type = 'weapon', hitChance = 80, damage = 10 },
    longsword = {
      name = 'Longsword',
      id = 'longsword',
      type = 'weapon',
      hitChance = 95,
      damage = 15,
    },
  },
  consumables = {
    healing_potion = {
      name = 'Healing Potion',
      id = 'healingpotion',
      heal = 15,
      type = 'consumable',
    },
    arrow = { name = 'Arrow', id = 'arrow', type = 'consumable' },
  },
  loot = {
    gold_coin = { name = 'Gold Coin', id = 'goldcoin', type = 'loot' },
  },
}

return items
