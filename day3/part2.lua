nums = {}
for line in io.lines("input.txt") do
  table.insert(nums, line)
end

bits = #nums[1] -- number of bits in pattern

-- oxygen get
oxynums = {}
table.move(nums, 1, #nums, 1, oxynums) -- oxynums is clone of nums
for i=1,bits do -- for each bit
  local oxyfilter = ""
  local ones = 0
  for _, num in ipairs(oxynums) do -- in each number
    if string.sub(num,i,i) == "1" then ones = ones + 1 end
  end
  if ones >= #oxynums/2 then
    oxyfilter = "1"
  else
    oxyfilter = "0"
  end

  temp = {}
  for _, num in ipairs(oxynums) do
    if string.sub(num,i,i) == oxyfilter then
      table.insert(temp, num)
    end
  end
  oxynums = temp
  if #temp == 1 then break end
end

-- CO2 get
co2nums = {}
table.move(nums, 1, #nums, 1, co2nums) -- co2nums is clone of nums
for i=1,bits do -- for each bit
  local co2filter = ""
  local ones = 0
  for _, num in ipairs(co2nums) do -- in each number
    if string.sub(num,i,i) == "1" then ones = ones + 1 end
  end
  if ones >= #co2nums/2 then
    co2filter = "0"
  else
    co2filter = "1"
  end

  temp = {}
  for _, num in ipairs(co2nums) do
    if string.sub(num,i,i) == co2filter then
      table.insert(temp, num)
    end
  end
  co2nums = temp
  if #temp == 1 then break end
end

oxy = tonumber(oxynums[1],2)
co2 = tonumber(co2nums[1],2)

print(string.format("oxygen: %d", oxy))
print(string.format("co2: %d", co2))
print(string.format("multiplied: %d", oxy * co2))
