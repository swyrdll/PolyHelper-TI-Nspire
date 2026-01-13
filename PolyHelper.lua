-- PolyHelper
-- TI-Nspire CX II
-- Step-by-step polynomial helper

screen = "menu"
scroll = 0

-- Quadratic input
a, b, c = 1, 5, 6
inputField = "a"

-- Graph factors
f1, f2 = 2, -1

-------------------------------------------------
-- FACTORING
-------------------------------------------------
function factorSteps(a, b, c)
    local steps = {}
    table.insert(steps, "Factor: "..a.."x^2 + "..b.."x + "..c)

    local ac = a * c
    table.insert(steps, "a * c = "..ac)

    for i = -math.abs(ac), math.abs(ac) do
        if i ~= 0 and ac % i == 0 then
            local j = ac / i
            if i + j == b then
                table.insert(steps, "Numbers: "..i.." and "..j)
                table.insert(steps, a.."x^2 + "..i.."x + "..j.."x + "..c)
                table.insert(steps, "Factor by grouping")
                return steps
            end
        end
    end

    table.insert(steps, "Not factorable over integers")
    return steps
end

-------------------------------------------------
-- LONG DIVISION (Quadratic / Linear)
-------------------------------------------------
function longDivision(a, b, c, d, e)
    local s = {}
    table.insert(s, "Divide ("..a.."x^2 + "..b.."x + "..c..")")
    table.insert(s, "by ("..d.."x + "..e..")")

    local t1 = a / d
    table.insert(s, "First term: "..t1.."x")

    local newB = b - (t1 * e)
    table.insert(s, "Subtract -> "..newB.."x + "..c)

    local t2 = newB / d
    table.insert(s, "Next term: "..t2)

    local rem = c - (t2 * e)
    table.insert(s, "Remainder: "..rem)

    return s
end

-------------------------------------------------
-- GRAPHING FROM FACTORS
-------------------------------------------------
function drawGraph(gc)
    local ox, oy = 160, 120

    gc:drawLine(0, oy, 320, oy)
    gc:drawLine(ox, 0, ox, 240)

    for x = -100, 100 do
        local y = (x - f1) * (x - f2)
        local px = ox + x
        local py = oy - y / 4
        gc:fillRect(px, py, 1, 1)
    end

    gc:drawString("Zeros: "..f1..", "..f2, 10, 10)
end

-------------------------------------------------
-- DRAW
-------------------------------------------------
function on.paint(gc)
    gc:setFont("sansserif", "r", 11)

    if screen == "menu" then
        gc:drawString("POLY HELPER", 110, 20)
        gc:drawString("1  Factor Quadratics", 80, 60)
        gc:drawString("2  Long Division", 80, 80)
        gc:drawString("3  Graph from Factors", 80, 100)

    elseif screen == "factor" then
        gc:drawString("Enter a,b,c (comma)", 10, 10)
        gc:drawString("a="..a.."  b="..b.."  c="..c, 10, 25)
        gc:drawString("n = reset", 10, 40)

        local steps = factorSteps(a, b, c)
        for i = 1, #steps do
            gc:drawString(steps[i], 10, 60 + i*14 - scroll)
        end

    elseif screen == "divide" then
        local steps = longDivision(1, 5, 6, 1, -2)
        for i = 1, #steps do
            gc:drawString(steps[i], 10, 20 + i*14 - scroll)
        end

    elseif screen == "graph" then
        drawGraph(gc)
    end
end

-------------------------------------------------
-- INPUT
-------------------------------------------------
function on.charIn(c)
    if screen == "menu" then
        if c == "1" then screen = "factor" end
        if c == "2" then screen = "divide" end
        if c == "3" then screen = "graph" end

    elseif screen == "factor" then
        if c == "n" then
            a, b, c = 0, 0, 0
            inputField = "a"
        elseif tonumber(c) then
            if inputField == "a" then a = a * 10 + tonumber(c)
            elseif inputField == "b" then b = b * 10 + tonumber(c)
            elseif inputField == "c" then c = c * 10 + tonumber(c) end
        elseif c == "," then
            if inputField == "a" then inputField = "b"
            elseif inputField == "b" then inputField = "c" end
        end
    end

    platform.window:invalidate()
end

function on.arrowUp()
    scroll = scroll - 10
    platform.window:invalidate()
end

function on.arrowDown()
    scroll = scroll + 10
    platform.window:invalidate()
end
