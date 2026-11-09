-- Hints, sold at bonfires to a character whose items are randomized: the first item the logic
-- needs, in the order the run can find them (logic.spheres), that the character hasn't picked up
-- yet, and where it is. Picked up: its location's own flag is on (a lot's pickup flag, a shop
-- slot's stock flag), or the character holds it (for slots without a flag); key items are used up
-- (the Coiled Sword goes into the bonfire), so holding it isn't enough on its own. A hint bought
-- stays free until the character has that item (character.lua keeps which).
local logic = require("logic")
local items = require("items")
local character = require("character")

local hints = {}

local PRICE = 1000
local FOR_SALE, BOUGHT = "Randomizer hint (" .. PRICE .. " souls)", "Randomizer hint"

-- An area's name in the game, from the logic's id.
local AREA_NAMES = {
  cemetery = "Cemetery of Ash",
  firelink = "Firelink Shrine",
  high_wall = "High Wall of Lothric",
  undead_settlement = "Undead Settlement",
  road_of_sacrifices = "Road of Sacrifices",
  cathedral = "Cathedral of the Deep",
  farron_keep = "Farron Keep",
  catacombs = "Catacombs of Carthus",
  smouldering_lake = "Smouldering Lake",
  irithyll = "Irithyll of the Boreal Valley",
  anor_londo = "Anor Londo",
  irithyll_dungeon = "Irithyll Dungeon",
  profaned_capital = "Profaned Capital",
  archdragon_peak = "Archdragon Peak",
  lothric_castle = "Lothric Castle",
  consumed_garden = "Consumed King's Garden",
  untended_graves = "Untended Graves",
  grand_archives = "Grand Archives",
  kiln = "Kiln of the First Flame",
  painted_world = "Painted World of Ariandel",
  dreg_heap = "The Dreg Heap",
  ringed_city = "The Ringed City",
  filianores_rest = "Filianore's Rest",
}

-- A location in words.
local function where_is(world, location)
  local area = world.areas[location.area]
  local name = area and AREA_NAMES[area.name] or "somewhere"
  local origin = location.origin
  if origin == "handmaid" then return "the Shrine Handmaid's shop" end
  if origin == "npcshop" then return "a shop in " .. name end
  if origin == "boss" then return "a boss's reward in " .. name end
  if origin == "drop" then return "an enemy's drop in " .. name end
  if origin == "npc" then return "an NPC's gift in " .. name end
  if origin == "event" then return "an event's reward in " .. name end
  return name
end

local MAKERS = { [0] = kindle.items.weapon, kindle.items.armor, kindle.items.ring, kindle.items.goods }

-- The order of the run's key items, worked out once per placement.
local order_for, order

local function flag_on(row, field)
  local flag = row and math.tointeger(row[field]) or 0
  return flag > 0 and kindle.flags.get(flag)
end

-- The hint for the loaded character: item, place, bought; nil when it has every item the logic
-- needs or its items aren't randomized.
function hints.next()
  local placement = items.current()
  if not placement then return nil end
  local world = items.world()
  if order_for ~= placement then
    order = logic.spheres(world, items.settings_used, placement.items)
    order_for = placement
  end
  local keys = logic.key_items(world)
  for _, entry in ipairs(order) do
    local location = world.locations[entry.location]
    local picked
    if location.source.kind == "lot" then
      picked = flag_on(kindle.params.get("ItemLotParam", location.source.id), "getItemFlagId")
    else
      picked = flag_on(kindle.params.get("ShopLineupParam", location.source.id), "eventFlag_forStock")
    end
    local item = MAKERS[logic.item_kind(entry.item)](logic.item_id(entry.item))
    if not picked and kindle.items.count(item) == 0 then
      local number
      for k, key in ipairs(keys) do
        if key == entry.item then number = k end
      end
      return kindle.items.name(item) or logic.item_text(entry.item), where_is(world, location), character.hinted() == number, number
    end
  end
  return nil
end

-- The bonfire option. The option itself buys the hint: a bonfire before Firelink (only "Leave")
-- closes its menu instead of reopening it, so a sub-menu can't be shown there. Its text shows the
-- price only until the current hint is bought.
function hints.add_option()
  local option
  option = kindle.ui.add_menu_option {
    text = FOR_SALE,
    where = function(menu)
      if not (menu.bonfire and items.current()) then return false end
      local item, _, bought = hints.next()
      kindle.ui.set_menu_option_text(option, (item and not bought) and FOR_SALE or BOUGHT)
      return true
    end,
    on_select = function()
      local item, place, bought, number = hints.next()
      if not item then
        kindle.ui.message("You have every item you need.")
      elseif bought then
        kindle.ui.message(item .. ": " .. place)
      elseif kindle.player.souls() < PRICE then
        kindle.ui.message("Not enough souls (" .. PRICE .. " needed).")
      else
        kindle.player.set_souls(kindle.player.souls() - PRICE)
        character.set_hinted(number)
        kindle.ui.message(item .. ": " .. place)
        kindle.log.info("hint: %s: %s", item, place)
      end
    end,
  }
end

return hints
