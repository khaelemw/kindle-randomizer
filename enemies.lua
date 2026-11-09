-- The enemy randomizer's choice of which enemy stands where, as plain logic (no game access).
--
-- Each enemy spot of an area (where it stands, the ground under it, its walk route) gets an
-- enemy type from anywhere in the game: another model, with that type's own stats, AI and
-- looks. The spot's event scripts don't follow (they address the spot's old enemy), so the new
-- enemy acts as its type does at home.
--
-- An enemy can be more than one map part: forms of it standing at the same spot (a hollow and
-- what it turns into, one shown at a time), parts its event scripts swap for each other, or a
-- form they move onto the first when it changes (wherever it was waiting). Those are one unit
-- (enemies.units); a unit of several parts keeps its enemy.
--
-- A spot only gets a type no bigger than its own enemy, so a giant never ends up in a corridor
-- built for a hollow, and spots that have to keep theirs (bosses, NPCs, anything a script or the
-- item logic depends on) do. Each spot picks a model evenly among those that fit (not its own),
-- then one of that model's types, so models with many variants aren't favoured.
local rng = require("rng")

local enemies = {}

-- Parts standing this close (metres) are forms of one enemy.
enemies.STACKED = 0.5

-- How much room an enemy needs, from its hit radius: 1 small (human-sized and smaller, up to
-- 0.55), 2 medium (up to 1.0: large knights, beasts), 3 large (up to 3.0: giants' kin, dragons
-- on foot); nil for the biggest (bosses and set pieces), which never move.
enemies.SMALL, enemies.MEDIUM, enemies.LARGE = 1, 2, 3

function enemies.size_from_radius(radius)
  if radius <= 0.55 then return enemies.SMALL end
  if radius <= 1.0 then return enemies.MEDIUM end
  if radius <= 3.0 then return enemies.LARGE end
  return nil
end

-- The id groups in a links list (ids on a line, `#` comments): {{id, id, ...}, ...}.
function enemies.links(text)
  local out = {}
  for line in text:gmatch("[^\n]+") do
    local ids = {}
    for word in (line:match("^[^#]*")):gmatch("%S+") do
      local id = math.tointeger(tonumber(word))
      if id then ids[#ids + 1] = id end
    end
    if #ids > 1 then out[#out + 1] = ids end
  end
  return out
end

-- The ids in a list (one per line, `#` comments), as a set.
function enemies.id_list(text)
  local out = {}
  for line in text:gmatch("[^\n]+") do
    local id = math.tointeger(tonumber((line:match("^[^#]*")):match("^%s*(.-)%s*$")))
    if id then out[id] = true end
  end
  return out
end

-- The parts that make up each enemy: parts within STACKED of each other, or sharing a line of
-- `links` (a part matches by any of its `ids`: entity id or groups), are one unit. Each unit is
-- a list of part numbers (positions' places), in order; every part is in exactly one.
function enemies.units(positions, ids, links)
  local count = #positions
  local parent = {}
  for i = 1, count do parent[i] = i end
  local function root(i)
    while parent[i] ~= i do
      parent[i] = parent[parent[i]]
      i = parent[i]
    end
    return i
  end
  local function join(one, other)
    local root_one, root_other = root(one), root(other)
    if root_one ~= root_other then parent[math.max(root_one, root_other)] = math.min(root_one, root_other) end
  end
  for first = 1, count do
    local here = positions[first]
    for second = first + 1, count do
      local there = positions[second]
      local dx, dy, dz = here[1] - there[1], here[2] - there[2], here[3] - there[3]
      if math.sqrt(dx * dx + dy * dy + dz * dz) <= enemies.STACKED then join(first, second) end
    end
  end
  for _, line in ipairs(links) do
    local on_line = {}
    for _, id in ipairs(line) do on_line[id] = true end
    local previous
    for i = 1, count do
      local matches = false
      for _, id in ipairs(ids[i]) do matches = matches or on_line[id] == true end
      if matches then
        if previous then join(previous, i) end
        previous = i
      end
    end
  end
  local out, unit_of = {}, {}
  for i = 1, count do
    local top = root(i)
    if not unit_of[top] then
      out[#out + 1] = {}
      unit_of[top] = #out
    end
    local unit = out[unit_of[top]]
    unit[#unit + 1] = i
  end
  return out
end

-- For each spot ({model, size}; size nil: it keeps its enemy), the number in `kinds` ({model,
-- size} each) of the type it gets, or false (it keeps its enemy). The same spots, kinds and
-- seed give the same result.
function enemies.pick(spots, kinds, seed)
  local numbers = rng.new(seed)
  local models, seen = {}, {}
  for _, kind in ipairs(kinds) do
    if not seen[kind.model] then
      seen[kind.model] = true
      models[#models + 1] = kind.model
    end
  end
  table.sort(models)
  local out = {}
  for number, spot in ipairs(spots) do
    out[number] = false
    local size = spot.size
    if size then
      local choices = {}
      for _, model in ipairs(models) do
        if model ~= spot.model then
          for _, kind in ipairs(kinds) do
            if kind.model == model and kind.size <= size then
              choices[#choices + 1] = model
              break
            end
          end
        end
      end
      if #choices > 0 then
        local model = choices[numbers:below(#choices) + 1]
        local types = {}
        for k, kind in ipairs(kinds) do
          if kind.model == model and kind.size <= size then types[#types + 1] = k end
        end
        out[number] = types[numbers:below(#types) + 1]
      end
    end
  end
  return out
end

-- For each of `count` bosses, the one whose type its arena gets: a shuffle where none keeps its
-- own (when count > 1). The same seed gives the same result.
function enemies.boss_order(count, seed)
  local numbers = rng.new(seed ~ 0xB055B055)
  local order = {}
  for i = 1, count do order[i] = i end
  if count < 2 then return order end
  numbers:shuffle(order)
  -- Any boss left in its own arena trades with the next one (a cycle, so none stays).
  for i = 1, count do
    if order[i] == i then
      local next_one = i % count + 1
      order[i], order[next_one] = order[next_one], order[i]
    end
  end
  return order
end

-- A seed per map, so maps don't mirror each other.
function enemies.map_seed(seed, map)
  local hash = seed
  for i = 1, #map do
    hash = ((hash << 5) | (hash >> 59)) ~ map:byte(i)
  end
  return hash * 0x9E3779B97F4A7C15
end

return enemies
