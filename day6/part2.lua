f = assert(io.open("input.txt", "r"))
data = f:read("a")
f:close()

-- an array to track how many fish there are at each age
fishes = {}
for i=0,8 do
  fishes[i] = 0
end

-- count number of fish at each age
for num in string.gmatch(data, "%d") do
  local n = tonumber(num)
  fishes[n] = fishes[n] + 1
end

-- every day, every fish's age decrements.
-- age 0 fish are breeders. they become age 6
-- and they create all of the current age 8 fish (newborns)
for i=1,256 do
  local breeders = fishes[0]
  table.move(fishes,1,8,0) -- shift each element down one.
  fishes[6] = fishes[6] + breeders
  fishes[8] = breeders
end

sum = 0
for idx, fish in pairs(fishes) do
  sum = sum + fish
end
print(sum)
