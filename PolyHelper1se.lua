-- TI-Nspire Lua Widget: Step-by-Step Polynomial Tool
-- Quadratic factoring + Polynomial long division
-- Fully interactive

-- Functions
function quadratic_discriminant(a,b,c)
    return b*b - 4*a*c
end

function factor_quadratic(a,b,c, output)
    output.text = ""
    output.text = output.text.."Quadratic: "..a.."x^2 + "..b.."x + "..c.."\n"
    local D = quadratic_discriminant(a,b,c)
    output.text = output.text.."Discriminant: "..D.."\n"
    if D < 0 then
        output.text = output.text.."No real roots. Factorization not possible over reals.\n"
    else
        local sqrtD = math.sqrt(D)
        local x1 = (-b + sqrtD)/(2*a)
        local x2 = (-b - sqrtD)/(2*a)
        output.text = output.text.."Roots: x1="..x1..", x2="..x2.."\n"
        output.text = output.text.."Factored form: "..a.."*(x - "..x1..")*(x - "..x2..")\n"
    end
end

function poly_division(num, den, output)
    local r = {}
    for i=1,#num do r[i] = num[i] end
    local q = {}
    local n_deg = #num - 1
    local d_deg = #den - 1

    output.text = ""
    output.text = output.text.."Numerator: "..table.concat(num," ").."\n"
    output.text = output.text.."Denominator: "..table.concat(den," ").."\n\n"

    local step = 1
    while #r >= #den do
        local lead_r = r[1]
        local lead_d = den[1]
        local power = #r - #den
        local term = lead_r / lead_d
        q[#q+1] = term
        output.text = output.text.."Step "..step..":\n"
        output.text = output.text.."Divide leading term: "..lead_r.." / "..lead_d.." = "..term.." (x^"..power..")\n"
        -- Subtract term*denominator
        for i=1,#den do
            r[i] = r[i] - term*den[i]
        end
        -- Remove leading zeros
        while r[1]==0 and #r>0 do table.remove(r,1) end
        output.text = output.text.."Remainder: "..(#r>0 and table.concat(r," ") or "0").."\n\n"
        step = step + 1
    end
    output.text = output.text.."Quotient: "..table.concat(q," ").."\n"
    output.text = output.text.."Final Remainder: "..(#r>0 and table.concat(r," ") or "0").."\n"
end

-- GUI Setup
function on.create(form)
    form:setTitle("Polynomial Tool")
    form:addLabel(10,10, "Quadratic a b c:")
    local a_input = form:addTextField(120,10,50,25)
    local b_input = form:addTextField(180,10,50,25)
    local c_input = form:addTextField(240,10,50,25)
    local quad_output = form:addTextArea(10,50,380,150)
    local quad_button = form:addButton(10,210,150,40,"Factor Quadratic", 
        function() 
            local a = tonumber(a_input:text())
            local b = tonumber(b_input:text())
            local c = tonumber(c_input:text())
            if a and b and c then factor_quadratic(a,b,c, quad_output) end
        end)

    form:addLabel(10,260,"Polynomial Division: Num Den (space-separated)")
    local num_input = form:addTextField(10,290,180,25)
    local den_input = form:addTextField(200,290,180,25)
    local div_output = form:addTextArea(10,320,380,200)
    local div_button = form:addButton(10,530,150,40,"Divide Polynomials",
        function()
            local num_text = num_input:text()
            local den_text = den_input:text()
            if num_text and den_text then
                local num = {}
                for n in string.gmatch(num_text,"%S+") do table.insert(num, tonumber(n)) end
                local den = {}
                for d in string.gmatch(den_text,"%S+") do table.insert(den, tonumber(d)) end
                poly_division(num, den, div_output)
            end
        end)
end
