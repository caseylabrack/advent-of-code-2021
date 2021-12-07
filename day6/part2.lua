f = assert(io.open("input.txt", "r"))
data = f:read("a")
f:close()

fishes = {}
for num in string.gmatch(data, "%d+") do
  table.insert(fishes, num)
end

count = 0


function spawn (fish, generation)
  if generation + fish <= 256 then
    count = count + 1
    spawn(9, generation + fish)
    spawn(7, generation + fish)
  end
end


for _, fish in ipairs(fishes) do
  spawn(fish, 1)
end



-- for i=1,80 do
--   for j=1,#fishes do
--     fishes[j] = fishes[j] - 1
--   end
--   local spawns = 0
--   for k=1,#fishes do
--     if fishes[k] == -1 then
--       fishes[k] = 6
--       spawns = spawns + 1
--     end
--   end
--   for l=1,spawns do
--     table.insert(fishes, 8)
--   end
--
--   --debug
--   -- io.write("After " .. i .. " days: ")
--   -- for _, fish in ipairs(fishes) do
--   --   io.write(" " .. fish)
--   -- end
--   -- io.write("\n")
-- end

print(count + #fishes)
