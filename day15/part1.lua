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

function manhattanDist (p1, p2)
  return math.abs(p1.x-p2.x) + math.abs(p1.y-p2.y)
end

function astar (start, goal, heuristic)
  openset = {}
  table.insert(openset, start)

  start.g = 0
  dist = heuristic(start, goal)
  start.f = dist

  while #openset > 0 do
    current = {}
    lowestF = math.huge
    indexOfCurrent = -1
    for idx, node in pairs(openset) do
      if lowestF > node.f then
        lowestF = node.f
        current = node
        indexOfCurrent = idx
      end
    end

    if current == goal then
      print("done")
      return
    else
      -- find neighbors
      table.remove(openset, indexOfCurrent)
      local neighbors = {}
      if map[current.y-1] ~= nil then table.insert(neighbors, map[current.y-1][current.x]) end
      if map[current.y+1] ~= nil then table.insert(neighbors, map[current.y+1][current.x]) end
      if map[current.y][current.x+1] ~= nil then table.insert(neighbors, map[current.y][current.x+1]) end
      if map[current.y][current.x-1] ~= nil then table.insert(neighbors, map[current.y][current.x-1]) end

      -- eval neighbors
      for _, neighbor in ipairs(neighbors) do
        distCost = neighbor.risk
        testGScore = current.g + distCost
        if testGScore < (neighbor.g or math.huge) then
          neighbor.cameFrom = current
          neighbor.g = testGScore
          neighbor.f = testGScore + heuristic(current, neighbor)

          inOpenSet = false
          for _, node in pairs(openset) do
            if node == neighbor then inOpenSet = true end
          end
          if inOpenSet == false then
            table.insert(openset, neighbor)
            print("adding node: ", neighbor.x, neighbor.y, neighbor.risk)
          end
        end
      end
    end
  end
end

astar(map[1][1], map[#map][#map[1]], manhattanDist)

guy = current
sum = 0
while true do
  if guy.x == 1 and guy.y == 1 then
    break
  else
    sum = sum + guy.risk
    guy = guy.cameFrom
  end
end

print(current.f - map[1][1].risk)
print(sum)
