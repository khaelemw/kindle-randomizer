-- The enemy randomizer in game: for a run that randomizes enemies, each map file is changed as the
-- game opens it (map_loading, kindle.maps.edit), its enemy spots given enemy types from anywhere
-- in the game for the run's seed (enemies.lua). Kindle keeps a changed map in its cache for the
-- next session, and loads the AI of the maps the new enemies come from.
--
-- A spot keeps where it stands: its part, the collision part it stands on and its walk route. It
-- gets another map's enemy part's type (AI, NpcParam, model): a real enemy of that type, with its
-- own stats, looks, AI and drops. The spot's entity id and groups go, so the spot's event scripts
-- (idle poses, waking, ambushes) don't act on it: it behaves as its type does at home. Verified in
-- game 2026-10-07 (m40's first hollow made a High Wall c1280).
--
-- Spots that keep their enemy, and types never given to a spot: humans and dummies (c0000, c0100,
-- c1000), bosses and their companions, the praying hollows' cloaks (c1130), anything with a talk
-- script, anything not on an enemy team (types given out: plain enemies only, not ones that fight
-- everyone), anything whose drop is one-time (the item logic has it in its map) or whose scripts
-- give an item when it dies (data/reward_bound.lua), anything its scripts pose with gravity off
-- (perched or hanging: another enemy there would fall; data/gravity_off.lua), the biggest (hit
-- radius over 3 m), and enemies of several parts (forms of one enemy, enemies.units). A spot gets
-- a type no bigger than its own enemy (hit radius classes).
--
-- Bosses whose fights are scripted only on what any boss has (health bar, defeat, AI, music) trade
-- arenas: each arena keeps its boss's entity id and groups, so its scripts (health bar, defeat
-- flag, fog walls, music, rewards) act on the new boss. The health bar's name is an argument of
-- the arena's own event (2003[11] Display Boss Health Bar: bar, entity, 0, NPC name id), not the
-- boss's NpcParam (Champion Gundyr's bar names him, his NpcParam names Iudex): the arena's event
-- file gets the new boss's own bar name (from its home arena's event). Verified in game
-- 2026-10-07: Dragonslayer Armour in Vordt's arena, health bar, defeat flag and bonfire.
local enemies = require("enemies")

local enemy_maps = {}

-- Models that keep their spots: humans and dummies, then the bosses (found from their defeat
-- events' entities) and their companions.
local STAYING_MODELS = {}
for _, model in ipairs({
  0, 100, 1000, 1130, -- humans, dummies, cloaks
  1320, 2090, 2240, 3040, 3050, 3141, 3160, 5010, 5020, 5110, 5140, 5150, 5160, 5180, 5220, 5250, 5260, 5270, 5280, 6020, 6200, 6211, 5021, 5022, 5251,
  6201, -- Demon Prince's companions, Lothric, Gael's second form
}) do STAYING_MODELS[model] = true end

-- Bosses that trade arenas, by entity id: Vordt, Dragonslayer Armour, Aldrich, Champion Gundyr,
-- Soul of Cinder (one body each, fights scripted only on what any boss has).
local SWAPPED_BOSSES = { 3000800, 3010800, 3700800, 4000830, 4100800 }

-- The maps enemy types come from, in a fixed order (a run's choices depend on it). A DLC's maps
-- count only when the run's DLC set has them (in a co-op host's world the host's: the pool, and
-- so every choice, is the same on both games).
enemy_maps.MAPS = {
  "m30_00_00_00", "m30_01_00_00", "m31_00_00_00", "m32_00_00_00", "m33_00_00_00", "m34_01_00_00", "m35_00_00_00", "m37_00_00_00",
  "m38_00_00_00", "m39_00_00_00", "m40_00_00_00", "m41_00_00_00", "m45_00_00_00", "m50_00_00_00", "m51_00_00_00", "m51_01_00_00",
}

-- NpcParam teams (teamType): an enemy, and one that also fights other enemies. Other teams are
-- bosses (7), invaders and NPCs (16, 26) and scenery and set pieces (30).
local TEAM_ENEMY, TEAM_ENEMY_OF_ALL = 6, 33

-- The command showing a boss health bar: 2003[11] (bar, entity, 0, name id).
local HEALTH_BAR = { 2003, 11 }

-- The DLC a map belongs to: "ashes_of_ariandel", "ringed_city", or nil for the base game.
local function map_dlc(map)
  local area = map:sub(1, 3)
  if area == "m45" then return "ashes_of_ariandel" end
  if area == "m50" or area == "m51" then return "ringed_city" end
  return nil
end

-- The DLCs whose maps this game has: {ashes_of_ariandel = bool, ringed_city = bool}.
function enemy_maps.dlc_files()
  return { ashes_of_ariandel = kindle.maps.parts("m45_00_00_00") ~= nil, ringed_city = kindle.maps.parts("m50_00_00_00") ~= nil }
end

local bound
-- Entity ids and groups whose enemies keep their spot (reward-bound and posed).
local function bound_ids()
  if not bound then
    bound = enemies.id_list(require("data.reward_bound"))
    for id in pairs(enemies.id_list(require("data.gravity_off"))) do bound[id] = true end
  end
  return bound
end

local links
local function link_list()
  if not links then links = enemies.links(require("data.enemy_links")) end
  return links
end

local function model_number(model) return math.tointeger(tonumber(model:sub(2))) or -1 end

-- A map's enemy parts: {part (its number), model, position, ids (entity id and groups), think,
-- npc, talk}, in the file's order.
local function enemy_parts(parts)
  local out = {}
  for number, part in ipairs(parts or {}) do
    if part.kind == "enemy" and part.npc_param then
      local ids = {}
      if part.entity_id then ids[#ids + 1] = part.entity_id end
      for _, group in ipairs(part.entity_groups or {}) do ids[#ids + 1] = group end
      out[#out + 1] = {
        part = number,
        model = model_number(part.model),
        position = part.position,
        ids = ids,
        think = part.think_param,
        npc = part.npc_param,
        talk = part.talk or 0,
      }
    end
  end
  return out
end

local function team(npc)
  local row = kindle.params.get("NpcParam", npc)
  return row and math.tointeger(row.teamType)
end

-- How much room an enemy needs (nil: it keeps its spot and isn't given to others): its NpcParam
-- row's hit radius, unless something ties it down.
local function size_of(enemy)
  if STAYING_MODELS[enemy.model] or enemy.talk > 0 then return nil end
  local ids = bound_ids()
  for _, id in ipairs(enemy.ids) do
    if ids[id] then return nil end
  end
  local row = kindle.params.get("NpcParam", enemy.npc)
  if not row then return nil end
  local team_type = math.tointeger(row.teamType)
  if team_type ~= TEAM_ENEMY and team_type ~= TEAM_ENEMY_OF_ALL then return nil end
  -- One-time drops stay with their spot (the item logic places them).
  for k = 1, 6 do
    local lot = math.tointeger(row["ItemLotId" .. k]) or 0
    if lot > 0 then
      local lot_row = kindle.params.get("ItemLotParam", lot)
      if lot_row and (math.tointeger(lot_row.getItemFlagId) or 0) > 0 then return nil end
    end
  end
  return enemies.size_from_radius(row.hitRadius)
end

-- Each enemy part's size if its enemy can change (a unit of one part; see size_of), else false.
local function movable(list)
  local positions, ids, out = {}, {}, {}
  for i, enemy in ipairs(list) do
    positions[i] = enemy.position
    ids[i] = enemy.ids
    out[i] = false
  end
  for _, unit in ipairs(enemies.units(positions, ids, link_list())) do
    if #unit == 1 then out[unit[1]] = size_of(list[unit[1]]) or false end
  end
  return out
end

-- The enemy types for each DLC set read so far: {donors, kinds}.
local pools = {}

local function dlc_key(dlc) return string.format("%s %s", dlc.ashes_of_ariandel, dlc.ringed_city) end

-- Every enemy type the maps have (one per model and NpcParam row), as {map, part, model, npc,
-- size}. A type's enemies can have several AI rows (an ambusher's or a sleeper's next to the
-- usual one): the type is given with its most used one, the lowest if they tie.
local function pool(dlc)
  local key = dlc_key(dlc)
  if pools[key] then return pools[key] end
  local started = kindle.time()
  local types, order = {}, {}
  for _, map in ipairs(enemy_maps.MAPS) do
    local needs = map_dlc(map)
    if not needs or dlc[needs] then
      local list = enemy_parts(kindle.maps.parts(map))
      for i, size in ipairs(movable(list)) do
        local enemy = list[i]
        if size and team(enemy.npc) == TEAM_ENEMY then
          local type_key = enemy.model .. ":" .. enemy.npc
          if not types[type_key] then
            types[type_key] = {}
            order[#order + 1] = type_key
          end
          local uses = types[type_key]
          local found = false
          for _, use in ipairs(uses) do
            if use.think == enemy.think then
              use.count = use.count + 1
              found = true
              break
            end
          end
          if not found then uses[#uses + 1] = { think = enemy.think, count = 1, donor = { map = map, part = enemy.part, model = enemy.model, npc = enemy.npc, size = size } } end
        end
      end
    end
  end
  local donors, kinds = {}, {}
  for _, type_key in ipairs(order) do
    local best
    for _, use in ipairs(types[type_key]) do
      if not best or use.count > best.count or (use.count == best.count and use.think < best.think) then best = use end
    end
    donors[#donors + 1] = best.donor
    kinds[#kinds + 1] = { model = best.donor.model, size = best.donor.size }
  end
  kindle.log.info("%d enemy types to give out (DLC %s; %.1fs)", #donors, key, kindle.time() - started)
  pools[key] = { donors = donors, kinds = kinds }
  return pools[key]
end

local bosses
-- The swapped bosses' home arenas and parts: {map, part, model} by SWAPPED_BOSSES number (false
-- where a map or boss wasn't found).
local function boss_homes()
  if bosses then return bosses end
  bosses = {}
  for i = 1, #SWAPPED_BOSSES do bosses[i] = false end
  for _, map in ipairs(enemy_maps.MAPS) do
    for _, enemy in ipairs(enemy_parts(kindle.maps.parts(map))) do
      for i, entity in ipairs(SWAPPED_BOSSES) do
        if enemy.ids[1] == entity then bosses[i] = { map = map, part = enemy.part, model = enemy.model } end
      end
    end
  end
  return bosses
end

local bar_names
-- Each swapped boss's health bar name id, from its home arena's event file (the first health bar
-- naming its entity), by SWAPPED_BOSSES number (false if not found).
local function home_bar_names()
  if bar_names then return bar_names end
  bar_names = {}
  for i, home in ipairs(boss_homes()) do
    bar_names[i] = false
    if home then
      for _, command in ipairs(kindle.events.find(home.map, HEALTH_BAR[1], HEALTH_BAR[2])) do
        if command.args[2] == SWAPPED_BOSSES[i] then
          bar_names[i] = command.args[4]
          break
        end
      end
    end
  end
  return bar_names
end

-- The changes to `map` for `run` (enemies on) with the DLC set `dlc`.
function enemy_maps.changes(map, run, dlc)
  local parts = kindle.maps.parts(map)
  if not parts then return {} end
  local the_pool = pool(dlc)
  local list = enemy_parts(parts)
  local spots = {}
  for i, size in ipairs(movable(list)) do
    spots[i] = { model = list[i].model, size = size or nil }
  end
  local changes = {}
  for i, choice in ipairs(enemies.pick(spots, the_pool.kinds, enemies.map_seed(run.seed, map))) do
    if choice then
      local donor = the_pool.donors[choice]
      changes[#changes + 1] = { replace_enemy = list[i].part, from = { map = donor.map, part = donor.part } }
    end
  end
  -- Bosses trade arenas (one order for the whole run, so each appears once).
  local homes = boss_homes()
  local order = enemies.boss_order(#SWAPPED_BOSSES, run.seed)
  for _, enemy in ipairs(list) do
    for i, entity in ipairs(SWAPPED_BOSSES) do
      local incoming = homes[order[i]]
      if enemy.ids[1] == entity and homes[i] and incoming then
        changes[#changes + 1] = { replace_enemy = enemy.part, from = { map = incoming.map, part = incoming.part }, keep_ids = true }
      end
    end
  end
  return changes
end

-- Sets this map's enemies for `run` (or puts them back: enemies off).
function enemy_maps.set_map(map, run, dlc)
  if not (run and run.enemies) then
    kindle.maps.reset(map)
    return
  end
  local changes = enemy_maps.changes(map, run, dlc)
  if #changes == 0 then
    kindle.maps.reset(map)
  else
    kindle.maps.edit(map, changes)
  end
end

-- Sets this map's boss health bar names for `run`: an arena whose boss traded places names the
-- boss that came in.
function enemy_maps.set_events(map, run)
  kindle.events.reset(map)
  if not (run and run.enemies) then return end
  local homes, names = boss_homes(), home_bar_names()
  local order = enemies.boss_order(#SWAPPED_BOSSES, run.seed)
  for i, entity in ipairs(SWAPPED_BOSSES) do
    local name = names[order[i]]
    if homes[i] and homes[i].map == map and homes[order[i]] and name then
      -- Every event showing its bar, each command's place as the game will run it (other mods'
      -- changes in).
      local events, seen = {}, {}
      for _, found in ipairs(kindle.events.find(map, HEALTH_BAR[1], HEALTH_BAR[2])) do
        if found.args[2] == entity and not seen[found.event] then
          seen[found.event] = true
          events[#events + 1] = found.event
        end
      end
      for _, id in ipairs(events) do
        local event = kindle.events.view(map, id)
        for number, command in ipairs(event and event.commands or {}) do
          if command.bank == HEALTH_BAR[1] and command.index == HEALTH_BAR[2] and command.args[2] == entity then
            local args = command.args
            kindle.events.edit(map, id, {
              { replace = number, is = HEALTH_BAR, bank = HEALTH_BAR[1], index = HEALTH_BAR[2], format = "iiii", values = { args[1], args[2], args[3], name }, keep_params = true },
            }, "a boss from another arena: its health bar names it")
          end
        end
      end
    end
  end
end

-- The DLCs the run's enemy types come from (for kindle.net.require_dlc): names.
function enemy_maps.pool_dlcs(dlc)
  local out = {}
  if dlc.ashes_of_ariandel then out[#out + 1] = "ashes_of_ariandel" end
  if dlc.ringed_city then out[#out + 1] = "ringed_city" end
  return out
end

return enemy_maps
