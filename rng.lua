-- The randomizer's random numbers: xoshiro256** seeded through splitmix64, on Lua's 64-bit
-- integers (they wrap as unsigned ones do; >> is a logical shift). Fixed here so a seed gives
-- the same world on every machine and every version that keeps this file.
local rng = {}
rng.__index = rng

local function rotate_left(value, bits)
  return (value << bits) | (value >> (64 - bits))
end

-- `value` (an unsigned 64-bit number in a Lua integer) modulo `divisor` (a positive number).
local function unsigned_mod(value, divisor)
  if value >= 0 then return value % divisor end
  local half = (value >> 1) % divisor
  return (2 * half + (value & 1)) % divisor
end

function rng.new(seed)
  local state = seed
  local function next_seed()
    state = state + 0x9E3779B97F4A7C15
    local mixed = state
    mixed = (mixed ~ (mixed >> 30)) * 0xBF58476D1CE4E5B9
    mixed = (mixed ~ (mixed >> 27)) * 0x94D049BB133111EB
    return mixed ~ (mixed >> 31)
  end
  local s0 = next_seed()
  local s1 = next_seed()
  local s2 = next_seed()
  local s3 = next_seed()
  return setmetatable({ s0, s1, s2, s3 }, rng)
end

function rng:next_u64()
  local result = rotate_left(self[2] * 5, 7) * 9
  local shifted = self[2] << 17
  self[3] = self[3] ~ self[1]
  self[4] = self[4] ~ self[2]
  self[2] = self[2] ~ self[3]
  self[1] = self[1] ~ self[4]
  self[3] = self[3] ~ shifted
  self[4] = rotate_left(self[4], 45)
  return result
end

-- A number in 0..count-1 (count > 0), without modulo bias.
function rng:below(count)
  local zone = -1 - unsigned_mod(-1, count)
  while true do
    local value = self:next_u64()
    if math.ult(value, zone) then return unsigned_mod(value, count) end
  end
end

-- Shuffles a list in place (as Rust's: from the end, each swapped with one at or before it).
function rng:shuffle(list)
  for i = #list, 2, -1 do
    local j = self:below(i) + 1
    list[i], list[j] = list[j], list[i]
  end
end

return rng
