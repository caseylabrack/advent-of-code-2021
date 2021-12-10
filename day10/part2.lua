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

autocompletePoints = {
  [")"] = 1,
  ["]"] = 2,
  ["}"] = 3,
  [">"] = 4,
}

lines = {}
for line in io.lines("input.txt") do
  table.insert(lines, line)
end

-- make a list of incomplete lines (filtering out syntax errors)
incomplete = {}
for _, line in ipairs(lines) do
  local stack = {}
  for char in string.gmatch(line, ".") do -- for every char
    if pairs[char] ~= nil then -- it's an opening character, push to stack
      table.insert(stack, char)
    else -- it's a closing character
      if pairs[table.remove(stack)] ~= char then -- pop an element off the stack. if char is not the closing pair of the element, syntax error
        goto nextline
      end
    end
  end
  table.insert(incomplete, line) -- line had no syntax errors; must be incomplete instead
  ::nextline::
end

-- make a list of autocomplete scores
scores = {}
for _, line in ipairs(incomplete) do
  local stack = {}
  for char in string.gmatch(line, ".") do
    if pairs[char] ~= nil then -- it's an opening character
      table.insert(stack, char) -- push to the stack
    else -- it's a closing character
      table.remove(stack) -- pop from the stack
    end
  end
  local score = 0
  while #stack > 0 do -- pop and close the remaing elements
    score = score * 5 + autocompletePoints[pairs[table.remove(stack)]] -- pop a stack element, get its closing pair, get that closing char's value
  end
  table.insert(scores, score)
end

table.sort(scores)
print(scores[(#scores+1)/2])
