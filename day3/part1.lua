nums = {}
for line in io.lines("input.txt") do
  table.insert(nums, line)
end

bits = #nums[1] -- number of bits in pattern
gamma = ""
episilon = ""
for i=1,bits do -- for each bit
  local ones = 0
  for _, num in pairs(nums) do -- in each number
    if string.sub(num,i,i) == "1" then ones = ones + 1 end
  end
  if ones > #nums / 2 then -- if ones are majority
    gamma = gamma .. "1"
    episilon = episilon .. "0"
  else
    gamma = gamma .. "0"
    episilon = episilon .. "1"
  end
end

print(string.format("gamma times episolon: %d", tonumber(gamma, 2) * tonumber(episilon, 2)))
