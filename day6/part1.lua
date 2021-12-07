f = assert(io.open("input.txt", "r"))
data = f:read("a")
f:close()

fishes = {}
for num in string.gmatch(data, "%d+") do
  table.insert(fishes, num)
end

for i=1,80 do
  for j=1,#fishes do
    fishes[j] = fishes[j] - 1
  end
  local spawns = 0
  for k=1,#fishes do
    if fishes[k] == -1 then
      fishes[k] = 6
      spawns = spawns + 1
    end
  end
  for l=1,spawns do
    table.insert(fishes, 8)
  end

  --debug
  -- io.write("After " .. i .. " days: ")
  -- for _, fish in ipairs(fishes) do
  --   io.write(" " .. fish)
  -- end
  -- io.write("\n")
end

print(#fishes)
