octos = {}
for line in io.lines("input.txt") do
  local row = {}
  for num in string.gmatch(line, "%d") do
    table.insert(row, num + 0.0)
  end
  table.insert(octos, row)
end

flashes = 0
for z=1,100 do
  -- increment
  for row=1,#octos do
    for col=1,#octos[1] do
      octos[row][col] = octos[row][col] + 1
    end
  end

  -- flashes
  ::doflashes::
  for row=1,#octos do
    for col=1,#octos[1] do
      if octos[row][col] > 9 then -- flash
        flashes = flashes + 1
        octos[row][col] = 0
        for i=row-1,row+1 do
          for j=col-1,col+1 do
            if octos[i] ~= nil and octos[i][j] ~= nil and octos[i][j] ~= 0 then
              octos[i][j] = octos[i][j] + 1
            end
          end
        end
        goto doflashes -- if a flash happens, start over from beginning
      end
    end
  end

end

-- the debug zone
for row=1,#octos do
  for col=1,#octos[1] do
    io.write(octos[row][col])
  end
  io.write("\n")
end

print(flashes)
