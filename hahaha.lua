-- TI-Nspire Lua: Polished Polynomial Long Division
-- Author: ChatGPT
-- Fully paper-style, with quotient, remainder, and final solution

-- Parse polynomial string into table
function parsePolynomial(polyStr)
    local poly = {}
    polyStr = polyStr:gsub("%s","") -- remove spaces
    for term in polyStr:gmatch("[+-]?[^+-]+") do
        if term:find("x") then
            -- Term contains x (variable term)
            local coeff, exp = term:match("([+-]?%d*)x%^?(%d*)")
            if coeff=="" or coeff=="+" then coeff=1
            elseif coeff=="-" then coeff=-1
            else coeff=tonumber(coeff) end
            if exp=="" then exp=1 else exp=tonumber(exp) end
            poly[exp]=(poly[exp] or 0)+coeff
        else
            -- Constant term (no x)
            local coeff = tonumber(term)
            if coeff then
                poly[0]=(poly[0] or 0)+coeff
            end
        end
    end
    return poly
end

-- Degree of polynomial
function degree(poly)
    if not poly or type(poly) ~= "table" then
        return -1
    end
    local maxDeg = -1
    for k, v in pairs(poly) do
        if v ~= 0 and type(k) == "number" and k > maxDeg then 
            maxDeg = k 
        end
    end
    return maxDeg
end

-- Convert polynomial table to string safely
function polyToString(poly)
    if not poly or type(poly) ~= "table" then
        return "0"
    end
    
    local deg = degree(poly)
    if deg < 0 then 
        return "0" 
    end
    
    local s = ""
    for i = deg, 0, -1 do
        local coeff = poly[i] or 0
        if coeff ~= 0 then
            if s ~= "" then
                if coeff > 0 then s = s .. " + "
                else s = s .. " - " end
                if coeff < 0 then coeff = -coeff end
            end
            if i == 0 then
                s = s .. coeff
            elseif i == 1 then
                if coeff == 1 then s = s .. "x" else s = s .. coeff .. "x" end
            else
                if coeff == 1 then s = s .. "x^" .. i else s = s .. coeff .. "x^" .. i end
            end
        end
    end
    if s == "" then s = "0" end
    return s
end

-- Shallow copy table
function copyTable(t)
    local c = {}
    for k,v in pairs(t) do c[k] = v end
    return c
end

-- Polynomial long division: paper-style
function longDivisionPaperStyle(num, den)
    local quotient = {}
    local remainder = copyTable(num)
    local degDen = degree(den)
    local steps = {}

    -- Long division algorithm
    while degree(remainder) >= degDen do
        local degRem = degree(remainder)
        local leadRem = remainder[degRem]
        local leadDen = den[degDen]
        local factor = leadRem / leadDen
        local expDiff = degRem - degDen
        quotient[expDiff] = factor

        -- Multiply denominator by factor*x^expDiff
        local subtrahend = {}
        for k,v in pairs(den) do
            subtrahend[k + expDiff] = v * factor
        end

        -- Save step for display
        table.insert(steps,{remainder=copyTable(remainder), sub=subtrahend})

        -- Subtract
        for k,v in pairs(subtrahend) do
            remainder[k] = (remainder[k] or 0) - v
            if math.abs(remainder[k]) < 1e-10 then remainder[k] = nil end
        end
    end

    -- Visual layout
    local numStr = polyToString(num)
    local denStr = polyToString(den)
    local quotStr = polyToString(quotient)
    local line = string.rep("─", #numStr)

    -- Print quotient on top
    print(string.rep(" ", #denStr + 2) .. quotStr)
    -- Denominator with vertical bar and numerator inside
    print(denStr .. " |" .. numStr)
    print(string.rep(" ", #denStr + 1) .. "|" .. line)

    -- Print each subtraction step
    for _, s in ipairs(steps) do
        local subStr = polyToString(s.sub)
        local remStr = polyToString(s.remainder)
        -- Align subtraction visually
        print(string.rep(" ", #denStr + 2) .. subStr)
        print(string.rep(" ", #denStr + 2) .. string.rep("─", #subStr))
        print(string.rep(" ", #denStr + 2) .. remStr)
        print("------------------------------")
    end

    -- Final solution with remainder
    local quotString = polyToString(quotient)
    local remString = polyToString(remainder)
    if remString == "0" then
        print("\nFinal Solution: (" .. polyToString(num) .. ") / (" .. polyToString(den) .. ") = " .. quotString)
    else
        print("\nFinal Solution: (" .. polyToString(num) .. ") / (" .. polyToString(den) .. ") = " .. quotString .. " + (" .. remString .. ") / (" .. polyToString(den) .. ")")
    end

    return quotient, remainder
end

-- Main
function main()
    local numerator = "2x^3 + 3x^2 - x + 5"
    local denominator = "x^2 - 1"

    local numPoly = parsePolynomial(numerator)
    local denPoly = parsePolynomial(denominator)

    longDivisionPaperStyle(numPoly, denPoly)
end

main()