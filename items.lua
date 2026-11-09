-- The item randomizer in game: logic.lua's placement for the run, applied to the game's item lots
-- and shop rows as one of its areas' map file opens (map_loading), before the area rolls its
-- pickups (they're rolled as an area loads). Another run (another character, or a co-op host's)
-- puts the rows back to vanilla first (params.reset), then applies its own.
--
-- A location takes over another's vanilla contents by row: a lot copies the other lot's whole row
-- (its slots, counts and weights, so the game's lottery is unchanged) and keeps its own pickup
-- flag (getItemFlagId; no location lot uses the per-slot flags); a shop slot copies the other
-- slot's item, price and stock and keeps its own stock and release flags. Contents moving between
-- a lot and a shop slot are one item: a lot then gives it with weight 1000 (as the game's
-- single-item pickups do), a shop sells it at the slot's own price. Items the logic needs cost at
-- most 1000 souls in shops. A goods item the game never sells has a shop price of -1, and shops
-- leave such goods out whatever their row asks (verified 2026-10-06: the Handmaid showed 16 of 35
-- rows, the hidden ones exactly those), so one put in a shop gets a price of its own.
--
-- Firelink's bonfire takes the Coiled Sword (its action button, 9351), but the game never checks
-- the player has it: the event (14005101) only waits for the button, as nobody gets there without
-- the sword in the vanilla game. When the sword is moved, the button is greyed out (shown, but it
-- does nothing; the param's grayoutFlag) while a flag of the randomizer's is on, which it keeps on
-- while the player has no Coiled Sword.
local logic = require("logic")
local character = require("character")

local items = {}

local LOT_FLAG = "getItemFlagId"
local SHOP_FLAGS = { "eventFlag_forStock", "eventFlag_forRelease" }
local GOODS_PRICE, GOODS_SELL = "shopId", "sellValue"
-- A shop price for goods that have none and whose row has none either.
local DEFAULT_PRICE = 1000
-- A lot's one item, given every time (the game's single-item pickups use 1000 or 100).
local SURE = 1000
local COILED_SWORD = 2137
-- "Insert the Coiled Sword" at Firelink's bonfire.
local COILED_BUTTON = 9351
-- The randomizer's: no event script, talk script or param uses it, and it's in the block of flags
-- Firelink's own are in (so the game stores it).
local COILED_FLAG = 14000950

-- The lot category and shop equip type of an item kind (logic's 0 weapon .. 3 goods).
local LOT_CATEGORY = { [0] = 0, 0x10000000, 0x20000000, 0x40000000 }

local world
-- The logic's world (read once).
function items.world()
  if not world then world = logic.parse(require("data.items")) end
  return world
end

-- The placement settings for a run (dlc: which DLCs' areas are in play, {aoa, rc}).
function items.settings(run, dlc)
  local item_bits, place_bits = 0, 0
  for _, name in ipairs(logic.ITEM_TYPES) do
    if not character.keeps_item(run, name) then item_bits = item_bits | (1 << logic.TYPE_BIT[name]) end
  end
  for _, name in ipairs(logic.ORIGINS) do
    if not character.keeps_place(run, name) then place_bits = place_bits | (1 << logic.ORIGIN_BIT[name]) end
  end
  return { seed = run.seed, ashes_of_ariandel = dlc.ashes_of_ariandel, ringed_city = dlc.ringed_city, items = item_bits, places = place_bits }
end

-- The run applied now (its text; nil: vanilla), and whether the Coiled Sword check is on.
local applied, coiled_check = nil, false

local function int(value) return math.tointeger(value) or 0 end

-- Lot `id` gives exactly `unit`'s first item, every time (its own flag kept).
local function single_lot(id, unit)
  local stack = unit[1]
  local row = kindle.params.get("ItemLotParam", id)
  for k = 1, 8 do
    row["ItemLotId" .. k] = 0
    row["LotItemNum" .. k] = 0
    row["LotItemBasePoint0" .. k] = 0
    row["LotItemCategory0" .. k] = 0
  end
  row.ItemLotId1 = logic.item_id(stack.item)
  row.LotItemCategory01 = LOT_CATEGORY[logic.item_kind(stack.item)]
  row.LotItemNum1 = stack.count
  row.LotItemBasePoint01 = SURE
end

-- Writes the placement over the (vanilla) rows; how many locations changed.
local function apply(placement)
  local world_now = items.world()
  local lot_pairs, shop_pairs, changed = {}, {}, 0
  for i, j in ipairs(placement.from) do
    if i ~= j then
      local to, from = world_now.locations[i].source, world_now.locations[j].source
      if to.kind == "lot" and from.kind == "lot" then
        lot_pairs[#lot_pairs + 1] = { from.id, to.id }
      elseif to.kind == "shop" and from.kind == "shop" then
        shop_pairs[#shop_pairs + 1] = { from.id, to.id }
      end
    end
  end
  kindle.params.copy("ItemLotParam", lot_pairs, { LOT_FLAG })
  kindle.params.copy("ShopLineupParam", shop_pairs, SHOP_FLAGS)
  for i, j in ipairs(placement.from) do
    if i ~= j then
      local to, from = world_now.locations[i].source, world_now.locations[j].source
      local unit = placement.items[i]
      if to.kind == "lot" and from.kind == "shop" then
        single_lot(to.id, unit)
      elseif to.kind == "shop" and from.kind == "lot" then
        local row = kindle.params.get("ShopLineupParam", to.id)
        row.equipId = logic.item_id(unit[1].item)
        row.equipType = logic.item_kind(unit[1].item)
      end
      if to.kind == "shop" then
        local shop = kindle.params.get("ShopLineupParam", to.id)
        if logic.holds_key_item(world_now, unit) then shop.value = logic.shop_price(world_now, unit, int(shop.value)) end
        local stack = unit[1]
        if logic.item_kind(stack.item) == logic.GOODS then
          local goods = kindle.params.get("EquipParamGoods", logic.item_id(stack.item))
          if goods and int(goods[GOODS_PRICE]) < 0 then
            local row_price = int(shop.value)
            local sell = int(goods[GOODS_SELL])
            local price = (row_price >= 0 and row_price) or (sell > 0 and sell * 2) or DEFAULT_PRICE
            goods[GOODS_PRICE] = price
          end
        end
      end
      changed = changed + 1
    end
  end
  -- The Coiled Sword check, when the sword isn't where it was.
  coiled_check = false
  for i, location in ipairs(world_now.locations) do
    for _, stack in ipairs(location.items) do
      if stack.item == logic.item(logic.GOODS, COILED_SWORD) and placement.from[i] ~= i then coiled_check = true end
    end
  end
  if coiled_check then kindle.params.get("ActionButtonParam", COILED_BUTTON).grayoutFlag = COILED_FLAG end
  return changed
end

-- Keeps the Coiled Sword flag on while the player has no sword (the check is on).
function items.check_coiled_sword()
  if not (coiled_check and kindle.player.loaded()) then return end
  local without = kindle.items.count(kindle.items.goods(COILED_SWORD)) == 0
  if kindle.flags.get(COILED_FLAG) ~= without then kindle.flags.set(COILED_FLAG, without) end
end

-- Makes the params hold `run`'s placement (if it moves items), or the vanilla rows. Does nothing
-- if they already do.
function items.set(run, dlc)
  local want = run and run.items and (character.describe(run) .. string.format(" dlc %s %s", dlc.ashes_of_ariandel, dlc.ringed_city)) or nil
  if want == applied then return end
  kindle.params.reset()
  coiled_check = false
  applied = nil
  if not want then
    kindle.log.info("items are vanilla")
    return
  end
  local settings = items.settings(run, dlc)
  local placement, why = logic.place(items.world(), settings)
  if not placement then
    kindle.log.warn("items not randomized: %s", why)
    return
  end
  local changed = apply(placement)
  applied = want
  items.placement, items.settings_used = placement, settings
  kindle.log.info("%d locations changed (%s)", changed, want)
end

-- The placement applied now (nil: vanilla).
function items.current() return applied and items.placement or nil end

return items
