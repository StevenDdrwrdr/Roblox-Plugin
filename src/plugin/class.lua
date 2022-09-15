local dictionary = require(script.Parent.dictionary)

local class = {}
local list = {}
local data = {}
local meta = {}
meta.__index = data
meta.__newindex = function() end

function class.new()
    local t = {}
    warn("Setup proper class construction")
    setmetatable(t,meta)
    return t
end

function class:Find(str : string)
    str = string.lower(str)
    local l = {}
    for className, _ in pairs(list) do
        if string.find(string.lower(className), str) then
            table.insert(l, className)
        end
    end
    return l
end

function class:Get(className : string)
    return list[className] or warn(string.format("ClassName '%s' not found", className))
end

do
    warn("Initialize internal script functions as class methods")
end

return class
