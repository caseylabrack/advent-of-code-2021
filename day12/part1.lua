links = {}
for line in io.lines("input.txt") do
  local n = {}
  n.node1 = string.match(line, "[a-zA-Z]+")
  n.node2 = string.match(line, "-([a-zA-Z]+)")
  n.smallCaveAtNode2 = n.node2 == string.lower(n.node2)
  table.insert(links, n)
end

-- for key, val in ipairs(paths) do
  -- print(key, val.node1, val.node2, val.smallCaveAtNode2)
-- end
paths = {}
function walkCave (path, node)
  local pathclone = table.move(path,1,#path,1,{})
  table.insert(pathclone, node)

  if node == "end" then
    table.insert(paths, pathclone)
    return
  end

  -- find all possible next steps
  local nextsteps = {}
  for _, link in pairs(links) do
    if link.node1 == node then -- if this is a link starting with current node
      if link.smallCaveAtNode2 == true then -- check destination for smallness
        local hasBeenVisitedBefore = false -- if it's been visited before, don't add
        for _, point in pairs(path) do
          if point == link.node2 then
            hasBeenVisitedBefore = true
            break
          end
        end
        if hasBeenVisitedBefore == false then table.insert(nextsteps, link.node2) end
      else -- if next cave not small, add
        table.insert(nextsteps, link.node2)
      end
    end
  end


  for _, dest in pairs(nextsteps) do
    print("im at node " .. node .. " and I can go to node " .. dest)
    print("my path is " .. table.concat(pathclone, ",") .. " and I'm going to " .. dest)
    -- print("im at " .. node .. " and I'm gonna go to " .. dest)
    -- print("at " .. node .. ", gonna go to " .. dest)
    walkCave(pathclone, dest)
  end

end

walkCave({}, "start")

for idx, path in ipairs(paths) do
  for _, node in ipairs(path) do
    io.write(node.. " ")
  end
  io.write("\n")
end
