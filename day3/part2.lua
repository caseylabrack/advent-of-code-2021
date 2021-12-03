nums = {}
for line in io.lines("input.txt") do
  table.insert(nums, line)
end

bits = #nums[1] -- number of bits in pattern

function rating (criteria)
  ratingnums = {}
  table.move(nums, 1, #nums, 1, ratingnums) -- clone of nums
  for i=1,bits do -- for each bit
    local filter = ""
    local ones = 0
    for _, num in ipairs(ratingnums) do -- count ones in each number
      if string.sub(num,i,i) == "1" then ones = ones + 1 end
    end

    filter = criteria[ones >= #ratingnums/2] -- true and false keyed to whatever type of rating critera

    temp = {}
    for _, num in ipairs(ratingnums) do
      if string.sub(num,i,i) == filter then
        table.insert(temp, num)
      end
    end
    ratingnums = temp
    if #ratingnums == 1 then break end
  end
  return tonumber(ratingnums[1], 2)
end

-- table keys can anything in Lua, even true and false
oxy = rating({[true] = "1", [false] = "0"})
co2 = rating({[true] = "0", [false] = "1"})
print(string.format("solution: %d", oxy * co2))
