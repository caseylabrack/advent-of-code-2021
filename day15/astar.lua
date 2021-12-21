local astar = {}

-- find an optimal path through a map
-- takes a 2d array "map" of objects with x and y properties
-- heuristic is a function for estimating distance between points
-- optional costAccessor function retrieves (or computes) the cost of traveling to each node
-- costAccessor defaults to retrieving property "cost" from node
-- returns goal node in a backward linked list leading to the start along an optimal path
function astar.path (map, start, goal, heuristic, costAccessor)

  costAccessor = costAccessor or function (o) return o.cost end

  local openset = {}
  table.insert(openset, start)

  start.g = 0
  -- dist = heuristic(start, goal)
  start.f = heuristic(start, goal)

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
      return current
    else
      -- find neighbors
      table.remove(openset, indexOfCurrent)
      local neighbors = {}
      if map2[current.y-1] ~= nil then table.insert(neighbors, map2[current.y-1][current.x]) end
      if map2[current.y+1] ~= nil then table.insert(neighbors, map2[current.y+1][current.x]) end
      if map2[current.y][current.x+1] ~= nil then table.insert(neighbors, map2[current.y][current.x+1]) end
      if map2[current.y][current.x-1] ~= nil then table.insert(neighbors, map2[current.y][current.x-1]) end

      -- eval neighbors
      for _, neighbor in ipairs(neighbors) do
        local distCost = costAccessor(neighbor)
        local testGScore = current.g + distCost
        if testGScore < (neighbor.g or math.huge) then
          neighbor.cameFrom = current
          neighbor.g = testGScore
          neighbor.f = testGScore + heuristic(current, neighbor)

          local inOpenSet = false
          for _, node in pairs(openset) do
            if node == neighbor then inOpenSet = true end
          end
          if inOpenSet == false then
            table.insert(openset, neighbor)
          end
        end
      end
    end
  end
end

return astar
