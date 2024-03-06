function RecursivePrintTable(k, v)
    if type(v) == "table" then
        for key, value in pairs(v) do
            Turbine.Shell.WriteLine(tostring(k)..":")
            RecursivePrintTable(key, value)
        end
    else
        Turbine.Shell.WriteLine("["..tostring(k).."] = "..tostring(v))
    end
end
