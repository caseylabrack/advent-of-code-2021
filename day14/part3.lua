-- sum = 4
-- for i=1,40 do
--   sum = sum + (sum - 1)
--   print(sum)
-- end

data  = assert(io.open("input.txt", "r"))

template = data:read("l")
data:read("l") -- blank line

rules = {}
for line in data:lines() do
  local pair, ins = string.match(line, "^(%a%a).*(%a)")
  rules[pair] = ins
end

letters = {}
for key, value in pairs(rules) do
  letters[value] = 0
end

function pair (str, i)
  if i == 40 then
    local s1 = string.sub(str,1,1)
    local s2 = string.sub(str,2,2)
    -- print(s1)
    letters[s1] = letters[s1] + 1
    letters[s2] = letters[s2] + 1
  else
    i = i + 1
    pair(string.sub(str,1,1) .. rules[str], i)
    pair(rules[str] .. string.sub(str,2,2), i)
  end
end

pair("NN", 1)
pair("NC", 1)
pair("CB", 1)
