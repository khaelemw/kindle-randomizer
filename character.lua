-- The randomizer per character. A character is randomized once, as it's made: what the creation
-- screen's Randomizer page and Seed box hold (creation.lua) is stored with it, in event flags
-- nothing in the game uses (no event script, talk script or param refers to them; the game saves
-- them with the character: both checked when Kindle had this built in, and these are the same
-- flags, so characters randomized then keep their run). Whenever one of its areas loads, its run
-- is read back and its items and enemies applied; a character without one plays vanilla.
--
-- Flags, in Firelink's block (which the game stores): 14000960 randomized (written last),
-- 14000961 items, 14000962 enemies, 14000963-14000994 the seed (bit 0 first), 14000906-14000925
-- the kept item kinds (13, logic.ITEM_TYPES order) and places (7, logic.ORIGINS order),
-- 14000926-14000932 the key item the last hint bought was for (its number in logic.key_items;
-- 0 none), so asking again for the same item costs nothing.
--
-- A player in a co-op host's world plays the host's run (the host gives it as join data, before
-- the player's game loads the world), so both games build the same items and enemies.
local logic = require("logic")

local character = {}

local MARK, ITEMS, ENEMIES, SEED, KEEP = 14000960, 14000961, 14000962, 14000963, 14000906
local SEED_BITS, KEEP_BITS = 32, 20
local HINTED, HINTED_BITS = 14000926, 7
-- Item kinds come first in the kept bits, then places.
local ITEM_KINDS = #logic.ITEM_TYPES
-- A character this young (play time, seconds) hasn't been in the world yet: it's new.
local NEW_SECONDS = 60

local function bits(first, count)
  local value = 0
  for k = 0, count - 1 do
    if kindle.flags.get(first + k) then value = value | (1 << k) end
  end
  return value
end

local function set_bits(first, count, value)
  for k = 0, count - 1 do
    kindle.flags.set(first + k, (value >> k) & 1 == 1)
  end
end

-- A run: {seed, items, enemies, keep}. Whether it keeps item kind `name` vanilla.
function character.keeps_item(run, name) return (run.keep >> logic.TYPE_BIT[name]) & 1 == 1 end
function character.keeps_place(run, name) return (run.keep >> (ITEM_KINDS + logic.ORIGIN_BIT[name])) & 1 == 1 end

-- The run as text, for logs and to tell runs apart.
function character.describe(run)
  if not run then return "vanilla" end
  return string.format("seed %d (items %s, enemies %s, kept %#x)", run.seed, tostring(run.items), tostring(run.enemies), run.keep)
end

-- The loaded character's own run, or nil.
local function read()
  if not kindle.flags.get(MARK) then return nil end
  return { seed = bits(SEED, SEED_BITS), items = kindle.flags.get(ITEMS), enemies = kindle.flags.get(ENEMIES), keep = bits(KEEP, KEEP_BITS) }
end

local function write(run)
  set_bits(SEED, SEED_BITS, run.seed)
  set_bits(KEEP, KEEP_BITS, run.keep)
  kindle.flags.set(ITEMS, run.items)
  kindle.flags.set(ENEMIES, run.enemies)
  kindle.flags.set(MARK, true)
end

-- The seed for what was typed in the Seed box: empty or 0 is rolled (0), a number is itself,
-- anything else (a word, a phrase) is hashed to one (FNV-1a over the trimmed text; never 0), so a
-- seed can be shared as a word.
function character.seed_from_text(text)
  text = (text or ""):match("^%s*(.-)%s*$")
  if text == "" then return 0 end
  local number = math.tointeger(tonumber(text))
  if number and number >= 0 and number <= 0xFFFFFFFF and text:match("^%d+$") then return number end
  local hash = 0x811C9DC5
  for i = 1, #text do
    hash = ((hash ~ text:byte(i)) * 0x01000193) & 0xFFFFFFFF
  end
  return math.max(hash, 1)
end

-- A run from the creation screen's choices (nil if neither items nor enemies are on).
function character.from_choices(choices)
  if not (choices.items or choices.enemies) then return nil end
  local keep = 0
  for _, name in ipairs(logic.ITEM_TYPES) do
    if choices["item_" .. name] == false then keep = keep | (1 << logic.TYPE_BIT[name]) end
  end
  for _, name in ipairs(logic.ORIGINS) do
    if choices["place_" .. name] == false then keep = keep | (1 << (ITEM_KINDS + logic.ORIGIN_BIT[name])) end
  end
  local seed = character.seed_from_text(choices.seed)
  if seed == 0 then seed = math.random(1, 0xFFFFFFFF) end
  return { seed = seed, items = choices.items == true, enemies = choices.enemies == true, keep = keep }
end

local last_said

local function say(run, where)
  local text = where .. character.describe(run)
  if text ~= last_said then
    kindle.log.info("%s", text)
    last_said = text
  end
end

-- The run to play now, deciding and storing one for a new character: in a co-op host's world the
-- host's (nil for a vanilla host or one without this mod), else the character's own.
function character.current()
  if kindle.net.role() == "player" then
    local host = kindle.net.welcome("run")
    local run = type(host) == "table" and host or nil
    say(run, "in the host's world: ")
    return run
  end
  local run = read()
  if not run and kindle.player.play_time() < NEW_SECONDS then
    run = character.from_choices(kindle.ui.character_choices())
    kindle.ui.reset_character_choices()
    if run then
      write(run)
      kindle.log.info("a new character: %s", character.describe(run))
    end
  end
  say(run, "this character: ")
  return run
end

-- The key item number the loaded character last bought a hint for, or nil.
function character.hinted()
  local value = bits(HINTED, HINTED_BITS)
  if value == 0 then return nil end
  return value
end

function character.set_hinted(number)
  if number >= (1 << HINTED_BITS) then error("key item " .. number .. " doesn't fit the hint flags") end
  set_bits(HINTED, HINTED_BITS, number)
end

return character
