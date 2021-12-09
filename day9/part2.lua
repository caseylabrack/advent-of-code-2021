points = {}
for line in io.lines("input.txt") do
  local p = {}
  for d in string.gmatch(line, "%d") do
    table.insert(p, d + 0.0)
  end
  table.insert(points, p)
end

lowpoints = {}
for row=1,#points do
  for col=1,#points[1] do
    local higherPointsFound = 0
    local sides = 4
    if row > 1 then
      if points[row-1][col] > points[row][col] then
        higherPointsFound = higherPointsFound + 1
      end
    else
      sides = sides - 1
    end
    if row < #points then
      if points[row+1][col] > points[row][col] then
        higherPointsFound = higherPointsFound + 1
      end
    else
      sides = sides - 1
    end
    if col > 1 then
      if points[row][col-1] > points[row][col] then
        higherPointsFound = higherPointsFound + 1
      end
    else
      sides = sides - 1
    end
    if col < #points[1] then
      if points[row][col+1] > points[row][col] then
        higherPointsFound = higherPointsFound + 1
      end
    else
      sides = sides - 1
    end
    if higherPointsFound == sides then
      table.insert(lowpoints, {row = row, col = col})
    end
  end
end

basinscores = {}
for _, lowpoint in ipairs(lowpoints) do
  local uncheckedpoints = {}
  local basinscore = 0
  if lowpoint.row > 1 then table.insert(uncheckedpoints, {row = lowpoint.row-1, col = lowpoint.col}) end
  if lowpoint.row < #points then table.insert(uncheckedpoints, {row = lowpoint.row+1, col = lowpoint.col}) end
  if lowpoint.col > 1 then table.insert(uncheckedpoints, {row = lowpoint.row, col = lowpoint.col-1}) end
  if lowpoint.col < #points[1] then table.insert(uncheckedpoints, {row = lowpoint.row, col = lowpoint.col+1}) end

  while #uncheckedpoints > 0 do
    last = uncheckedpoints[#uncheckedpoints]
    table.remove(uncheckedpoints, #uncheckedpoints)
    if points[last.row][last.col] < 9 then
      basinscore = basinscore + 1
      points[last.row][last.col] = math.huge -- prevent backtracking
      if last.row > 1 then table.insert(uncheckedpoints, {row = last.row-1, col = last.col}) end
      if last.row < #points then table.insert(uncheckedpoints, {row = last.row+1, col = last.col}) end
      if last.col > 1 then table.insert(uncheckedpoints, {row = last.row, col = last.col-1}) end
      if last.col < #points[1] then table.insert(uncheckedpoints, {row = last.row, col = last.col+1}) end
    end
  end
  table.insert(basinscores, basinscore)
end

table.sort(basinscores, function (a,b) return a > b end) -- sort descending
print(basinscores[1] * basinscores[2] * basinscores[3])
