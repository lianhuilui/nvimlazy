return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require('harpoon')

    harpoon.setup()

    vim.keymap.set('n', '<leader>`', function() harpoon:list():append() end)
    vim.keymap.set("n", "<leader>0", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
    
    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-9>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<C-0>", function() harpoon:list():next() end)
 
  end,
}
