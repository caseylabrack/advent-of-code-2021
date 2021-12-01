depths = {}
for line in io.lines("input.txt") do
  table.insert(depths, line + 0.0)
end

groups = {}
for i=1, #depths-2 do
  table.insert(groups, depths[i] + depths[i+1] + depths[i+2])
end

increased = 0
for i=2, #groups do
  if groups[i] > groups[i-1] then
    increased = increased + 1
  end
end

print(string.format("increased %d times", increased))
