data  = assert(io.open("input.txt", "r"))

drawsRaw = data:read("l") -- read a line. file seek point moved up one

-- parse remaining lines into bingo boards
boards = {}
for line in data:lines() do
  if line =="" then
    b = {} -- empty line means start new bingo board
    table.insert(boards, b)
  else
    row = {}
    for num in string.gmatch(line, "%d+") do -- for every number in this line...
      row[#row+1] = num -- add number to row
    end
    b[#b+1] = row
  end
end

-- string of numbers into array
draws = {}
for d in drawsRaw:gmatch("%d+") do
  draws[#draws+1] = d
end

for _, num in ipairs(draws) do -- draw a number

  for _, board in ipairs(boards) do -- for each board, mark xs
    for _, row in ipairs(board) do
      for i=1,5 do
        if row[i] == num then row[i] = "x" end
      end
    end
  end

  for idx, board in ipairs(boards) do -- for each board

    for _, row in ipairs(board) do -- scan rowwise for win
      xs = 0
      for i=1,5 do
        if row[i] == "x" then xs = xs + 1 end
      end
      if xs == 5 then
        if #boards == 1 then
          bingo = num
          antiwinner = board
          goto bingo
        else
          table.remove(boards, idx)
          goto continuescan
        end
      end
    end

    for i=1,5 do -- scan columnwise for win
      xs = 0
      for _, row in ipairs(board) do
        if row[i] == "x" then xs = xs + 1 end
      end
      if xs == 5 then
        if #boards == 1 then
          bingo = num
          antiwinner = board
          goto bingo
        else
          table.remove(boards, idx)
          goto continuescan
        end
      end
    end
    ::continuescan:: -- used as multilevel `continue` statement
  end
end

::bingo:: -- used as multilevel `break` statement
sum = 0
for _, row in ipairs(antiwinner) do
  for i=1,5 do
    if row[i] ~= "x" then sum = sum + tonumber(row[i]) end
  end
end

print(string.format("last win on %d", bingo))
print(string.format("score for that board: %d", sum))
print(string.format("multiplied: %d", sum * bingo))
