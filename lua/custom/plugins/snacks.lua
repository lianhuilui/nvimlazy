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

        gitbrowse = { enabled = true },

        -- this plugin shows colors only for area where the cursor is, and grayscales the rest
        dim = { enabled = false },

        -- shows the vertical lines to show scope
        indent = { enabled = true },

        input = { enabled = true },

        -- important plugin used to grep and pick many things
        --
        picker = { enabled = true, fitler = { cwd = true  } },

        notifier = { enabled = true },

        quickfile = { enabled = true },

        scroll = { enabled = false },

        statuscolumn = { enabled = true },

        scratch = { enabled = false },

        -- explorer = { enabled = true },
        toggle = { enabled = true },
        words = { enabled = true },
        win = { enabled = true, wo = { signcolumn = 'yes' } },
        zen = {
            enabled = true,
            -- Configuration for zen mode
            toggles = {
                indent = false,
                dim = false,
                -- mini_diff_signs = false,
                -- signcolumn = false,
                -- diagnostics = false,
                -- inlay_hints = false,
            },
            show = {
                statusline = false, -- hide statusline
                tabline = false,    -- hide tabline
            },
            win = {
                style = "zen",
                width = 140,
                backdrop = { transparent = false },
            },

            -- win = {
            --     backdrop = { transparent = false, blend = 40 },
            --     width = 138, -- width of zen window (0.0 to 1.0)
            --     options = {
            --         signcolumn = "yes",
            --         statuscolumn = false,
            --         number = false,
            --         relativenumber = false,
            --         cursorline = false,
            --         cursorcolumn = false,
            --         foldcolumn = "0",
            --         list = false,
            --     },
            -- },
            -- plugins to disable when zen mode is active
            plugins = {
                tmux = { enabled = false },
                kitty = { enabled = false },
            },
        },
    },
    keys = {
        -- zen
        { "<leader>z",       function() Snacks.zen() end,                    desc = "Toggle Zen Mode" },
        -- { "<leader>.",  function() Snacks.scratch() end,                desc = "Toggle Scratch" },
        -- { "<leader>S",  function() Snacks.scratch.select() end,         desc = "Select Scratch Buffer" },
        --
        -- git
        { "<leader>gl",      function() Snacks.picker.git_log() end,         desc = "Git Log" },
        { "<leader>gL",      function() Snacks.picker.git_log_line() end,    desc = "Git Log Line" },
        { "<leader>gs",      function() Snacks.picker.git_status() end,      desc = "Git Status" },
        { "<leader>gd",      function() Snacks.picker.git_diff() end,        desc = "Git Diff (Hunks)" },

        -- search
        { '<leader>s"',      function() Snacks.picker.registers() end,       desc = "Registers" },
        { "<leader>sn",      function() Snacks.picker.notifications() end,   desc = "Notification History" },
        { '<leader>s/',      function() Snacks.picker.search_history() end,  desc = "Search History" },
        { "<leader>sa",      function() Snacks.picker.autocmds() end,        desc = "Autocmds" },
        { "<leader>sb",      function() Snacks.picker.lines() end,           desc = "Buffer Lines" },
        { "<leader>sc",      function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sC",      function() Snacks.picker.commands() end,        desc = "Commands" },
        { "<leader>sd",      function() Snacks.picker.diagnostics() end,     desc = "Diagnostics" },
        { "<leader>sm",      function() Snacks.picker.marks() end,           desc = "Marks" },
        { "<leader>sk",      function() Snacks.picker.keymaps() end,         desc = "Key maps" },
        { "<leader>sg",      function() Snacks.picker.grep() end,            desc = "Grep" },
        { "<leader>sw",      function() Snacks.picker.grep_word() end,       desc = "Visual Selection or word" },
        { "<leader>sh",      function() Snacks.picker.help() end,            desc = "Help Pages" },

        --{ "<leader><space>", function() Snacks.picker.recent({filter = {cwd = true}}) end,          desc = "Recent Files" },
        { "<leader><space>", function() Snacks.picker.recent() end,          desc = "Recent Files" },

        -- git browse
        { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },


        { "<leader>sf",      function() Snacks.picker.files() end,           desc = "Find files" },
        { "<leader>sF",      function() Snacks.picker.git_files() end,       desc = "Find files (only in git)" },

        { "<leader>t",       function() Snacks.terminal() end,               desc = "Toggle Terminal" },
        -- { "<c-_>",      function() Snacks.terminal() end,               desc = "which_key_ignore" },

        -- explorer
        { "<leader>e",       function() Snacks.explorer() end,               desc = "File Explorer" },

    },

    init = function()
        vim.api.nvim_create_autocmd("User", {
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.line_number():map("<leader>ul")
                Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                    :map("<leader>uc")
                Snacks.toggle.treesitter():map("<leader>uT")
                Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
                    "<leader>ub")
                Snacks.toggle.inlay_hints():map("<leader>uh")
                Snacks.toggle.indent():map("<leader>ui")

                -- f for focus mode
                Snacks.toggle.dim():map("<leader>uf")
                Snacks.toggle.option("signcolumn", { on = "yes", off = "no", name = "Sign Column" }):map("<leader>uS")
            end,
            pattern = "VeryLazy",
        })
    end,
}
