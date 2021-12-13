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
        if string.match(path, othernode) == nil then table.insert(nextsteps, othernode) end
      end
    end
  end

  for _, dest in pairs(nextsteps) do
    walkCave(path, dest)
  end

end

walkCave("", "start")

for idx, path in ipairs(paths) do
  print(idx .. ": " .. path)
end
