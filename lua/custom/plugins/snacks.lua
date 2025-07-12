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
        dashboard = {
            enabled = true,
            preset = {
                header = get_header(),
                -- Custom actions without restore session
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = " ", key = "s", desc = "Git Status", action = ":lua Snacks.lazygit()" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            }
        },
        git = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = false },
        quickfile = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        -- explorer = { enabled = true },
        toggle = { enabled = true },
        words = { enabled = true },
        zen = {
            enabled = true,
            -- Configuration for zen mode
            toggles = {
                dim = false,
                git_signs = false,
                mini_diff_signs = false,
                -- diagnostics = false,
                -- inlay_hints = false,
            },
            show = {
                statusline = false, -- hide statusline
                tabline = false,    -- hide tabline
            },
            win = {
                backdrop = { transparent = false, blend = 40 },
                width = 0.8, -- width of zen window (0.0 to 1.0)
                options = {
                    signcolumn = "no",
                    number = false,
                    relativenumber = false,
                    cursorline = false,
                    cursorcolumn = false,
                    foldcolumn = "0",
                    list = false,
                },
            },
            -- plugins to disable when zen mode is active
            plugins = {
                gitsigns = { enabled = false },
                tmux = { enabled = false },
                kitty = { enabled = false },
            },
        },
    },
    keys = {
        -- zen
        { "<leader>z",  function() Snacks.zen() end,                    desc = "Toggle Zen Mode" },
        { "<leader>.",  function() Snacks.scratch() end,                desc = "Toggle Scratch" },
        -- others
        -- search
        { '<leader>s"', function() Snacks.picker.registers() end,       desc = "Registers" },
        { '<leader>s/', function() Snacks.picker.search_history() end,  desc = "Search History" },
        { "<leader>sa", function() Snacks.picker.autocmds() end,        desc = "Autocmds" },
        { "<leader>sb", function() Snacks.picker.lines() end,           desc = "Buffer Lines" },
        { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sC", function() Snacks.picker.commands() end,        desc = "Commands" },
        { "<leader>sd", function() Snacks.picker.diagnostics() end,     desc = "Diagnostics" },
        { "<leader>sm", function() Snacks.picker.marks() end,           desc = "Marks" },
        { "<leader>G",  function() Snacks.picker.grep() end,            desc = "Grep" },
        { "<leader>t",  function() Snacks.terminal() end,               desc = "Toggle Terminal" },
        -- { "<c-_>",      function() Snacks.terminal() end,               desc = "which_key_ignore" },
        -- explorer
        { "<leader>e",  function() Snacks.explorer() end,               desc = "File Explorer" },
    },
}
