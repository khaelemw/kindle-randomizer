-- The item randomizer as plain logic (no game access): the game's logic as data (logic_data.lua:
-- areas joined by connections that need items or bosses, bosses that may need items, and every
-- item location with the area it's in), and a placement that moves the locations' contents
-- around so that an item the logic needs is always somewhere the player can reach without it.
-- Every placement is played through before it's used: a seed that can't be finished is never
-- handed out.
--
-- What moves is up to the player: each kind of item (weapons, key items, souls, ...) and each
-- kind of place (map pickups, bosses, shops, ...) can be left vanilla, and the DLC areas are
-- only used when they're installed. A location is shuffled when its place, its item and its
-- area are all switched on; everything else stays where the vanilla game has it, and the logic
-- still checks the whole game can be finished around it.
--
-- Placement: the items the logic needs go first, by assumed fill. Each one goes somewhere
-- reachable while the player is assumed to hold every such item not yet placed, which can't
-- paint itself into a corner. Everything else fills the remaining locations. Missable locations
-- (NPC gifts and drops, scripted events, NPC shops) only get the rest. A shop slot holds one
-- kind of item.
--
-- Lists are numbered from 1 (areas, bosses, locations ...). An item is one integer: its kind
-- (0 weapon, 1 armor, 2 ring, 3 goods) times 2^32 plus its id, so items sort as kind, then id.
local rng = require("rng")

local logic = {}

-- Attempts before giving up on a seed (each failure moves on to the next numbers).
local ATTEMPTS = 200
-- The most a shop asks for an item the logic needs.
logic.KEY_ITEM_MAX_PRICE = 1000

local ITEM_KINDS = { w = 0, a = 1, r = 2, g = 3 }
local KIND_LETTERS = { [0] = "w", "a", "r", "g" }
logic.WEAPON, logic.ARMOR, logic.RING, logic.GOODS = 0, 1, 2, 3

function logic.item(kind, id) return (kind << 32) | id end
function logic.item_kind(item) return item >> 32 end
function logic.item_id(item) return item & 0xFFFFFFFF end
function logic.item_text(item) return KIND_LETTERS[item >> 32] .. ":" .. (item & 0xFFFFFFFF) end

-- Kinds of item, for the item toggles (their bit numbers, from 0, are their places here).
logic.ITEM_TYPES = { "weapons", "armor", "rings", "spells", "key_items", "upgrades", "shards", "souls", "boss_souls", "ashes", "tomes", "unique", "consumables" }
-- Kinds of place (a location's `from=`), for the place toggles.
logic.ORIGINS = { "map", "boss", "drop", "npc", "event", "handmaid", "npcshop" }
local TYPE_BIT, ORIGIN_BIT = {}, {}
for i, name in ipairs(logic.ITEM_TYPES) do TYPE_BIT[name] = i - 1 end
for i, name in ipairs(logic.ORIGINS) do ORIGIN_BIT[name] = i - 1 end
logic.TYPE_BIT, logic.ORIGIN_BIT = TYPE_BIT, ORIGIN_BIT
logic.ALL = 0xFFFFFFFF

-- Goods that add to the Handmaid's stock, and goods that teach NPCs spells or infusions.
local ASHES, TOMES = {}, {}
for _, id in ipairs({ 2107, 2108, 2109, 2110, 2111, 2112, 2113, 2114, 2115, 2116, 2146, 2147, 2148, 2149, 2150, 2151, 2152, 2154, 2157, 2118, 2153 }) do ASHES[id] = true end
for _, id in ipairs({ 2103, 2104, 2105, 2106, 2119, 2120, 2121, 2127, 2128, 2129, 2130, 2131, 2132, 2133, 2134, 2140, 2144, 2145 }) do TOMES[id] = true end

-- An item's kind (its ITEM_TYPES name). `keys`: the world's key items as a set.
function logic.item_type(item, keys)
  if keys[item] then return "key_items" end
  local kind, id = item >> 32, item & 0xFFFFFFFF
  if kind == 0 then return "weapons" end
  if kind == 1 then return "armor" end
  if kind == 2 then return "rings" end
  if id >= 1200000 then return "spells" end
  if id >= 1000 and id <= 1299 then return "upgrades" end
  if id == 2141 or id == 2143 then return "shards" end
  if id >= 400 and id <= 420 then return "souls" end
  if id >= 700 and id <= 799 then return "boss_souls" end
  if ASHES[id] then return "ashes" end
  if TOMES[id] then return "tomes" end
  if id == 390 or id == 490 or (id >= 2000 and id <= 2199) then return "unique" end
  return "consumables"
end

-- ── the data ──────────────────────────────────────────────────────────────────

local function words_of(text)
  local list = {}
  for word in text:gmatch("%S+") do list[#list + 1] = word end
  return list
end

-- `text` split at each `separator` (plain text, as Rust's split).
local function split(text, separator)
  local parts, start = {}, 1
  while true do
    local at = text:find(separator, start, true)
    if not at then
      parts[#parts + 1] = text:sub(start)
      return parts
    end
    parts[#parts + 1] = text:sub(start, at - 1)
    start = at + #separator
  end
end

local function trim(text) return (text:gsub("^%s+", ""):gsub("%s+$", "")) end

local function parse_item(text)
  local letter, id = text:match("^(%a):(%d+)$")
  local kind = letter and ITEM_KINDS[letter]
  if not kind then return nil end
  return logic.item(kind, tonumber(id))
end

local function parse_stack(text)
  local item_text, count = text:match("^(.-)x(%d+)$")
  if not item_text then item_text, count = text, "1" end
  local item = parse_item(item_text)
  if not item then return nil end
  return { item = item, count = tonumber(count) }
end

-- A requirement: {kind = "free"|"item"|"boss"|"flag"|"all"|"any", ...}.
local function parse_term(names, text)
  if text == "free" then return { kind = "free" } end
  local boss = text:match("^boss:(.+)$")
  if boss then
    local index = names.bosses[boss]
    if not index then error(string.format("unknown boss %q", boss), 0) end
    return { kind = "boss", index = index }
  end
  local flag = text:match("^flag:(.+)$")
  if flag then
    local index = names.flags[flag]
    if not index then error(string.format("unknown flag %q", flag), 0) end
    return { kind = "flag", index = index }
  end
  local item = parse_item(text)
  if not item then error(string.format("bad requirement %q", text), 0) end
  return { kind = "item", item = item }
end

-- `a & b | c & d`: alternatives of conjunctions.
local function parse_req(names, text)
  local any = {}
  for _, alternative in ipairs(split(text, " | ")) do
    local all = {}
    for _, term in ipairs(split(alternative, " & ")) do all[#all + 1] = parse_term(names, trim(term)) end
    any[#any + 1] = #all == 1 and all[1] or { kind = "all", list = all }
  end
  return #any == 1 and any[1] or { kind = "any", list = any }
end

-- Every item a requirement needs, in order.
local function req_items(req, out)
  if req.kind == "item" then
    out[#out + 1] = req.item
  elseif req.kind == "all" or req.kind == "any" then
    for _, inner in ipairs(req.list) do req_items(inner, out) end
  end
end

-- A requirement as a function of the player's state.
local function compile(req)
  local kind = req.kind
  if kind == "free" then return function() return true end end
  if kind == "item" then
    local item = req.item
    return function(state) return state.owned[item] == true end
  end
  if kind == "boss" then
    local index = req.index
    return function(state) return state.bosses[index] end
  end
  if kind == "flag" then
    local index = req.index
    return function(state) return state.flags[index] end
  end
  local inner = {}
  for i, r in ipairs(req.list) do inner[i] = compile(r) end
  if kind == "all" then
    return function(state)
      for i = 1, #inner do
        if not inner[i](state) then return false end
      end
      return true
    end
  end
  return function(state)
    for i = 1, #inner do
      if inner[i](state) then return true end
    end
    return false
  end
end

-- The world from the data's text (see logic_data.lua for the grammar). Areas must be declared
-- before use; bosses and flags can be named anywhere.
function logic.parse(text)
  local names = { areas = {}, bosses = {}, flags = {} }
  local boss_count, flag_count = 0, 0
  local lines = {}
  for line in (text .. "\n"):gmatch("([^\n]*)\n") do lines[#lines + 1] = line:gsub("\r$", "") end
  for _, line in ipairs(lines) do
    local words = words_of(line:match("^[^#]*"))
    if words[1] == "boss" and words[2] and not names.bosses[words[2]] then
      boss_count = boss_count + 1
      names.bosses[words[2]] = boss_count
    elseif words[1] == "flag" and words[2] and not names.flags[words[2]] then
      flag_count = flag_count + 1
      names.flags[words[2]] = flag_count
    end
  end
  local world = { areas = {}, bosses = {}, flags = {}, edges = {}, locations = {}, goal = { kind = "free" } }
  local function area(name)
    local index = names.areas[name]
    if not index then error(string.format("unknown area %q", name), 0) end
    return index
  end
  for number, raw in ipairs(lines) do
    local line = trim(raw:match("^[^#]*"))
    if line ~= "" then
      local ok, err = pcall(function()
        local origin_word, group_word, words = nil, nil, {}
        for _, word in ipairs(words_of(line)) do
          if word:sub(1, 5) == "from=" then
            origin_word = origin_word or word:sub(6)
          elseif word:sub(1, 6) == "group=" then
            group_word = group_word or word:sub(7)
          else
            words[#words + 1] = word
          end
        end
        -- The requirement after "needs" (from word `from`), up to the trailing tags.
        local function needs_of(from, tags)
          local last = #words
          while last >= 1 and tags[words[last]] do last = last - 1 end
          if last < 1 then last = #words end
          return table.concat(words, " ", from, math.max(last, from - 1))
        end
        local has = {}
        for _, word in ipairs(words) do has[word] = true end
        local head = words[1]
        if head == "area" and #words >= 2 then
          names.areas[words[2]] = #world.areas + 1
          world.areas[#world.areas + 1] = { name = words[2], start = has.start == true, dlc = has.dlc1 and 1 or (has.dlc2 and 2 or nil) }
        elseif head == "boss" and #words >= 4 then
          local flag = tonumber(words[4])
          if not flag or math.type(flag) ~= "integer" then error(string.format("bad flag %q", words[4]), 0) end
          local needs = words[5] == "needs" and parse_req(names, needs_of(6, {})) or { kind = "free" }
          world.bosses[#world.bosses + 1] = { name = words[2], area = area(words[3]), flag = flag, needs = needs }
        elseif head == "flag" and #words >= 5 and words[4] == "needs" then
          world.flags[#world.flags + 1] = { name = words[2], area = area(words[3]), needs = parse_req(names, needs_of(5, {})) }
        elseif head == "edge" and #words >= 4 then
          world.edges[#world.edges + 1] = { from = area(words[2]), to = area(words[3]), needs = parse_req(names, needs_of(4, {})) }
        elseif head == "goal" and #words >= 2 then
          world.goal = parse_req(names, needs_of(2, {}))
        elseif head == "loc" and #words >= 4 then
          local origin = origin_word or "map"
          if not ORIGIN_BIT[origin] then error(string.format("unknown source %q", origin), 0) end
          local kind, id = words[2]:match("^(%a+):(%-?%d+)$")
          if not (kind == "lot" or kind == "shop") then error(string.format("bad location %q", words[2]), 0) end
          local items = {}
          for _, text in ipairs(split(words[4], ",")) do
            local stack = parse_stack(text)
            if not stack then error(string.format("bad item %q", text), 0) end
            items[#items + 1] = stack
          end
          local needs = words[5] == "needs" and parse_req(names, needs_of(6, { shop = true, missable = true })) or { kind = "free" }
          local group = nil
          if group_word then
            group = tonumber(group_word)
            if not group then error(string.format("bad group %q", group_word), 0) end
          end
          world.locations[#world.locations + 1] = {
            source = { kind = kind, id = tonumber(id) },
            origin = origin,
            area = area(words[3]),
            items = items,
            needs = needs,
            shop = has.shop == true,
            missable = has.missable == true,
            group = group,
          }
        else
          error(string.format("can't read %q", line), 0)
        end
      end)
      if not ok then error(string.format("line %d: %s", number, err), 0) end
    end
  end
  local started = false
  for _, area in ipairs(world.areas) do started = started or area.start end
  if not started then error("no start area", 0) end
  -- Each requirement as a function, for the sweeps.
  for _, list in ipairs({ world.edges, world.bosses, world.flags, world.locations }) do
    for _, entry in ipairs(list) do entry.has = compile(entry.needs) end
  end
  world.goal_has = compile(world.goal)
  return world
end

-- Every item some requirement needs (sorted, once each): the items the placement has to be
-- careful with.
function logic.key_items(world)
  local out = {}
  for _, list in ipairs({ world.edges, world.bosses, world.flags, world.locations }) do
    for _, entry in ipairs(list) do req_items(entry.needs, out) end
  end
  req_items(world.goal, out)
  table.sort(out)
  local unique = {}
  for _, item in ipairs(out) do
    if unique[#unique] ~= item then unique[#unique + 1] = item end
  end
  return unique
end

local function key_set(world)
  if not world.key_set then
    world.key_set = {}
    for _, item in ipairs(logic.key_items(world)) do world.key_set[item] = true end
  end
  return world.key_set
end

-- ── settings ──────────────────────────────────────────────────────────────────

-- Settings: {seed, ashes_of_ariandel, ringed_city, items (bits of ITEM_TYPES), places (bits of
-- ORIGINS)}. Everything moves, both DLCs in play:
function logic.settings_all(seed)
  return { seed = seed, ashes_of_ariandel = true, ringed_city = true, items = logic.ALL, places = logic.ALL }
end

local function has_bit(mask, bit) return (mask >> bit) & 1 ~= 0 end

local function area_in_play(settings, area)
  if area.dlc == 1 then return settings.ashes_of_ariandel end
  if area.dlc then return settings.ringed_city end
  return true
end

local function areas_in_play(world, settings)
  local list = {}
  for i, area in ipairs(world.areas) do list[i] = area_in_play(settings, area) end
  return list
end

-- ── the logic ─────────────────────────────────────────────────────────────────

-- A location's contents still to be filled.
local EMPTY = false

-- Everything reachable from the start holding `owned` (a set), collecting the contents of every
-- location reached (EMPTY: still to be filled). Areas not `in_play` are never entered.
local function sweep(world, in_play, contents, owned)
  local areas, bosses, flags, open = {}, {}, {}, {}
  for i, area in ipairs(world.areas) do areas[i] = area.start end
  for i = 1, #world.bosses do bosses[i] = false end
  for i = 1, #world.flags do flags[i] = false end
  for i = 1, #world.locations do open[i] = false end
  local state = { areas = areas, bosses = bosses, flags = flags, owned = owned, open = open }
  local edges, boss_list, flag_list, locations = world.edges, world.bosses, world.flags, world.locations
  local changed
  repeat
    changed = false
    for i = 1, #edges do
      local edge = edges[i]
      if areas[edge.from] and not areas[edge.to] and in_play[edge.to] and edge.has(state) then
        areas[edge.to] = true
        changed = true
      end
    end
    for i = 1, #boss_list do
      local boss = boss_list[i]
      if not bosses[i] and areas[boss.area] and boss.has(state) then
        bosses[i] = true
        changed = true
      end
    end
    for i = 1, #flag_list do
      local flag = flag_list[i]
      if not flags[i] and areas[flag.area] and flag.has(state) then
        flags[i] = true
        changed = true
      end
    end
    for i = 1, #locations do
      if not open[i] then
        local location = locations[i]
        if areas[location.area] and location.has(state) then
          open[i] = true
          changed = true
          local items = contents[i]
          if items then
            for _, stack in ipairs(items) do owned[stack.item] = true end
          end
        end
      end
    end
  until not changed
  return state
end

-- Plays `items` (what each location holds) through from nothing: true, or nil and what's out
-- of reach.
function logic.playthrough(world, settings, items)
  local in_play = areas_in_play(world, settings)
  local state = sweep(world, in_play, items, {})
  if world.goal_has(state) then return true end
  local areas, bosses = {}, {}
  for i, area in ipairs(world.areas) do
    if not state.areas[i] and in_play[i] then areas[#areas + 1] = area.name end
  end
  for i, boss in ipairs(world.bosses) do
    if not state.bosses[i] then bosses[#bosses + 1] = boss.name end
  end
  return nil, "can't be finished; out of reach: areas " .. table.concat(areas, ", ") .. "; bosses " .. table.concat(bosses, ", ")
end

-- The vanilla game's items, by location.
function logic.vanilla(world)
  local list = {}
  for i, location in ipairs(world.locations) do list[i] = location.items end
  return list
end

-- A shop slot sells one kind of item, one at a time.
local function fits(location, unit)
  return not location.shop or (#unit == 1 and unit[1].count == 1)
end

-- Whether a location's contents move under `settings`: its area, its kind of place and the
-- kind of its (main) item are all switched on.
local function moves(world, settings, keys, location)
  local first = location.items[1]
  if not first then return false end
  local item_type = logic.item_type(first.item, keys)
  return area_in_play(settings, world.areas[location.area]) and has_bit(settings.places, ORIGIN_BIT[location.origin]) and has_bit(settings.items, TYPE_BIT[item_type])
end

-- Whether `unit` holds something the logic needs (a shop then caps its price).
function logic.holds_key_item(world, unit)
  local keys = key_set(world)
  for _, stack in ipairs(unit) do
    if keys[stack.item] then return true end
  end
  return false
end

-- A shop slot's price once `unit` is in it: items the logic needs cost at most
-- KEY_ITEM_MAX_PRICE. A negative price (the item's own default, which can be anything) becomes
-- the cap.
function logic.shop_price(world, unit, vanilla)
  if not logic.holds_key_item(world, unit) then return vanilla end
  if vanilla >= 0 and vanilla <= logic.KEY_ITEM_MAX_PRICE then return vanilla end
  return logic.KEY_ITEM_MAX_PRICE
end

-- The groups of locations the game gives only one of: {leader, rest = {...}}. The leader is the
-- place the group's item is chosen for: its first location the logic can count on (not
-- missable), else its first.
local function groups(world)
  local order, members = {}, {}
  for i, location in ipairs(world.locations) do
    if location.group then
      if not members[location.group] then
        members[location.group] = {}
        order[#order + 1] = location.group
      end
      local list = members[location.group]
      list[#list + 1] = i
    end
  end
  local out = {}
  for _, id in ipairs(order) do
    local list = members[id]
    if #list > 1 then
      local leader = list[1]
      for _, i in ipairs(list) do
        if not world.locations[i].missable then
          leader = i
          break
        end
      end
      local rest = {}
      for _, i in ipairs(list) do
        if i ~= leader then rest[#rest + 1] = i end
      end
      out[#out + 1] = { leader = leader, rest = rest }
    end
  end
  return out
end
logic.groups = groups

-- The groups whose locations all move.
local function moving_groups(world, settings, keys)
  local out = {}
  for _, group in ipairs(groups(world)) do
    local all = moves(world, settings, keys, world.locations[group.leader])
    for _, i in ipairs(group.rest) do all = all and moves(world, settings, keys, world.locations[i]) end
    if all then out[#out + 1] = group end
  end
  return out
end

-- Makes each group one place: its other locations hold what its leader got.
local function merge_groups(world, settings, from)
  for _, group in ipairs(moving_groups(world, settings, key_set(world))) do
    for _, i in ipairs(group.rest) do from[i] = from[group.leader] end
  end
  return from
end

-- For each location, whose vanilla contents it gets (nil and why if this attempt fails).
local function try_place(world, settings, numbers)
  local keys = key_set(world)
  local in_play = areas_in_play(world, settings)
  local locations = world.locations
  local contents = {}
  for i, location in ipairs(locations) do
    if moves(world, settings, keys, location) then
      contents[i] = EMPTY
    else
      contents[i] = location.items
    end
  end
  -- A group is one place: its leader's (merge_groups).
  for _, group in ipairs(moving_groups(world, settings, keys)) do
    for _, i in ipairs(group.rest) do contents[i] = {} end
  end
  local needed, rest = {}, {}
  for i, location in ipairs(locations) do
    if contents[i] == EMPTY then
      local key = false
      for _, stack in ipairs(location.items) do key = key or keys[stack.item] == true end
      local list = key and needed or rest
      list[#list + 1] = { home = i, unit = location.items }
    end
  end
  local from = {}
  for i = 1, #locations do from[i] = i end

  numbers:shuffle(needed)
  while #needed > 0 do
    local placing = needed[#needed]
    needed[#needed] = nil
    local assumed = {}
    for _, other in ipairs(needed) do
      for _, stack in ipairs(other.unit) do assumed[stack.item] = true end
    end
    local state = sweep(world, in_play, contents, assumed)
    local spots = {}
    for i, location in ipairs(locations) do
      if contents[i] == EMPTY and state.open[i] and not location.missable and fits(location, placing.unit) then spots[#spots + 1] = i end
    end
    local spot
    if #spots == 0 then
      -- With few places switched on there may be no safe new spot: the item stays where the
      -- vanilla game has it (the playthrough check still runs).
      if contents[placing.home] ~= EMPTY then return nil, "nowhere reachable for " .. logic.item_text(placing.unit[1].item) end
      spot = placing.home
    else
      spot = spots[numbers:below(#spots) + 1]
    end
    contents[spot] = placing.unit
    from[spot] = placing.home
  end

  -- Shops first (they take one item), then everything else.
  numbers:shuffle(rest)
  local empty = {}
  for i, location in ipairs(locations) do
    if contents[i] == EMPTY and location.shop then empty[#empty + 1] = i end
  end
  for i, location in ipairs(locations) do
    if contents[i] == EMPTY and not location.shop then empty[#empty + 1] = i end
  end
  for _, i in ipairs(empty) do
    local pick
    for k, entry in ipairs(rest) do
      if fits(locations[i], entry.unit) then
        pick = k
        break
      end
    end
    if not pick then return nil, "not enough single items for the shops" end
    local entry = rest[pick]
    rest[pick] = rest[#rest]
    rest[#rest] = nil
    contents[i] = entry.unit
    from[i] = entry.home
  end
  return from
end

-- Places items for `settings`, trying the seed's numbers until a placement plays through:
-- {items = what each location holds, from = whose vanilla contents each holds, attempt}, or
-- nil and why.
function logic.place(world, settings)
  local numbers = rng.new(settings.seed)
  local last = ""
  for attempt = 1, ATTEMPTS do
    local from, err = try_place(world, settings, numbers)
    if from then
      from = merge_groups(world, settings, from)
      local items = {}
      for i, j in ipairs(from) do items[i] = world.locations[j].items end
      local ok, why = logic.playthrough(world, settings, items)
      if ok then return { items = items, from = from, attempt = attempt } end
      last = why
    else
      last = err
    end
  end
  return nil, string.format("no placement after %d attempts: %s", ATTEMPTS, last)
end

-- The order a player could find the logic's items in: {sphere, location, item} each (a sphere is
-- everything reachable with what the spheres before it gave; from 0).
function logic.spheres(world, settings, items)
  local keys = key_set(world)
  local in_play = areas_in_play(world, settings)
  local none, taken, owned, out = {}, {}, {}, {}
  for i = 1, #world.locations do
    none[i] = EMPTY
    taken[i] = false
  end
  local sphere = 0
  while true do
    local state = sweep(world, in_play, none, owned)
    local new = {}
    for i = 1, #world.locations do
      if state.open[i] and not taken[i] then new[#new + 1] = i end
    end
    if #new == 0 then break end
    for _, i in ipairs(new) do
      taken[i] = true
      for _, stack in ipairs(items[i]) do
        owned[stack.item] = true
        if keys[stack.item] then out[#out + 1] = { sphere = sphere, location = i, item = stack.item } end
      end
    end
    sphere = sphere + 1
  end
  return out
end

return logic
