depths = {}

for line in io.lines("input.txt") do
  table.insert(depths, line + 0.0)
end

increased = 0
for i=2, #depths do
  if depths[i] > depths[i-1] then
    increased = increased + 1
  end
end

print(string.format("increased %d times", increased))
