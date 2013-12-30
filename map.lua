local class  = require 'lib.middleclass'
local Block  = require 'entities.Block'
local Coin   = require 'entities.Coin'

local random = math.random

local Map = class('Map')

function newBlock(self, l,t,w,h)
  local block = Block:new(self.world, l,t,w,h)
  self.blocks[block] = true
end

function newCoin(self, l,t)
  local coin = Coin:new(self.world, l,t)
  self.coins[coin] = true
end

function Map:destroy()
  for coin in pairs(self.coins) do coin:destroy() end
  for block in pairs(self.blocks) do block:destroy() end
end

Map.static.WIDTH  = 4000
Map.static.HEIGHT = 2000

function Map:initialize(world)
  self.world  = world
  self.width  = Map.WIDTH
  self.height = Map.HEIGHT
  self.blocks = {}
  self.coins  = {}

  local width, height = self.width, self.height

  -- walls & ceiling
  newBlock(self,        0,         0, width,        32)
  newBlock(self,        0,        32,    32, height-64)
  newBlock(self, width-32,        32,    32, height-64)

  -- tiled floor
  local tilesOnFloor = 40
  for i=0,tilesOnFloor - 1 do
    newBlock(self, i*width/tilesOnFloor, height-32, width/tilesOnFloor, 32)
  end

  -- random blocks
  for i=1,100 do
    newBlock(self,
             random(100, width-200),
             random(100, height-150),
             random(32, 100),
             random(32, 100))
  end

  -- random coins
  for i=1,20 do
    newCoin(self, random(100, width-200), random(100, height-200))
  end

end

return Map
