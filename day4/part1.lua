data  = assert(io.open("input.txt", "r"))

drawsRaw = data:read("l") -- read a line. file seek point moved up

-- parse remaining lines into bingo boards
boards = {}
b = {}
for line in data:lines() do
  if line =="" then
    b = {}
    table.insert(boards, b)
  else
    row = {}
    for num in string.gmatch(line, "%d+") do -- for every number in this line...
      row[#row+1] = num -- add number to row
    end
    b[#b+1] = row
  end
end

-- string of string into array
draws = {}
for d in drawsRaw:gmatch("%d+") do
  draws[#draws+1] = d
end

bingo = math.huge
winner = {}
for _, num in ipairs(draws) do

  for _, board in ipairs(boards) do -- mark xs
      for _, row in ipairs(board) do
        for i=1,5 do
          if row[i] == num then row[i] = "x" end
        end
      end
  end

  for _, board in ipairs(boards) do -- scan for winnner rowwise
    for _, row in ipairs(board) do
      local xs = 0
      for i=1,5 do
        if row[i] == "x" then xs = xs + 1 end
      end
      if xs == 5 then
        bingo = num
        winner = board
        goto bingo
      end
    end
  end

  for _, board in ipairs(boards) do -- scan for winner colwise
    for i=1,5 do
      local xs = 0
      for _, row in ipairs(board) do
        if row[i] == "x" then xs = xs + 1 end
      end
      if xs == 5 then
        bingo = num
        winner = board
        goto bingo
      end
    end
  end

end

::bingo::

sum = 0
for _, row in ipairs(winner) do
  for i=1,5 do
    if row[i] ~= "x" then sum = sum + tonumber(row[i]) end
  end
end

print(string.format("bingo number: %d", bingo))
print(string.format("sum of winning board: %d", sum))
print(string.format("multiplied: %d", sum * bingo))
