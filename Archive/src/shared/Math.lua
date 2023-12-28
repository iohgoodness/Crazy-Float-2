
local Math = {}

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

function Math.Map(value, inputMin, inputMax, outputMin, outputMax)
    return outputMin + ((value - inputMin) / (inputMax - inputMin)) * (outputMax - outputMin)
end

function Math.Abbreviate(num)
    if num >= 1000000000000 then
        return string.format("%.1fT", math.floor(num / 100000000000) / 10)
    elseif num >= 1000000000 then
        return string.format("%.1fB", math.floor(num / 100000000) / 10)
    elseif num >= 1000000 then
        return string.format("%.1fM", math.floor(num / 100000) / 10)
    elseif num >= 1000 then
        return string.format("%.1fK", math.floor(num / 100) / 10)
    else
        return num
    end
end

function Math.CountDict(dict)
    local count = 0
    for _,_ in ipairs(dict) do
        count += 1
    end
    return count
end

function Math.SecondsToHHMMSS(totalSeconds)
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds - (hours * 3600)) / 60)
    local seconds = math.floor(totalSeconds - (hours * 3600) - (minutes * 60))
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function Math.SecondsToDHMS(totalSeconds)
    local days = math.floor(totalSeconds / 86400)
    local hours = math.floor((totalSeconds - (days * 86400)) / 3600)
    local minutes = math.floor((totalSeconds - (days * 86400) - (hours * 3600)) / 60)
    local seconds = math.floor(totalSeconds - (days * 86400) - (hours * 3600) - (minutes * 60))
    return string.format("%dd %02d:%02d:%02d", days, hours, minutes, seconds)
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
