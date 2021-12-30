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

-- keys are the opcodes, values are the ops
-- all ops take a table of values as input
ops = {
  [0] = function (t) sum = 0 for idx, val in ipairs(t) do sum = sum + val end return sum end,
  [1] = function (t) prod = 1 for idx, val in ipairs(t) do prod = prod * val end return prod end,
  [2] = function (t) min = math.huge for idx, val in ipairs(t) do if min > val then min = val end end return min end,
  [3] = function (t) max = -math.huge for idx, val in ipairs(t) do if max < val then max = val end end return max end,
  [5] = function (t) if t[1] > t[2] then return 1 else return 0 end end,
  [6] = function (t) if t[1] < t[2] then return 1 else return 0 end end,
  [7] = function (t) if t[1] == t[2] then return 1 else return 0 end end,
}

f = assert(io.open("input.txt", "r"))
data = f:read("l")
f:close()

-- expand the hexadecimal puzzle input into binary string
hex = ""
for char in string.gmatch(data, ".") do
  hex = hex .. hexLookUp[char]
end

-- parse binary string into hierarchy of packets
-- recursive
-- not a pure function, don't @ me
function parse (parent, ptr)
  local pak = {}
  pak.parent = parent
  pak.version = tonumber(string.sub(hex, ptr, ptr + 3 - 1), 2)
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
  end
  table.insert(parent, pak)

  -- also add to the global list of packets sorted by level
  do -- count up parents to find packet level
    pak.level = 0
    local p = pak.parent
    while p ~= nil do
      pak.level = pak.level + 1
      p = p.parent
    end
  end
  if levels[pak.level] == nil then levels[pak.level] = {} end
  table.insert(levels[pak.level], pak)

  return ptr
end

packets = {} -- the hierarchy of packets
levels = {} -- global list of packets sorted by level. e.g. levels[2] = list of all packets at level 2 of hierarchy
parse(packets, 1)

-- only the leaves of the packet hierarchy are guaranteed to have a value
-- starting at one level above the leaves, work backward up the packet hierarchy
-- add values to operator packets using their opcodes
for i=#levels-1,1,-1 do
  for _, packet in ipairs(levels[i]) do
    packet.subpacketValues = {}
    for _, subpacket in ipairs(packet) do
      table.insert(packet.subpacketValues, subpacket.value)
    end
    if packet.id~=4 then packet.value = ops[packet.id](packet.subpacketValues) end
  end
end

-- the solution is the value of the root node
print(packets[1].value)
