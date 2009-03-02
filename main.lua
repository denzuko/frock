-- Author       : Wilhelm Chung - http://webjazz.blogspot.com

love.filesystem.require 'food.lua'
love.filesystem.require 'boid.lua'
love.filesystem.require 'roommates.lua'
love.filesystem.require 'status.lua'

-- variables to show various awareness radii
show_physical_radius = false
show_attraction_radius = false
show_avoidance_radius = false
show_alignment_radius = false
show_hunting_radius = false

function load()
   math.randomseed(os.time())
   num_boids = 25
   num_foodstuff = 1
   boids = {}
   foodstuffs = {}

   love.graphics.setLineWidth(2)
   font = love.graphics.newFont(love.default_font, 14)
   love.graphics.setFont(font)

   for i = 1, num_boids do
      boids[i] = Boid:new(math.random() * love.graphics.getWidth(),
                          math.random() * love.graphics.getHeight(),
                          math.random(30) - 15,
                          math.random(30) - 15)
   end

   for i = 1, num_foodstuff do
      foodstuffs[i] = Food:new()
   end

   spatial_db = Roommates:new(love.graphics.getWidth(), love.graphics.getHeight(), 10, 10)
end

function update(dt)
   -- updates vectors for each boid
   for _, boid in ipairs(boids) do
      boid:navigate(boids, foodstuffs)
      boid:move(dt)
      boid:animate(dt)
      
      -- see if each food is isEaten
      for _, food in ipairs(foodstuffs) do
         food:isEaten(boid)
      end
   end

end

function draw()
   -- draw each food
   for _, food in ipairs(foodstuffs) do
      food:draw()
   end
   
   -- draw each boid
   for _, boid in ipairs(boids) do
      boid:draw()
      draw_debug(boid)
   end
   
   -- draw the buckets
   -- spatial_db:draw()
   
   draw_boid_status(10, 20)
   draw_radius_status(10, 600)
end

function mousepressed(x, y, button)
   if button == love.mouse_left then
      table.insert(foodstuffs, Food:new(x, y))
   end
end

function keyreleased(key)
   if key == love.key_1 then
      show_physical_radius = toggle(show_physical_radius)
   elseif key == love.key_2 then
      show_attraction_radius = toggle(show_attraction_radius)
   elseif key == love.key_3 then
      show_avoidance_radius = toggle(show_avoidance_radius)
   elseif key == love.key_4 then
      show_alignment_radius = toggle(show_alignment_radius)
   elseif key == love.key_5 then
      show_hunting_radius = toggle(show_hunting_radius)
   end
end

function toggle(variable)
   if (variable == true) then
      return false
   else
      return true
   end
end
