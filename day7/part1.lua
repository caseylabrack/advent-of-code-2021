f = assert(io.open("input.txt", "r"))
data = f:read("a")
f:close()

crabs = {}
for num in string.gmatch(data, "%d+") do
  table.insert(crabs, num + 0.0)
end

max = -math.huge
for _, crab in ipairs(crabs) do
  if max < crab then max = crab end
end

fuel = {}
for i=0,max do
  fuel[i] = 0
  for _, crab in ipairs(crabs) do
    fuel[i] = fuel[i] + math.abs(i - crab)
  end
end

minfuel = math.huge
minfuelIndex = -1
for idx, f in ipairs(fuel) do
  if f < minfuel then
    minfuel = f
    minfuelIndex = idx
  end
end

print(minfuel)
