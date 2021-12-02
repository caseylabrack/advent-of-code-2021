sub = {x = 0, y = 0}
for line in io.lines("input.txt") do
  dir = string.match(line, "%w+") -- word
  mag = string.match(line, "%d+") -- digits
  if dir == "forward" then sub.x = sub.x + mag end
  if dir == "up"      then sub.y = sub.y - mag end
  if dir == "down"    then sub.y = sub.y + mag end
end

print(string.format("sub position: (%d, %d)", sub.x, sub.y))
print(string.format("multiplied: %d", sub.x * sub.y))
