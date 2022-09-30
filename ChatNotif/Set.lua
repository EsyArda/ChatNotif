function NewSet()
    return {}
end

function AddToSet(set, element)
    if (set ~= nil and type(set) == "table" and element ~= nil) then
        set[element] = true;
        print(tostring(element) .. " added");
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
        print(tostring(element) .. " removed");
    end
end
