local texttoparse = [[run "print('hacks')";]]
-- nice hacks
function mysplit (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end


function Parse(text) 

    local instructions = {}
    local currentinstruction = ""
    local instring = false


    for num=1,#text do
        local char = string.sub(texttoparse, num, num)
        if char == '"' then
            instring = not instring
        end
        if char == " " and not instring then
            instructions[#instructions+1] = currentinstruction
            currentinstruction = ""
        elseif char == ";" and not instring then
            if #currentinstruction == 0 then
                instructions[#instructions + 1] = ";"
            else
                instructions[#instructions+1] = currentinstruction
                instructions[#instructions+1] = ";"
            end
        elseif num == #texttoparse then
            instructions[#instructions+1] = currentinstruction..char
        else
          currentinstruction = currentinstruction..char
        end
    end
    for i,v in pairs(instructions) do
        print(v)
    end
    return instructions
end

local commands = {
  ["kick"] = function(plr, reason)
      print("Kicked "..plr.." for "..reason..".")
  end;
  ["restartserver"] = function(reason)

  end
}
local auto = {["restartserver"]=true}


function executeinstructions(instructions)
    if instructions[1] == "execute" then
        if instructions[2] == "command" then

            local command = commands[instructions[3]]
            if instructions[4] == "auto" then
                assert(auto[instructions[3]], "This command must have specified arguments.")
                assert(instructions[5] == ";", "Command ended late. Extra tokens must not be added after 'auto' token.")
                command()
            elseif instructions[4] == "params" then
                assert(string.match(instructions[5], '%b""'), "Expected string token after 'params' token.")
                 assert(instructions[6] == ";", "Command ended late. Extra tokens must not be added after 'string' token.")

                 local paramaters = mysplit(string.sub(instructions[5],2,#instructions[5]-1), ",")
                 command(unpack(paramaters))
            end
        end
    elseif instructions[1] == "view" then
        assert(instructions[2] == "params","Expected 'params' token after view instruction.")
        
    elseif instructions[1] == "run" then
        assert(string.match(instructions[2], '%b""'), "Expected string token after 'run' instruction.")
        assert(instructions[3] == ";", "Command ended late. Extra tokens must not be added after 'string' token.")
        loadstring(string.sub(instructions[2],2,#instructions[2]-1))() -- load string omgomgomg !?!?!?! yes i am hackerman scam
    end
end


executeinstructions(Parse(texttoparse))