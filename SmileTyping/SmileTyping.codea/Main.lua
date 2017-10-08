-- Smile Typing
supportedOrientations(LANDSCAPE_RIGHT)
-- Use this function to perform your initial setup
function setup()
    print("-.- x -. x .. x --. x .... x -")
    letter = ""
    cameraSource( CAMERA_FRONT )
    current = image(CAMERA)
   -- w,h = spriteSize(CAMERA)
    w = 1280
    h = 720
    n=120
    timer = n+2
    stage = 1
    baseEye = 0
    baseSmile = 0
    spriteMode(CORNER)
    fill(0)
    fontSize(WIDTH/20)
    textMode(CENTER)
    positions = {}
    strings = {"left corner of your eye","right corner of your same eye","top of your mouth","bottom of your mouth"}
    word = ""
    letter = ""
    code = {}
    code[".-"] = "A"
    code["-..."] = "B"
    code["-.-."] = "C"
    code["-.."] = "D"
    code["."] = "E"
    code["..-."] = "F"
    code["--."] = "G"
    code["...."] = "H"
    code[".."] = "I"
    code[".---"] = "J"
    code["-.-"] = "K"
    code[".-.."] = "L"
    code["--"] = "M"
    code["-."] = "N"
    code["---"] = "O"
    code[".--."] = "P"
    code["--.-"] = "Q"
    code[".-."] = "R"
    code["..."] = "S"
    code["-"] = "T"
    code["..-"] = "U"
    code["...-"] = "V"
    code[".--"] = "W"
    code["-..-"] = "X"
    code["-.--"] = "Y"
    code["--.."] = "Z"
end

function touched(touch)
    if touch.state == BEGAN then
        letter = ""
        speech.say(word)
        positions[stage] = vec2(math.floor(touch.x*w/WIDTH),math.floor(touch.y*h/HEIGHT))
        stage = stage + 1
        if stage == 3 then
            current = image(CAMERA)
            detectBlink()
        end
        if stage == 5 then
            current = image(CAMERA)
            detectSmile()
        end
    end
end

function parseWord(input)
    sound(SOUND_JUMP, 25279)
    if code[letter] ~= nil then
    word=word..code[letter]
     --   speech.say(word)
        end
    letter = ""
   -- word = ""
end

-- This function gets called once every frame
function draw()
  --  if current == 0 then
     --   current = image(CAMERA)
   -- w,h = spriteSize(current)
  --  end
    -- This sets a dark background color
    background(255, 255, 255, 255)
    if stage <= 4 then
        sprite(CAMERA,0,0,WIDTH,HEIGHT)
        text("Relax your face, hold your head still",WIDTH/2,HEIGHT/4)
        text("tap the "..strings[stage],WIDTH/2,HEIGHT/8)
        
    else
         timer = timer + 1
        
        if timer == n then
            timer = 0
            current = image(CAMERA)
            detectBlink()
        end
        if timer == math.floor(n/2) then
            current = image(CAMERA)
            if detectBlink() then
                parseWord(letter)
            end
        end
        if timer == math.floor(n/4) then
            current = image(CAMERA)
            detectSmile()
        end
        sprite(CAMERA,0,0,WIDTH,HEIGHT)
        sprite("Project:morse",0,HEIGHT*3/4,WIDTH/4,HEIGHT/4)
        text("Letter: "..letter,WIDTH/2,HEIGHT*7/8)
        text("Word: "..word,WIDTH/2,HEIGHT*6.5/8)
        
        if timer > n then
            letter = ""
            text("Get Ready",WIDTH/2,HEIGHT/2)
           -- current = image(CAMERA)
            if timer >= n+120 then
                timer = n-1
            end
        end
       
        for i = 1,4 do
            ellipse(positions[i].x*WIDTH/w,positions[i].y*HEIGHT/h,25)
        end
        -- This sets the line thickness
        strokeWidth(5)
    end
    -- Do your drawing here
    
end

function detectSmile()
    total = 0
    --print(positions[1].y)
    for i = positions[4].y,positions[3].y do
        r,g,b,a = current:get(positions[4].x,i)
        total = total + (b)
    end
    total= total/(positions[3].y-positions[4].y)
    if baseSmile == 0 then
        baseSmile = total
    end
   -- print(total)
    if total-5 > baseSmile then
        letter= letter.."-"
        else
        letter=letter.."."
    end
   -- return (total+1000 > baseEye)
end

function detectBlink()
    total = 0
    --print(positions[1].y)
    for i = positions[1].x,positions[2].x do
        r,g,b = current:get(i,positions[1].y)
        total = total + r
    end
    total = total/(positions[2].x-positions[1].x)
--print(total)
    if baseEye == 0 then
        baseEye = total
    end
    return (total-10 > baseEye)
end

