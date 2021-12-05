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
antiwinner = {}
boardspool = table.move(boards, 1, #boards, 1, boardspool) -- clone boards
for _, num in ipairs(draws) do

  for _, board in ipairs(boardspool) do -- mark xs
    for _, row in ipairs(board) do
      for i=1,5 do
        if row[i] == num then row[i] = "x" end
      end
    end
  end

  for idx, board in ipairs(boardspool) do -- scan for winnner rowwise
    for _, row in ipairs(board) do
      xs = 0
      for i=1,5 do
        if row[i] == "x" then xs = xs + 1 end
      end
      if xs == 5 then
        if #boardspool == 1 then
          bingo = num
          antiwinner = board
          goto bingo
        else
          table.remove(boardspool, idx)
          -- print(#boardspool)
          goto next
        end
      end
    end
  end

  for idx, board in ipairs(boardspool) do -- scan for winner colwise
    for i=1,5 do
      xs = 0
      for _, row in ipairs(board) do
        if row[i] == "x" then xs = xs + 1 end
      end
      if xs == 5 then
        if #boardspool == 1 then
          bingo = num
          antiwinner = board
          goto bingo
        else
          table.remove(boardspool, idx)
          -- print(#boardspool)
          goto next
        end
      end
    end
  end
  ::next::
  print(num, #boardspool)
end

::bingo::
sum = 0
for _, row in ipairs(antiwinner) do
  for i=1,5 do
    if row[i] ~= "x" then sum = sum + tonumber(row[i]) end
  end
end

print(bingo)
-- print(string.format("last win on %d", bingo))
-- print(string.format("score for that board: %d", sum))
-- print(string.format("multiplied: %d", sum * bingo))
