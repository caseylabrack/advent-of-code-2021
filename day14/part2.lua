data  = assert(io.open("input.txt", "r"))

template = data:read("l")
data:read("l") -- blank line

-- table of insertion rules
-- key = insertion pair, value = char to insert
rules = {}
for line in data:lines() do
  local pair, ins = string.match(line, "^(%a%a).*(%a)")
  rules[pair] = ins
end

-- parse template into list of insertion pairs
chempairs = {}
for i=1,string.len(template)-1 do
  local key = string.sub(template,i,i) .. string.sub(template,i+1,i+1)
  chempairs[key] = 1 + (chempairs[key] or 0)
end

-- table to hold letter counts
-- initialize with template letters
letters = {}
for char in string.gmatch(template, "%w") do
  letters[char] = 1 + (letters[char] or 0)
end

-- every iteration, every chempair spawns two chempairs
-- and adds a letter
for i=1,40 do
  newchempairs = {}
  for key, value in pairs(chempairs) do
    local t1 = string.sub(key, 1, 1) .. rules[key]
    local t2 = rules[key] .. string.sub(key, 2, 2)
    newchempairs[t1] = value + (newchempairs[t1] or 0)
    newchempairs[t2] = value + (newchempairs[t2] or 0)
    letters[rules[key]] = value + (letters[rules[key]] or 0)
  end
  chempairs = newchempairs
end

-- find most and least frequent letters
maxLetterNum = -math.huge
maxLetterChar = ""
minLetterNum = math.huge
minLetterChar = ""
for char, occurences in pairs(letters) do
  if occurences > maxLetterNum then
    maxLetterNum = occurences
    maxLetterChar = char
  end
  if occurences < minLetterNum then
    minLetterNum = occurences
    minLetterChar = char
  end
end

print("min letter", minLetterChar, minLetterNum)
print("max letter", maxLetterChar, maxLetterNum)
print("difference", maxLetterNum - minLetterNum)
