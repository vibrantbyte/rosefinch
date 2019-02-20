
--定义一个class
order = { className="order" };

order.serializable = 100002323;

function order:new()
    local obj = {};
    setmetatable(obj, self);
    self.__index = self;
    self.name = "autohome";
    return obj;
end

function order:get_name()
    return self.name;
end




return order;
