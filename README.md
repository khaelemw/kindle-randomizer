# Randomizer

A [Kindle](#kindle) mod for Dark Souls III (version 1.15.2).

Items in new places, so that the game can always be finished, and enemies of other types from
anywhere in the game. You set it up for each character as you make it, on the character creation
screen, and the character keeps its run for good. Characters made without it play the game as it
is.

## Making a randomized character

1. Switch the mod on (below), then start **New Game**.
2. On the character creation screen, choose **Randomizer**. Its page has three tabs:
   - **Randomizer:** **Randomize items** and **Randomize enemies**.
   - **Item types:** which kinds of item move: weapons, armour, rings, spells, key items, titanite
     and gems, Estus and bone shards, soul items, boss souls, the Handmaid's ashes, tomes and
     scrolls, other unique items, consumables. Off: that kind stays where it is.
   - **Places:** where items move from and to: pickups, boss rewards, enemy drops, NPC gifts,
     event rewards, the Shrine Handmaid's shop, other shops.
3. **Seed:** type a number or any word, or leave it empty for a random one. Two characters made
   with the same seed and the same choices get the same run, on any PC: race a friend on the
   word you agree on. (A random seed is written to `Game\kindle\logs\kindle.log`, after
   "a new character".)
4. Make the character as usual. Its run is decided as it first loads into the world.

## Playing

- **Items.** The game can always be finished: each item you need to get on (keys, the Coiled
  Sword and the like) is always somewhere you can reach without it.
- **Enemies.** Each enemy can be any type from anywhere in the game, with that type's own
  strength, attacks and looks. A spot only gets an enemy that fits it (no giant in a corridor),
  and bosses, NPCs and the enemies the story needs stay as they are. With either DLC, its enemies
  join the mix.
- **Hints.** With items randomized, the bonfire's menu has **Randomizer hint (1000 souls)**: the
  next item you need and where it is. Asking again costs nothing until you have that item.
- **Co-op.** With the Co-op mod, a player in a randomized host's world plays the host's run, so
  both games have the same items and enemies. The player needs the DLCs the host's run uses.

## Settings

In the game (**Mods**, the **Kindle** tab, **All mod settings**, then Randomizer) or in Kindle
Launcher while the game is closed:

- **Randomize items** (off) and **Randomize enemies** (off): what the creation screen's page starts
  with for a new character. A character keeps what it was made with; these never change a
  character that's already made.

## Installing it

Install Kindle first ([khaelemw/kindle](https://github.com/khaelemw/kindle)). Then download `randomizer.zip` from this repo's Releases and unzip it into the game's `Game\kindle\mods` folder, so you have `Game\kindle\mods\randomizer\mod.toml`.

The Randomizer is off until you switch it on: at the title screen, choose
**Mods**, open the **Mods** tab and turn **Randomizer** on. Kindle Launcher's mod list does the same
while the game is closed.

## Removing it

Switch it off in **Mods**, or delete `Game\kindle\mods\randomizer`. Randomized characters then play
the game as it is from the next area that loads (what they picked up stays theirs). The run is kept
with the character, so switching the mod back on brings it back.

## Good to know

- The run is kept in the character's save, in a few of the game's flags nothing else uses.
- Kindle keeps the game off FromSoftware's servers while it runs (their terms don't allow modded
  play online). Kindle's Co-op mod connects players itself.

## Kindle

Kindle is a Lua modding runtime for Dark Souls III: mods are folders of Lua scripts, switched on
and off in game. This mod is plain Lua: `main.lua` and the files it loads (`logic.lua` decides
where items can go, `enemies.lua` which enemy stands where).
