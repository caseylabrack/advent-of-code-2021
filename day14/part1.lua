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

-- for i=1,1 do
--   matches = {}
--   for key, value in pairs(rules) do
--     local idx = string.find(template, key)
--     if idx ~= nil then
--       table.insert(matches, {match = key, index = idx})
--     end
--   end
--
--   table.sort(matches, function (a,b) return a.index < b.index end)
--
--   pos = 1
--   newtemp = template
--   for _, match in ipairs(matches) do
--     print(match.match, match.index)
--     local swapwith = string.sub(match,1,1) .. rules[match] .. string.sub(match,2,2)
--     newtemp = string.gsub(newtemp, match, swapwith, pos)
--   end
--   template = newtemp
--   print(template)
-- end
