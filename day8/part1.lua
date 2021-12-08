-- 0: 6
-- 1: 2
-- 2: 5
-- 3: 5
-- 4: 4
-- 5: 5
-- 6: 6
-- 7: 3
-- 8: 7
-- 9: 6

entries = {}
for line in io.lines("input.txt") do
  local entry = {}
  entry.digits = string.match(line, "([a-g ]+)%s|")
  entry.output = string.match(line, "|%s([a-g ]+)")
  table.insert(entries, entry)
end

easyDigits = 0
for _, entry in ipairs(entries) do
  for code in string.gmatch(entry.output, "[a-g]+") do
    local l = string.len(code)
    if (l == 2 or l == 3 or l == 4 or l == 7) then
      easyDigits = easyDigits + 1
    end
  end
end

print(easyDigits)
