points = {}
for line in io.lines("input.txt") do
  l = {}
  l.x1 = string.match(line, "(%d+),%d+%s-") + 0.0
  l.y1 = string.match(line, "%d+,(%d+)%s-") + 0.0
  l.x2 = string.match(line, ">%s(%d+),%d+") + 0.0
  l.y2 = string.match(line, ">%s%d+,(%d+)") + 0.0
  table.insert(points, l)
end

-- filter for straight lines
straightlines = {}
for _, l in ipairs(points) do
  if (l.x1 == l.x2) or (l.y1 == l.y2) then
    table.insert(straightlines, l)
  end
end

-- find bounds of map
xmax = -math.huge
ymax = -math.huge
for _, l in ipairs(straightlines) do
  if l.x1 > xmax then xmax = l.x1 end
  if l.x2 > xmax then xmax = l.x2 end
  if l.y1 > ymax then ymax = l.y1 end
  if l.y2 > ymax then ymax = l.y2 end
end

-- create 2d array representing map
map = {}
for i=0,ymax do
  map[i] = {}
  for j=0,xmax do
    map[i][j] = 0
  end
end

-- expand points into lines, mark on map
for _, line in ipairs(straightlines) do

  if line.x1 == line.x2 then -- vertical line
    local sign = 1
    if line.y1 > line.y2 then sign = -1 end
    for i=line.y1,line.y2,sign do
      map[i][line.x1] = map[i][line.x1] + 1
    end
  end

  if line.y1 == line.y2 then -- horizontal line
    local sign = 1
    if line.x1 > line.x2 then sign = -1 end
    for i=line.x1,line.x2,sign do
      map[line.y1][i] = map[line.y1][i] + 1
    end
  end

end

-- reproduce example diagram in stdout
-- for i=0,ymax do
--   for j=0,xmax do
--     if map[i][j] == 0 then
--       io.write(".")
--     else
--       io.write(map[i][j])
--     end
--   end
--     io.write("\n")
-- end

-- count squares with value >= 2
danger = 0
for i=0,ymax do
  for j=0,xmax do
    if map[i][j] >= 2 then danger = danger + 1 end
  end
end

print(danger)
