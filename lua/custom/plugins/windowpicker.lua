return {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
        require('window-picker').setup({
            filter_rules = {
                include_current_win = false,
                autoselect_one = true,
                -- filter using buffer options
                bo = {
                    -- if the file type is one of following, the window will be ignored
                    filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                    -- if the buffer type is one of following, the window will be ignored
                    buftype = { 'terminal', 'quickfix' },
                },
            },
            hint = 'floating-big-letter',
            show_prompt = false,
        })

        -- Key mappings
        vim.keymap.set('n', '<leader>wp', function()
            local window_number = require('window-picker').pick_window()
            if window_number then
                vim.api.nvim_set_current_win(window_number)
            end
        end, { desc = '[W]indow [P]icker - Pick window' })

        vim.keymap.set('n', '<leader>ws', function()
            local window_number = require('window-picker').pick_window()
            if window_number then
                local current_buf = vim.api.nvim_get_current_buf()
                local target_buf = vim.api.nvim_win_get_buf(window_number)
                vim.api.nvim_win_set_buf(window_number, current_buf)
                vim.api.nvim_set_current_buf(target_buf)
                vim.api.nvim_set_current_win(window_number)
                vim.api.nvim_set_current_buf(current_buf)
            end
        end, { desc = '[W]indow [S]wap - Move current buffer to picked window' })
    end,
}
