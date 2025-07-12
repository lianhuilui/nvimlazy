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
      close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        position = "left",
        width = 30,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = "none", -- Remove space mapping to avoid conflicts
          ["E"] = "expand_all_nodes",
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
        }
      },
      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_hidden = true, -- only works on Windows for hidden files/directories
        },
        follow_current_file = {
          enabled = false, -- This will find and focus the file in the active buffer every time
        },
        group_empty_dirs = false, -- when true, empty folders will be grouped together
        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
      },
      -- Safe event handlers
      event_handlers = {
        {
          event = "file_open_requested",
          handler = function()
            -- Auto close neo-tree when file is opened
            require("neo-tree.command").execute({ action = "close" })
          end
        },
      }
    }
  end,
}
