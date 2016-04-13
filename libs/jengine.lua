local object = {}
collider = require "libs.hardoncollider"

--Objects
objects = {}
input = love.keyboard

time = {deltaTime = 0, time = 0}

function objects:create(objid, xpos, ypos, awidth, aheight, rot, img, damp, isstatic, coltype, useCol, useImg)
    newObj = {id = objid, x = xpos, y = ypos, width = awidth, height = aheight, rotation = rot, image = nil, imgsrc = img, static = isstatic, collider = nil, collidertype = coltype, xVel = 0, yVel = 0, dampening = damp, useCollider = useCol, useImage = useImg}
    table.insert(objects, newObj)
    return newObj
end

function objects:get(objid)
    obj = nil;
    for y, x in ipairs(objects) do
        if x.id == objid then
            obj = x
            break
        end
    end
    return obj
end

function objects:remove(objid)
    for y, x in ipairs(objects) do
        if x.id == objid then
            --collider:remove(x.collider)
            table.remove(objects, y)
            break
        end
    end
end

function objects:update(objid, obj)
    for y, x in ipairs(objects) do
        if x.id == objid then
            x = obj
            x.collider:rotate(x.rotation)
            break
        end
    end
end

--Transform


--Drawing
draw = {}
function draw:image(img, x, y, rot, width, height)
    love.graphics.draw(img, x, y, rot, width, height)
end

function draw:text(string, x, y, color)
    love.graphics.setColor(color)
    love.graphics.print(string, x, y)
    love.graphics.setColor(255, 255, 255, 255)
end

--Collision
console = {}

function checkCollision()
    for y, x in ipairs(objects) do
        if x.static == false then
            for shape, delta in pairs(collider.collisions(x.collider)) do
                if delta.x - 1 < 0 then
                    x.xVel = 0
                    x.x = x.x - 2
                    x.collider.side.right = "true"
                else
                    x.collider.side.right = "false"
                end
                if delta.x + 1 > 0.1 then
                    x.xVel = 0
                    x.x = x.x + 2
                    x.collider.side.left = "true"
                else
                    x.collider.side.left = "false"
                end
                if delta.y + 0.5 < 0 then
                    x.yVel = 0
                    x.y = x.y - 2
                    x.collider.side.down = "true"
                else
                    x.collider.side.down = "false"
                end
                if delta.y - 0.5 > 0 then
                    x.yVel = 0
                    x.y = x.y + 2
                    x.collider.side.up = "true"
                else
                    x.collider.side.up = "false"
                end
            end
        end
    end
end

--Camera
camera = objects:create("camera", 0, 0, 1, 1, 0, "", 0.5, true, "", false, false)
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0

function camera:set()
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
    love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
    love.graphics.pop()
end

function camera:rotate(dr)
    self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
    sx = sx or 1
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * (sy or sx)
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function camera:mousePosition()
  return {x = love.mouse.getX() * self.scaleX + self.x, y = love.mouse.getY() * self.scaleY + self.y}
end

--Loop
function start() end
function love.load()
    start()

    for y, x in ipairs(objects) do
        if x.useImage == true or x.useImage == nil then
            x.image = love.graphics.newImage(x.imgsrc)
        end
        if x.useCollider == true or x.useCollider == nil then
            if x.collidertype == "rect" then
                x.collider = collider.rectangle(x.x, x.y, x.width, x.height)
            elseif x.collidertype == "circle" then
                x.collider = collider.circle(x.x, x.y, x.width/2)
            else
                x.collider = collider.rectangle(x.x, x.y, x.width, x.height)
            end
            x.collider.side = {right = "false", left = "false", up = "false", down = "false"}
        end
    end
end

function update(dt) end
function love.update(dt)
    time.deltaTime = dt
    time.time = time.time + 1

    for y, x in ipairs(objects) do
        x.xVel = x.xVel * x.dampening
        x.yVel = x.yVel * x.dampening
        x.x = x.x + x.xVel
        x.y = x.y + x.yVel
        if x.useCollider == true or x.useCollider == nil then
            x.collider:moveTo(x.x, x.y)
        end
    end

    while #console > 10 do
        table.remove(console, 1)
    end

    checkCollision()
    update()
end

function gui() end
function love.draw()
    camera:set()
    for y, x in ipairs(objects) do
        if x.useImage == true or x.useImage == nil then
            love.graphics.draw(x.image, x.x, x.y, math.rad(x.rotation), x.scaleX, x.scaleY, x.width/2, x.height/2)
        end
    end
    camera:unset()
    gui()
end

return object
