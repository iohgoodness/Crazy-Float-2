return {
    FuzzySearch = function(keyword, list)
        local matches = {}
        local normalizedKeyword = string.lower(keyword)
        for _, item in ipairs(list) do
            local normalizedItem = string.lower(item)
            if string.find(normalizedItem, normalizedKeyword) then table.insert(matches, item) end
        end
        return matches
    end
}