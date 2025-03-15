local f = require("lib")

function f.test(options)
    local title = f.is_string(options.title or "my applicaton")
    f.msg(title)
    local result = title .. " is the title"
    return f.is_string(result)
end    