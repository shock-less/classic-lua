function draw_watermark()
    local getUsername = "valve" -- function to get username
    local screenWidth, screenHeight = engine.get_screen_size() -- function to get screen size
    draw_text(screenWidth - 100, 20, getUsername, {255, 255, 255}, 16) -- draw_text function
    draw_text(screenWidth - 100, 40, "Shockless", {255, 255, 255}, 16) -- draw_text function
end

draw_watermark()
