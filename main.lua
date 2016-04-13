require ("libs.jengine")

player = {}

function start()
    objects:create("block", 400, 50, 32, 32, 0, "Block.png", 0, true, "box")
    objects:create("block", 368, 82, 32, 32, 0, "Block.png", 0, true, "box")
    objects:create("block", 368, 18, 32, 32, 0, "Block.png", 0, true, "box")
    rect = objects:create("rect", 200, 150, 64, 16, 0, "Rect.png", 0, true, "box")
    objects:create("circle", 400, 200, 32, 32, 0, "Circle.png", 0, true, "circle")
    player = objects:create("player", 300, 50, 32, 32, 0, "Player.png", 0.5, false, false)
end

function update()
    camera:setScale(1, 1)

    objects:update("player", player)
    objects:update("rect", rect)

    --if (time.time > 5) then
    --    objects:remove("rect")
    --end

    rect.rotation = rect.rotation + 5

    if input.isDown("d") then
        player.xVel = 4
    end
    if input.isDown("a") then
        player.xVel = -4
    end
    if input.isDown("w") then
        player.yVel = -4
    end
    if input.isDown("s") then
        player.yVel = 4
    end

    if input.isDown("right") then
        camera.xVel = 8
    end
    if input.isDown("left") then
        camera.xVel = -8
    end
    if input.isDown("up") then
        camera.yVel = -8
    end
    if input.isDown("down") then
        camera.yVel = 8
    end
end

function gui()
    draw:text("right: " .. player.collider.side.right, 1, 0, {255, 255, 255, 255})
    draw:text("left: " .. player.collider.side.left, 1, 15, {255, 255, 255, 255})
    draw:text("up: " .. player.collider.side.up, 1, 30, {255, 255, 255, 255})
    draw:text("down: " .. player.collider.side.down, 1, 45, {255, 255, 255, 255})
end
