-- The randomizer: items shuffled so the game can always be finished, and enemies of other types
-- from anywhere in the game, per character. A character is set up on the creation screen
-- (creation.lua) and keeps its run (character.lua). As each of its areas loads, the run's items go
-- into the game's params (items.lua) and the area's map and event files get its enemies
-- (enemy_maps.lua), before the game reads them (map_loading). In a co-op host's world a player
-- plays the host's run: the host gives it to each player as join data.
local character = require("character")
local items = require("items")
local enemy_maps = require("enemy_maps")
local hints = require("hints")
local creation = require("creation")

creation.add_rows()
kindle.on("setting_changed", function() creation.add_rows() end)

-- Every map an enemy type can come from, read ahead (the first area load needs them all).
kindle.maps.preload(enemy_maps.MAPS)

-- The DLCs in play for a run: this game's, or in a co-op host's world the host's.
local function dlc_for(run)
  if run and run.dlc then return run.dlc end
  return enemy_maps.dlc_files()
end

-- As host (or alone): the run players in this world play, and the DLCs they need for it.
local function offer(run, dlc)
  if run then
    kindle.net.set_welcome("run", { seed = run.seed, items = run.items, enemies = run.enemies, keep = run.keep, dlc = dlc })
    kindle.net.require_dlc(run.enemies and enemy_maps.pool_dlcs(dlc) or {})
  else
    kindle.net.set_welcome("run", false)
    kindle.net.require_dlc({})
  end
end

kindle.on("map_loading", function(map, file)
  local ok, err = pcall(function()
    local run = character.current()
    local dlc = dlc_for(run)
    if kindle.net.role() ~= "player" then offer(run, dlc) end
    if file == "map" then
      items.set(run, dlc)
      enemy_maps.set_map(map, run, dlc)
    else
      enemy_maps.set_events(map, run)
    end
  end)
  if not ok then kindle.log.warn("%s (%s) not randomized: %s", map, file, err) end
end)

-- The Coiled Sword check, as the inventory changes and as a character loads.
kindle.on("item_gained", items.check_coiled_sword)
kindle.on("item_lost", items.check_coiled_sword)
kindle.on("player_loaded", items.check_coiled_sword)

-- The hint option needs the game's menu text, loaded some time after the mods.
local function try_hints()
  local ok, err = pcall(hints.add_option)
  if ok then return true end
  if not tostring(err):find("isn't loaded", 1, true) then
    kindle.log.warn("hints: %s", err)
    return true
  end
  return false
end
if not try_hints() then
  local waiting
  waiting = kindle.every(1, function()
    if try_hints() then kindle.cancel(waiting) end
  end)
end
