sub = {x = 0, y = 0, aim = 0}
for line in io.lines("input.txt") do
  dir = string.match(line, "%w+") -- word
  mag = string.match(line, "%d+") -- digits
  if dir == "forward" then
    sub.x = sub.x + mag
    sub.y = sub.y + sub.aim * mag
  end
  if dir == "up"      then sub.aim = sub.aim - mag end
  if dir == "down"    then sub.aim = sub.aim + mag end
end

print(string.format("sub position: (%d, %d)", sub.x, sub.y))
print(string.format("multiplied: %d", sub.x * sub.y))
