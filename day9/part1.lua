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
      table.insert(lowpoints, points[row][col])
    end
  end
end

sum = 0
for _, lowpoint in ipairs(lowpoints) do
  sum = sum + 1 + lowpoint
end

print(sum)
