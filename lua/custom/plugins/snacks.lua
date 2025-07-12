local function pad_strings_to_longest(input)
    local lines, max_len = {}, 0
    for line in input:gmatch("[^\n]+") do
        table.insert(lines, line)
        if #line > max_len then max_len = #line end
    end
    for i, line in ipairs(lines) do
        lines[i] = line .. string.rep(" ", max_len - #line)
    end
    return table.concat(lines, "\n")
end

local get_header = function(message)
    local cwd = vim.fn.getcwd()
    local default_message = "Welcome to " .. cwd .. "!"
    message = message or default_message
    flags = ""
    local handle = io.popen('cowsay ' .. flags .. ' ' .. '"' .. message:gsub('"', '\\"') .. '"')
    if handle then
        local result = handle:read("*a")
        handle:close()
        return pad_strings_to_longest(result)
    else
        return pad_strings_to_longest(message)
    end
end


return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        dashboard = { enabled = true, preset = {
            header = get_header()
        } },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = false },
        quickfile = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        toggle = { enabled = true },
        words = { enabled = true },
    },
}
