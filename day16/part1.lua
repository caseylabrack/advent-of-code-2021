hexLookUp = {
  ["0"] = "0000",
  ["1"] = "0001",
  ["2"] = "0010",
  ["3"] = "0011",
  ["4"] = "0100",
  ["5"] = "0101",
  ["6"] = "0110",
  ["7"] = "0111",
  ["8"] = "1000",
  ["9"] = "1001",
  ["A"] = "1010",
  ["B"] = "1011",
  ["C"] = "1100",
  ["D"] = "1101",
  ["E"] = "1110",
  ["F"] = "1111"
}

f = assert(io.open("input.txt", "r"))
data = f:read("l")
f:close()

-- expand the hexadecimal puzzle input into binary string
hex = ""
for char in string.gmatch(data, ".") do
  hex = hex .. hexLookUp[char]
end

versionsTotal = 0
function parse (parent, ptr)
  local pak = {}
  pak.version = tonumber(string.sub(hex, ptr, ptr + 3 - 1), 2)
  versionsTotal = versionsTotal + pak.version
  ptr = ptr + 3
  pak.id = tonumber(string.sub(hex, ptr, ptr + 3 - 1), 2)
  ptr = ptr + 3

  if pak.id == 4 then -- literal packet
    local num = ""
    repeat
      local fivebits = string.sub(hex, ptr, ptr + 5 - 1)
      local firstbit = string.sub(fivebits, 1, 1)
      num = num .. string.sub(fivebits, 2, 5)
      ptr = ptr + 5
    until firstbit ~= "1"
    pak.value = tonumber(num, 2)
    table.insert(parent, pak)
    return ptr
  else -- operator packet
    pak.lengthType = string.sub(hex, ptr, ptr)
    ptr = ptr + 1
    if pak.lengthType == "0" then
      pak.subpacketsSize = tonumber(string.sub(hex, ptr, ptr + 15 - 1), 2)
      ptr = ptr + 15
    else
      pak.subpacketsSize = tonumber(string.sub(hex, ptr, ptr + 11 - 1), 2)
      ptr = ptr + 11
    end
    local parsedSize = 0
    while parsedSize ~= pak.subpacketsSize do
      local oldptr = ptr
      ptr = parse(pak,ptr)
      if pak.lengthType == "0" then
        parsedSize = parsedSize + ptr - oldptr
      else
        parsedSize = parsedSize + 1
      end
    end

    table.insert(parent, pak)
    return ptr
  end
end

parse({}, 1)
print("versions total", versionsTotal)
