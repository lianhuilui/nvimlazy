return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require('neo-tree').setup {
      window = {
        mappings = {
          ["E"] = "expand_all_nodes"
        }
      },
      -- Better session integration
      retain_hidden_root_indent = true,
      -- Auto-open when restoring session
      event_handlers = {
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd p")
            end
          end,
        },
      }
    }
  end,
}
