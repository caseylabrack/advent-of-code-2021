data  = assert(io.open("input.txt", "r"))

template = data:read("l")
data:read("l") -- blank line

rules = {}
for line in data:lines() do
  local pair, ins = string.match(line, "^(%a%a).*(%a)")
  rules[pair] = ins
end

head = {}
head.prev = nil
head.value = string.sub(template, 1, 1)

last = head
for i=2,string.len(template) do
  local current = {}
  current.prev = last
  current.value = string.sub(template,i,i)
  last.next = current
  last = current
end

for i=1,25 do
  pointer = head
  while pointer.next ~= nil do
    local chunk = pointer.value .. pointer.next.value
    -- print("chunk" .. chunk)
    if rules[chunk] ~= nil then
      local insert = {}
      insert.value = rules[chunk]
      insert.next = pointer.next
      insert.prev = pointer

      pointer.next = insert
      pointer = insert.next
    else
      pointer = pointer.next
    end
  end
end

-- debug zone
pointer = head
sum = 0
while pointer.next ~= nil do
  sum = sum + 1
  pointer = pointer.next
end
print(sum)



-- debug zone
-- pointer = head
-- while pointer.next ~= nil do
--   io.write(pointer.value)
--   pointer = pointer.next
-- end
-- io.write("\n")
