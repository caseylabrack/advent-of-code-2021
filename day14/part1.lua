data  = assert(io.open("input.txt", "r"))

template = data:read("l")
data:read("l") -- blank line

rules = {}
for line in data:lines() do
  local pair, ins = string.match(line, "^(%a%a).*(%a)")
  rules[pair] = ins
end

for i=1,10 do
  new = template
  s = 1
  while(s <= string.len(new)) do
    local chunk = string.sub(new, s, s+1)
    for match, swapwith in pairs(rules) do
      if match == chunk then
        new = string.sub(new, 1, s) .. swapwith .. string.sub(new, s+1, string.len(new))
        s = s + 1
      end
    end
    s = s + 1
  end
  template = new
  -- print(string.format("after step %d: %s", i, template))
end

letters = {}
for i=1,string.len(template) do
  local char = string.sub(template,i,i)
  if letters[char] == nil then
    letters[char] = 1
  else
    letters[char] = letters[char] + 1
  end
end

mostFreqChar = ""
mostFreqNum = -math.huge
leastFreqChar = ""
leastFreqNum = math.huge

for char, num in pairs(letters) do
  if num > mostFreqNum then
    mostFreqNum = num
    mostFreqChar = char
  end
  if num < leastFreqNum then
    leastFreqNum = num
    leastFreqChar = char
  end
end

print(mostFreqChar, mostFreqNum)
print(leastFreqChar, leastFreqNum)
print(mostFreqNum - leastFreqNum)
