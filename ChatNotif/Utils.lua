function DumpTable(table)
    -- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
    if type(table) == 'table' then
       local string = '{ '
       for key,value in pairs(table) do
          if type(key) ~= 'number' then key = '"'..key..'"' end
          string = string .. '['..key..'] = ' .. DumpTable(value) .. ','
       end
       return string .. '} '
    else
       return tostring(table)
    end
 end

function Clamp(value, min, max)
    return math.max(math.min(value, max), min)
end

function InvertTable(table)
    local inverted = {};
    for key, value in pairs(table) do
        inverted[value] = key;
    end
    return inverted;
end