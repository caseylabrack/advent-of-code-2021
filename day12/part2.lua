links = {}
for line in io.lines("input.txt") do
  local n = {}
  n.node1 = string.match(line, "[a-zA-Z]+")
  n.node2 = string.match(line, "-([a-zA-Z]+)")
  table.insert(links, n)
end

paths = {}
function walkCave (path, node)
  path = path .. node .. ","

  if node == "end" then
    table.insert(paths, path)
    return
  end

  -- find all possible next steps
  local nextsteps = {}
  for _, link in pairs(links) do
    if link.node1 == node or link.node2 == node then -- if this link contains my position
      local othernode = link.node2
      if link.node2 == node then othernode = link.node1 end -- which node is the other node in the link
      if othernode ~= string.lower(othernode) then -- it's always valid to go to an uppercase cave
        table.insert(nextsteps, othernode)
      else
        if othernode == "start" then goto continue end
        local _, num = string.gsub(path, othernode, "") -- how many times has this small cave been visited
        if num == 0 then table.insert(nextsteps, othernode) end -- we can always go to an unvisited small cave
        if num == 1 then -- if it's been visited before, we can only go if we've never revisted a small cave before
          local smallCavesVisited = "" -- find all the visited small caves
          for cave in string.gmatch(path, "[a-z]+") do
            smallCavesVisited = smallCavesVisited .. cave .. ","
          end
          local repeatVisits = false
          for cave in string.gmatch(smallCavesVisited, "[a-z]+") do
            local _, num = string.gsub(smallCavesVisited, cave, "")
            if num == 2 then -- if there's already a twice visited small cave in our path, we can't go
              repeatVisits = true
              break
            end
          end
          if repeatVisits == false then
            table.insert(nextsteps, othernode)
          end
        end
      end
    end
    ::continue::
  end

  -- investigate all valid moves from here
  for _, dest in pairs(nextsteps) do
    walkCave(path, dest)
  end

end

walkCave("", "start")

for idx, path in ipairs(paths) do
  print(idx .. ": " .. path)
end
