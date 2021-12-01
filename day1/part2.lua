depths = {}

for line in io.lines("input.txt") do
  table.insert(depths, line + 0.0)
end

groups = {}
for i=1, #depths-2 do
  sum = depths[i] + depths[i+1] + depths[i+2]
  table.insert(groups, sum)
end

increased = 0
for i=2, #groups do
  if groups[i] > groups[i-1] then
    increased = increased + 1
  end
end

print(string.format("increased %d times", increased))
