pairs = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ["<"] = ">",
}

syntaxPoints = {
  [")"] = 3,
  ["]"] = 57,
  ["}"] = 1197,
  [">"] = 25137,
}

lines = {}
for line in io.lines("input.txt") do
  table.insert(lines, line)
end

points = 0
for _, line in ipairs(lines) do
  local stack = {}
  for char in string.gmatch(line, ".") do
    if pairs[char] ~= nil then -- it's an opening character
      table.insert(stack, char)
    else -- it's a closing character
      if pairs[table.remove(stack)] ~= char then -- pop an element off the stack. if char is not the closing pair of the element, syntax error
        print("error on: ", char)
        points = points + syntaxPoints[char]
        goto nextline
      end
    end
  end
  ::nextline::
end
print(points)
