
local Math = {}

local ABBREVIATIONS = {
    "K", -- 4 digits
    "M", -- 7 digits
    "B", -- 10 digits
    "t", -- 13 digits
    "q", -- 16 digits
    "Q", -- 19 digits
    "s", -- 22 digits
    "S", -- 25 digits
    "o", -- 28 digits
    "n", -- 31 digits
    "d", -- 34 digits
    "U", -- 37 digits
    "D", -- 40 digits
}

function Math.Commas(num)
    local formatted = num
    while true do
        ---@diagnostic disable-next-line: undefined-global
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

function Math.SecondsToHHMMSS(totalSeconds)
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds - (hours * 3600)) / 60)
    local seconds = math.floor(totalSeconds - (hours * 3600) - (minutes * 60))

    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function Math.Lerp(a, b, c)
    return a + (b - a) * c
end

function Math.QuadBezier(t, p0, p1, p2)
    local l1 = p0 + (p1 - p0) * t
    local l2 = p1 + (p2 - p1) * t
    local quad = l1 + (l2 - l1) * t
    return quad
end

return Math
