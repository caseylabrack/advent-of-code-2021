local astar = require "astar"

data  = assert(io.open("input.txt", "r"))

-- 2d array of objects with x, y, and risk properties
map = {}
for row=1,math.huge do
  local line = data:read("l")
  if line==nil then break end
  local r = {}
  col = 1
  for num in string.gmatch(line, "%d") do
    local node = {x = col, y = row, risk = tonumber(num)}
    table.insert(r, node)
    col = col + 1
  end
  table.insert(map, r)
end

-- bigger map
map2 = {}
for i=1,#map * 5 do
  map2[i] = {}
  for j=1,#map[1] * 5 do
    map2[i][j] = {}
    local mod = i % #map
    local referenceI = math.huge
    if mod==0 then referenceI = #map else referenceI = mod end

    local mod2 = j % #map[1]
    local referenceJ = math.huge
    if mod2==0 then referenceJ = #map[1] else referenceJ = mod2 end

    local referenceRisk = map[referenceI][referenceJ].risk
    local newRisk = (map[referenceI][referenceJ].risk + math.floor((i-1)/#map) + math.floor((j-1)/#map[1])) % 9
    if newRisk == 0 then newRisk = 9 end
    -- local newRisk =  ((referenceRisk + math.floor(i / 10) - 1) % 9) + 1
    map2[i][j].risk = newRisk
    map2[i][j].x = j
    map2[i][j].y = i
  end
end

-- debug larger map
-- print(#map2, #map2[1])
-- for i=1,#map2 do
--   io.write("index: " .. i .. " ")
--   for j=1,#map2[1] do
--     io.write(map2[i][j].risk)
--   end
--   io.write("\n")
-- end

function manhattanDist (p1, p2)
  return math.abs(p1.x-p2.x) + math.abs(p1.y-p2.y)
end

endpoint = astar.path(map2, map2[1][1], map2[#map2][#map2[1]], manhattanDist, function (o) return o.risk end)

-- backtrack through nodes on optimal path, summing risk
sum = 0
while true do
  if endpoint.x == 1 and endpoint.y == 1 then
    break
  else
    sum = sum + endpoint.risk
    endpoint = endpoint.cameFrom
  end
end

print(sum)
