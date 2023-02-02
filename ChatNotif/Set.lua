function NewSet()
    return {}
end

function AddToSet(set, element)
    if (set ~= nil and type(set) == "table" and element ~= nil) then
        set[element] = true;
    end
end

function ExistsInSet(set, element)
    return set ~= nil and
        type(set) == "table" and
        element ~= nil and
        (set[element] == true);
end

function RemoveFromSet(set, element)
    if (set ~= nil and type(set) == "table" and element ~= nil) then
        set[element] = false;
    end
end

-- Simple Set class

Set = { set = {} };

-- Add an element to the set
function Set:add(element)
    if (set ~= nil and type(set) == "table" and element ~= nil) then
        self.set[element] = true;
    end
end

-- Check if an element is in the set
function Set:exists(element)
    return element ~= nil and self.set ~= nil and self.set[element];
end

-- Remove an element from the set
function Set:remove(element)
    if (set ~= nil and type(set) == "table" and element ~= nil) then
        self.set[element] = false;
    end
end