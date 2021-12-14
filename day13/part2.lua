dots = {}
folds = {}
for line in io.lines("input.txt") do
  if line~="" then -- there's a blank line between dots and folds
    if string.match(line, "fold") then
      local instruction = {}
      instruction.axis = string.match(line, "([xy])=")
      instruction.param = string.match(line, "=(%d+)") + 0.0
      table.insert(folds, instruction)
    else
      local coord = {}
      coord.x = string.match(line, "(%d+),") + 0.0
      coord.y = string.match(line, ",(%d+)") + 0.0
      table.insert(dots, coord)
    end
  end
end

-- find the bounds of the "paper"
maxX = 0
maxY = 0
for _, dot in ipairs(dots) do
  if dot.x > maxX then maxX = dot.x end
  if dot.y > maxY then maxY = dot.y end
end

-- use bounds to make a no-holes 2d array for "paper"
paper = {}
for i=0,maxY do
  paper[i] = {}
  for j=0,maxX do
    paper[i][j] = "."
  end
end

-- apply dots
for _, dot in ipairs(dots) do
  paper[dot.y][dot.x] = "#"
end

-- apply folding
for _, fold in ipairs(folds) do
  if fold.axis == "y" then
    for i=fold.param+1,maxY do -- for rows below the fold...
      for j=0,maxX do
        if paper[i][j] == "#" then
          paper[fold.param - (i - fold.param)][j] = "#"
        end
      end
      paper[i] = nil
    end
    maxY = fold.param - 1
  end
  if fold.axis == "x" then
    for i=0,maxY do
      for j=fold.param+1,maxX do
        if paper[i][j] == "#" then
          paper[i][fold.param - (j - fold.param)] = "#"
        end
      end
    end
    for i=0,maxY do
      for j=fold.param+1,maxX do
        paper[i][j] = nil
      end
    end
    maxX = fold.param - 1
  end
end

-- print to console
for i=0,maxY do
  for j=0,maxX do
    io.write(paper[i][j])
  end
  io.write("\n")
end
