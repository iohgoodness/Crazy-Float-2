

return {

    GetDifference = function(table1, table2)
        local addedValues = {}
        for key, value in pairs(table1) do
            if table2[key] == nil then
                table.insert(addedValues, value)
            end
        end
        return addedValues
    end;

}