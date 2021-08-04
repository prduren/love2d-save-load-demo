function CheckCollision(p1, p2)
  local distance = math.sqrt((p1.x - p2.x)^2 + (p1.y - p2.y)^2)
  --return whether the distance is lower than the sum of the sizes
  return distance < p1.size + p2.size
end

function love.load()
  ShakeDuration = 0
  ShakeWait = 0
  ShakeOffset = { x = 0, y = 0 }
  lume = require "lume"
  Player = {
    x = 100,
    y = 100,
    size = 25,
    image = love.graphics.newImage("face.png")
  }

  Coins = {}

  if love.filesystem.getInfo("savedata.txt") then
    File = love.filesystem.read("savedata.txt")
    Data = lume.deserialize(File)

    Player.x = Data.Player.x
    Player.y = Data.Player.y
    Player.size = Data.Player.size

    for i,v in ipairs(Data.Coins) do
      Coins[i] = {
        x = v.x,
        y = v.y,
        size = 10,
        image = love.graphics.newImage("dollar.png")
      }
    end
  else
    --only execute this if you don't have a save file
    for i=1,25 do
      table.insert(Coins, {
        x = love.math.random(50, 650),
        y = love.math.random(50, 450),
        size = 10,
        image = love.graphics.newImage("dollar.png")
      })
    end
  end

  Score = 0

end

function love.update(dt)
  
  if ShakeDuration > 0 then
    ShakeDuration = ShakeDuration - dt
    if ShakeWait > 0 then
      ShakeWait = ShakeWait - dt
    else
      ShakeOffset.x,ShakeOffset.y = love.math.random(-5,5), love.math.random(-5,5)
      ShakeWait = 0.05
    end
  end
  if love.keyboard.isDown("left") then
    Player.x = Player.x - 200 * dt
  elseif love.keyboard.isDown("right") then
    Player.x = Player.x + 200 * dt
  end

  if love.keyboard.isDown("up") then
    Player.y = Player.y - 200 * dt
  elseif love.keyboard.isDown("down") then
    Player.y = Player.y + 200 * dt
  end

  for i=#Coins,1,-1 do
    if CheckCollision(Player, Coins[i]) then
      table.remove(Coins, i)
      Player.size = Player.size + 1
      Score = Score + 1
      ShakeDuration = 0.3
      end
    end
  end

function love.draw()
  love.graphics.push() --make a copy of the current state and push it onto the stack
  love.graphics.translate(-Player.x + 400, -Player.y + 300)

  if ShakeDuration > 0 then
    --translate w/ a random number between -5 and 5
    --the second translate will be done based on the previous translate
    --so, it will not reset the previous translate
    love.graphics.translate(ShakeOffset.x, ShakeOffset.y)
  end

  love.graphics.circle("line", Player.x, Player.y, Player.size)
  love.graphics.draw(Player.image, Player.x, Player.y, 0, 1, 1, Player.image:getWidth()/2, Player.image:getHeight()/2)
  for i,v in ipairs(Coins) do
    love.graphics.circle("line", v.x, v.y, v.size)
    love.graphics.draw(v.image, v.x, v.y, 0, 1, 1, v.image:getWidth()/2, v.image:getHeight()/2)
  end
  --resets all coordinate transformations. Does not affect what you have already drawn.
  love.graphics.pop() --pull the copy of the state of the stack and apply it
  love.graphics.print(Score, 10, 10)
end

function love.keypressed(key)
  if key == "f1" then
    SaveGame()
  elseif key == "f2" then
    love.filesystem.remove("savedata.txt")
      love.event.quit("restart")
  end
end

function SaveGame()
  Data = {}
  Data.Player = {
    x = Player.x,
    y = Player.y,
    size = Player.size
  }

  Data.Coins = {}
  for i,v in ipairs(Coins) do
    --in this case data.coins[i] = value is the same as table.insert(data.coins, value)
    Data.Coins[i] = {x = v.x, y = v.y}
  end

  Serialized = lume.serialize(Data)
  love.filesystem.write("savedata.txt", Serialized)
end