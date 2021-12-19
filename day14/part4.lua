data  = assert(io.open("input.txt", "r"))

template = data:read("l")
data:read("l") -- blank line

rules = {}
for line in data:lines() do
  local pair, ins = string.match(line, "^(%a%a).*(%a)")
  rules[pair] = ins
end

totals = {}
totals["NN"] = 1
totals["NC"] = 1
totals["CB"] = 1

letters = {}
letters["N"] = 2
letters["C"] = 1
letters["B"] = 1

for i=1,40 do
  print("Step", i)
  newtotals = {}
  for key, value in pairs(totals) do
    local t1 = string.sub(key, 1, 1) .. rules[key]
    local t2 = rules[key] .. string.sub(key, 2, 2)
    print("key: ", key, "becomes ", t1, t2)
    newtotals[t1] = value + (newtotals[t1] or 0)
    newtotals[t2] = value + (newtotals[t2] or 0)
    -- totals[key] = nil
    print("letter", rules[key], " was ", (letters[rules[key]] or 0), " now", value + (letters[rules[key]] or 0))
    letters[rules[key]] = value + (letters[rules[key]] or 0)
  end
  print("---")
  totals = newtotals
end

for key, value in pairs(newtotals) do
  print(key, value)
end
print("---")
for key, value in pairs(letters) do
  print(key, value)
end
