-- The character creation screen's rows: "Randomizer" opens a page (what moves for the character
-- being made) and "Seed" the game's text box. character.lua takes what they hold when it sees the
-- new character. The page starts from the mod's settings (Randomize items, Randomize enemies).

local creation = {}

local ITEM_KINDS = {
  { "weapons", "Weapons", "On: weapons are shuffled. Off: they stay where they are." },
  { "armor", "Armor", "On: armor is shuffled. Off: it stays where it is." },
  { "rings", "Rings", "On: rings are shuffled. Off: they stay where they are." },
  { "spells", "Spells", "On: spells are shuffled. Off: they stay where they are." },
  { "key_items", "Key items", "On: the items the game needs are shuffled (always reachable). Off: they stay." },
  { "upgrades", "Titanite and gems", "On: upgrade materials are shuffled. Off: they stay where they are." },
  { "shards", "Estus and bone shards", "On: Estus Shards and Undead Bone Shards are shuffled. Off: they stay." },
  { "souls", "Soul items", "On: soul items are shuffled. Off: they stay where they are." },
  { "boss_souls", "Boss souls", "On: boss souls are shuffled. Off: they stay where they are." },
  { "ashes", "Handmaid's ashes", "On: the ashes that stock the Handmaid's shop are shuffled. Off: they stay." },
  { "tomes", "Tomes and scrolls", "On: tomes, scrolls and coals are shuffled. Off: they stay where they are." },
  { "unique", "Other unique items", "On: other one-of-a-kind items are shuffled. Off: they stay where they are." },
  { "consumables", "Consumables", "On: consumables are shuffled. Off: they stay where they are." },
}

local PLACES = {
  { "map", "Pickups", "On: items lying in the world are shuffled. Off: they stay." },
  { "boss", "Boss rewards", "On: boss rewards are shuffled. Off: they stay." },
  { "drop", "Enemy drops", "On: one-time enemy drops are shuffled. Off: they stay." },
  { "npc", "NPC gifts", "On: what NPCs give and drop is shuffled. Off: it stays." },
  { "event", "Event rewards", "On: scripted rewards are shuffled. Off: they stay." },
  { "handmaid", "Shrine Handmaid", "On: the Handmaid's shop is shuffled. Off: it stays." },
  { "npcshop", "Other shops", "On: other NPCs' shops are shuffled. Off: they stay." },
}

local function switches(list, prefix)
  local out = {}
  for _, entry in ipairs(list) do
    out[#out + 1] = { key = prefix .. entry[1], label = entry[2], help = entry[3], default = true }
  end
  return out
end

-- Puts the rows on the creation screen (again when the settings change their defaults).
function creation.add_rows()
  kindle.ui.character_rows {
    {
      label = "Randomizer",
      help = "Set up the randomizer for this character",
      page = {
        {
          title = "Randomizer",
          icon = "skulls",
          switches = {
            { key = "items", label = "Randomize items", help = "Shuffle pickups, rewards, drops and shops. The game can always be finished.", default = kindle.settings.get("items") },
            { key = "enemies", label = "Randomize enemies", help = "Enemies of other types, from anywhere in the game.", default = kindle.settings.get("enemies") },
          },
        },
        { title = "Item types", icon = "equipment", switches = switches(ITEM_KINDS, "item_") },
        { title = "Places", icon = "shrine", switches = switches(PLACES, "place_") },
      },
    },
    { label = "Seed", help = "Set seed: a number or any word. Empty: random", text = { key = "seed", empty = "random" } },
  }
end

return creation
