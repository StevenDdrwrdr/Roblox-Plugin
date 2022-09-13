local class = require(script.Parent.class)

local object = {}
local list = {}
local data = {}
local meta = {}
meta.__index = data
meta.__newindex = function() end

function IsEmpty(t : table)
    local i = next(t, nil)
    if i then
        return false
    end
    return true
end

function object.new(ClassName : string)
    local t = {
        ClassName = ClassName,
        Id = "",
        Position = Vector3.new(),
        Connections = {},
    }
    t.Id = tostring(t)
    setmetatable(t, meta)
    list[t.Id] = t
    return t
end

function object:Get(TargetId : string)
    if list[TargetId] then
        return list[TargetId]
    end
end

function data:Connect(SourceNode : string, TargetId : string, TargetNode : string)
    warn("Check if nodes are valid")
    local SourceId = self.Id
    if self.Connections[SourceNode] == nil then
        self.Connections[SourceNode] = {}
    end
    if self.Connections[SourceNode][TargetId] == nil then
        self.Connections[SourceNode][TargetId] = {}
    end
    if self.Connections[SourceNode][TargetId][TargetNode] == nil then
        self.Connections[SourceNode][TargetId][TargetNode] = true
        object:Get(TargetId):Connect(TargetNode, SourceId, SourceNode)
    end
end

function data:Disconnect(SourceNode : string, TargetId : string, TargetNode : string)
    warn("Check if nodes are valid")
    local SourceId = self.Id
    if self.Connections[SourceNode] then
        if self.Connections[SourceNode][TargetId] then
            if self.Connections[SourceNode][TargetId][TargetNode] then
                self.Connections[SourceNode][TargetId][TargetNode] = nil
                object:Get(TargetId):Connect(TargetNode, SourceId, SourceNode)
            end
            if IsEmpty(self.Connections[SourceNode][TargetId]) then
                self.Connections[SourceNode][TargetId] = nil
            end
        end
        if IsEmpty(self.Connections[SourceNode]) then
            self.Connections[SourceNode] = nil
        end
    end
end

function data:Destroy()
    local SourceId = self.Id
    for SourceNode, t0 in pairs(self.Connections) do
        for TargetId, t1 in pairs(t0) do
            local target = object:Get(TargetId)
            for TargetNode, _ in pairs(t1) do
                self:Disconnect(SourceNode, TargetId, TargetNode)
            end
        end
    end
    list[SourceId] = nil
end

return object
