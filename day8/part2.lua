-- my convention for numbering the 7 sectors
-- used in the `sectors` array
--
--    111
-- 222   333
--    444
-- 555   666
--    777

function stringToTable (str)
  t = {}
  str:gsub(".", function(c) table.insert(t,c) end)
  return t
end

-- string -> alphabetized string
function stringSort (str)
  t = stringToTable(str)
  table.sort(t)
  return table.concat(t)
end

function decode (ent)
  digits = {}
  for digit in string.gmatch(ent.alldigits, "[a-g]+") do
    table.insert(digits, stringSort(digit))
  end

  table.sort(digits, function (a,b) return string.len(a) < string.len(b) end)
  numbers = {}
  -- numbers[0] = ???
  numbers[1] = digits[1]
  -- numbers[2] = ???
  -- numbers[3] = ???
  numbers[4] = digits[3]
  -- numbers[5] = ???
  numbers[7] = digits[2]
  -- numbers[6] = ???
  numbers[8] = digits[10]
  -- numbers[9] = ???

  sectors = {}

  -- find sector 1
  for letter in string.gmatch(numbers[7], "[a-g]") do
    if string.match(numbers[1], letter) == nil then
      sectors[1] = letter
      break
    end
  end

  -- find sectors 3 and 6
    -- find the numbers 0, 6, 9
  lengthsix = {}
  for _, digit in ipairs(digits) do
    if string.len(digit) == 6 then
      table.insert(lengthsix, digit)
    end
  end

    -- find number 6
    -- number six doesn't have both sectors used by number 1
  for _, code in ipairs(lengthsix) do
    if string.match(code, numbers[1]) == nil then
      numbers[6] = code
    end
  end

    -- which sector from number 1 is number 6 missing?
    -- that will be sector 3. the other sector in number 1 is sector 6
  if string.match(numbers[6], string.sub(numbers[1], 1, 1)) == nil then
    sectors[3] = string.sub(numbers[1], 1, 1)
    sectors[6] = string.sub(numbers[1], 2, 2)
  else
    sectors[3] = string.sub(numbers[1], 2, 2)
    sectors[6] = string.sub(numbers[1], 1, 1)
  end

  -- find sectors 4, 7
    -- find numbers 2, 3, 5
  lengthfive = {}
  for _, digit in ipairs(digits) do
    if string.len(digit) == 5 then
      table.insert(lengthfive, digit)
    end
  end
    -- find number 3
    -- number 3 doesn't have both sectors used by number 1
  for _, code in ipairs(lengthfive) do
    if string.match(code, string.sub(numbers[1],1,1)) ~= nil and string.match(code, string.sub(numbers[1],2,2)) then
      numbers[3] = code
    end
  end

    -- find the two sectors in number 3 not yet identified
  knownsectorsString = stringSort(sectors[1] .. sectors[3] .. sectors[6])
  knownsectorsTable = stringToTable(knownsectorsString)
  numberThreeAsTable = stringToTable(numbers[3])
  unknownsectors = {}
  for _, code in ipairs(numberThreeAsTable) do
    if string.match(knownsectorsString, code) == nil then
      table.insert(unknownsectors, code)
    end
  end

    -- find which unknown sector from three is in number 4
  for letter in string.gmatch(numbers[4], ".") do
    if unknownsectors[1] == letter then
      sectors[4] = letter
      sectors[7] = unknownsectors[2]
      break
    end
    if unknownsectors[2] == letter then
      sectors[4] = letter
      sectors[7] = unknownsectors[1]
    end
  end

  -- find sector 2
    -- find the unknown sector in number 4
  knownsectorsInFourTable = stringToTable(stringSort(sectors[3] .. sectors[4] .. sectors[6]))
  local four = numbers[4]
  for _, sector in ipairs(knownsectorsInFourTable) do
    four = string.gsub(four, sector, "")
  end
  sectors[2] = four

  -- find sector 5
  -- it's whatever one we haven't entered into sectors yet
  alphas = "abcdefg"
  for _, value in pairs(sectors) do
    alphas = string.gsub(alphas, value, "")
  end
  sectors[5] = alphas

  -- fill in remaining numbers
  numbers[0] = stringSort(sectors[1] .. sectors[2] .. sectors[3] .. sectors[5] .. sectors[6] .. sectors[7])
  numbers[2] = stringSort(sectors[1] .. sectors[3] .. sectors[4] .. sectors[5] .. sectors[7])
  numbers[3] = stringSort(sectors[1] .. sectors[3] .. sectors[4] .. sectors[6] .. sectors[7])
  numbers[5] = stringSort(sectors[1] .. sectors[2] .. sectors[4] .. sectors[6] .. sectors[7])
  numbers[6] = stringSort(sectors[1] .. sectors[2] .. sectors[4] .. sectors[5] .. sectors[6] .. sectors[7])
  numbers[9] = stringSort(sectors[1] .. sectors[2] .. sectors[3] .. sectors[4] .. sectors[6] .. sectors[7])

  output = ""
  for code in string.gmatch(ent.output, "[a-g]+") do
    for idx, key in ipairs(numbers) do
      -- print(key, code)
      if key == stringSort(code) then
        output = output .. idx
        break
      end
    end
  end
  return tonumber(output)
end

entries = {}
for line in io.lines("input.txt") do
  local entry = {}
  entry.alldigits = string.match(line, "([a-g ]+)%s|")
  entry.output = string.match(line, "|%s([a-g ]+)")
  table.insert(entries, entry)
end

sum = 0
for idx, entry in ipairs(entries) do
  print(idx)
  sum = sum + decode(entry)
end
print(sum)
