-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)


-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  --  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      {
        'williamboman/mason-lspconfig.nvim',
        requires = {
          'neovim/nvim-lspconfig',
          'williamboman/mason.nvim',
        },
        config = function()
          local servers = {
            -- clangd = {},
            -- gopls = {},
            -- pyright = {},
            -- rust_analyzer = {},
            ts_ls = {},
            lua_ls = {},
            html = { filetypes = { 'html', 'twig', 'hbs', 'ftlh' } },
          }

          require('mason').setup()
          require('mason-lspconfig').setup({
            ensure_installed = vim.tbl_keys(servers),
          })
        end,
      },

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {
      preset = 'helix', -- vertical style: (classic | modern | helix)
      win = {
        no_overlap = false,
        wo = {
          winblend = 60, -- value between 0-100. 0 = opaque. 100 = transparent.
        },
      },
      -- triggers = {
      --   { "<auto>", mode = "nxso" },
      -- },
      -- Start hidden and wait for a key to be pressed before showing the popup
      -- Only used by enabled xo mapping modes.
      -- @param ctx { mode: string, operator: string }
      -- defer = function(ctx)
      --   return false
      --   -- return ctx.mode == "V" or ctx.mode == "<C-V>"
      -- end,
    },
  },
  --
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
      end,
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme 'tokyonight-night'
    end
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        globalstatus = false,
        icons_enabled = true,
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = {}
      },
      inactive_sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = {},
        lualine_z = {}
      }
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',  opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    -- build = ':TSUpdate', -- is this the line causing errors?
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true


-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hlsearch = false
vim.o.termguicolors = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

vim.o.scrolloff = 8

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
---- what? vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set('n', '<C-j>', ':cn<cr>', { desc = 'Next in QuickFix List' })
vim.keymap.set('n', '<C-k>', ':cp<cr>', { desc = 'Prev in QuickFix List' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Color scheme selector
vim.keymap.set('n', '<leader>cs', function() require('telescope.builtin').colorscheme({ enable_preview = true }) end,
  { desc = "List [C]olor [S]cheme" })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    preview = {
      hide_on_startup = true
    },
    sorting_strategy = 'ascending',
    layout_strategy = 'vertical',
    layout_config = {
      vertical = {
        prompt_position = 'top'
      }
    },
    mappings = {
      i = {
        ['jf'] = 'close',
        ['jj'] = 'file_edit',
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<C-p>'] = require('telescope.actions.layout').toggle_preview,
        ['<C-j>'] = {
          require('telescope.actions').move_selection_next, type = 'action',
          opts = { nowait = true, silent = true }
        },
        ['<C-k>'] = {
          require('telescope.actions').move_selection_previous, type = 'action',
          opts = { nowait = true, silent = true }
        },
      },
      n = {
        ['<C-p>'] = require('telescope.actions.layout').toggle_preview,
        ['<C-j>'] = {
          require('telescope.actions').move_selection_next, type = 'action',
          opts = { nowait = true, silent = true }
        },
        ['<C-k>'] = {
          require('telescope.actions').move_selection_previous, type = 'action',
          opts = { nowait = true, silent = true }
        },
      },
    },
  },
  extensions = {
    -- recent_files = {
    --   only_cwd = true
    -- },
    live_grep_args = {
      mappings = {
        i = {
          ["  "] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob *" }),
        }
      }
    },
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- require('telescope').load_extension('recent_files')

require('telescope').load_extension("live_grep_args")

-- See `:help telescope.builtin`
-- vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
-- vim.keymap.set('n', '<leader>/', function()
-- You can pass additional configuration to telescope to change theme, layout, etc.
--   require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--     winblend = 10,
--     previewer = false,
--   })
-- end, { desc = '[/] Fuzzily search in current buffer' })

-- Map a shortcut to open the recent files picker.
-- vim.api.nvim_set_keymap("n", "<Leader><Leader>",
--   [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
--   { noremap = true, silent = true, desc = "Recent files" })

-- vim.keymap.set("n", "<Leader><Leader>", require('telescope').extensions.recent_files.pick, { noremap = true, silent = true, desc = "Recent files" }) -- replaced by snacks

-- vim.keymap.set('n', '<leader><leader>', require('telescope.builtin').recent_files, { desc = '[?] Find recently opened files' })
vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Undo Tree Toggle" })

-- vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
-- vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' }) -- replaced with Snacks.picker.grep_word()

--vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set("n", "<leader>sg", require('telescope').extensions.live_grep_args.live_grep_args, { desc = '[S]earch by [Grep] (args)' }) -- use the more powerful one

-- vim.keymap.set('n', '<leader>gD', require('telescope.builtin').diagnostics, { desc = '[G]rep [D]iagnostics' }) -- use <leader>sd instead
-- vim.keymap.set('n', '<leader>gg', require('telescope.builtin').resume, { desc = '[G]rep [G]o back' }) -- use <leader>sr instead

vim.keymap.set('n', '<leader>gp', require('telescope.builtin').builtin, { desc = '[G]rep command [P]allette' })



-- Window navigation
vim.keymap.set("n", "<leader>j", "<C-w>h", { desc = "Move Focus left" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Move Focus right" })
vim.keymap.set("n", "<leader>k", "<C-w>j", { desc = "Move Focus up" })
vim.keymap.set("n", "<leader>i", "<C-w>k", { desc = "Move Focus down" })

-- vim.keymap.set("n", "<leader>f", ":Neotree reveal<cr>", { desc = "[F]ocus file in Neotree" })
-- vim.keymap.set("n", "<leader>e", ":Neotree toggle<cr>", { desc = "Toggle File [E]xplorer" }) -- trying out Snacks.explorer

-- split windows
vim.keymap.set("n", "<leader>v", ":vnew<CR>", { desc = "New [V]ertical Pane" })
vim.keymap.set("n", "<leader>h", "<C-w>n", { desc = "New [H]orizontal Pane" })

vim.keymap.set("n", "<leader>V", ":vsplit<CR>", { desc = "[V]ertical Split" })
vim.keymap.set("n", "<leader>H", ":split<CR>", { desc = "[H]orizontal Split" })

-- write file
vim.keymap.set("n", "<leader>w", vim.cmd.w, { desc = "[W]rite file" })

-- hide nvim-tree
vim.keymap.set("n", "<leader>o", "<C-w>o", { desc = "Close all [O]ther windows" })

-- quit
vim.keymap.set("n", "<leader>q", vim.cmd.q, { desc = "[Q]uit window" })

-- exit insert mode
vim.keymap.set("i", "jf", "<esc>")
vim.keymap.set("i", "jj", "<CR>")

-- exit insertmode and save file
vim.keymap.set("i", "jw", "<esc>:w<CR>")
vim.keymap.set("i", "jl", vim.cmd.w) -- write file without leaving insert mode

-- Global formatting keymaps (safer version)
vim.keymap.set("n", "gq", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients > 0 then
    vim.lsp.buf.format()
  end
end, { desc = "Format entire buffer" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- to get rid of diagnostic warnings.. idk what the defaults are
  modules = {},
  sync_install = false,
  ignore_install = {},

  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'tsx', 'javascript', 'typescript', 'css', 'vimdoc' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  -- testing here
  indent = { enable = false },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>', -- control space
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>', -- option space
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev({ float = false }) end,
  { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next({ float = false }) end,
  { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>D', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.diagnostic.config({
  -- virtual_text = {
  --   virt_text_win_col = 80,
  --   virt_text_hide = true
  -- },
  virtual_lines = true
})

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>Ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-i>', vim.lsp.buf.signature_help, 'Signature Documentation') -- disabled C-i because it overrides jumps....

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>Wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>Wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>Wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  -- Enhanced formatting keymaps with error handling
  nmap('<leader>cf', function()
    pcall(vim.lsp.buf.format)
  end, "[C]ode [F]ormat")

  -- Format selected text in visual mode
  vim.keymap.set('v', '<leader>cf', function()
    pcall(vim.lsp.buf.format, { range = true })
  end, { buffer = bufnr, desc = '[C]ode [F]ormat selection' })

  -- Alternative format keybindings
  nmap('<leader>F', function()
    pcall(vim.lsp.buf.format)
  end, "[F]ormat buffer")
  vim.keymap.set('v', '<leader>F', function()
    pcall(vim.lsp.buf.format, { range = true })
  end, { buffer = bufnr, desc = '[F]ormat selection' })
end

local hot = true

local cold = false

-- -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- -- [[ Configure nvim-cmp ]]
-- -- See `:help cmp`
-- local cmp = require 'cmp'
-- local luasnip = require 'luasnip'
-- require('luasnip.loaders.from_vscode').lazy_load()
-- luasnip.config.setup {}

-- cmp.setup {
--   snippet = {
--     expand = function(args)
--       luasnip.lsp_expand(args.body)
--     end,
--   },
--   mapping = cmp.mapping.preset.insert {
--     ['<C-n>'] = cmp.mapping.select_next_item(),
--     ['<C-p>'] = cmp.mapping.select_prev_item(),
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete {},
--     ['<CR>'] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     },
--     ['<Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       elseif luasnip.expand_or_locally_jumpable() then
--         luasnip.expand_or_jump()
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--     ['<S-Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       elseif luasnip.locally_jumpable(-1) then
--         luasnip.jump(-1)
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--   },
--   sources = {
--     { name = 'nvim_lsp' },
--     { name = 'luasnip' },
--   },
-- }

-- THIS PART IS TRYING TO WRITE CUSTOM LSP
-- local client = vim.lsp.start_client {
--   name = "mylsp",
--   cmd = {
--     "npx", "ts-node", vim.fn.expand("~/Work/lsp/server/src/server.ts")
--   },
--   capabilities = vim.lsp.protocol.make_client_capabilities()
-- }
--
-- if not client then
--   vim.notify("nope my lsp could not start")
-- end
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "text",
--   callback = function()
--     vim.lsp.buf_attach_client(0, client)
--   end,
-- })

-- THIS PART IS TRYING TO WRITE CUSTOM TREE SITTER STUFF
-- local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
-- parser_configs["htl"] = {
--   install_info = {
--     url = "~/Work/tree-sitter-htl",
--     files = { "src/parser.c" }
--   },
--   filetype = "htl"
-- }

-- configure nvim terminal
local jobid
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

local runjobinterm = function(thecmd)
  if jobid ~= nil then
    vim.fn.chansend(jobid, { thecmd .. "\r" })
  else
    print("jobid is nil" .. jobid)
  end
end

-- key to open my custom terminal
vim.keymap.set("n", "<leader>xt", function()
  vim.cmd.new()
  vim.cmd.term()
  vim.api.nvim_win_set_height(0, 10)
  jobid = vim.bo.channel
end)

-- key to run python main.py inside that little terminal
vim.keymap.set("n", "<leader>xp", function()
  runjobinterm("python3 main.py")
end)

vim.keymap.set("n", "<leader>xj", function()
  runjobinterm("node main.js")
end)

vim.keymap.set("n", "<leader>xm", function()
  runjobinterm("yarn --cwd src/ClientSide dev")
end)

local function printFn(text)
  local _printFn = nil
  if Snacks.notify ~= nil then _printFn = Snacks.notify else _printFn = vim.print end

  _printFn(text)
end

vim.api.nvim_create_autocmd({ 'BufEnter' },
  {
    pattern = "*.lua",
    callback = function()
      local buffer = vim.api.nvim_get_current_buf()
      local cmd = function()
        printFn("My Command is running!")

        local maps = vim.api.nvim_get_keymap('n')

        local text = ''
        for _, v in ipairs(maps) do
          local desc = ""

          if v.desc then
            desc = " > " .. v.desc
          end

          -- mode: V
          -- <Tab> > vim.snippet.jump if active, otherwise <Tab>
          --  gB > Git Browse
          -- # > :help v_#-default
          -- %
          -- * > :help v_star-default
          -- @ > :help v_@-default
          -- Q > :help v_Q-default
          -- S > Leap backward
          -- [%
          -- ]%
          -- a%
          -- g%
          -- gb > Comment toggle blockwise (visual)
          -- gs > Leap from window
          -- gra > vim.lsp.buf.code_action()
          -- gc > Comment toggle linewise (visual)
          -- gx > Opens filepath or URI under cursor with the system handler (file explorer, web browser, …)
          -- s > Leap forward
          -- <Plug>(MatchitVisualTextObject)
          -- <Plug>(MatchitVisualMultiForward)
          -- <Plug>(MatchitVisualMultiBackward)
          -- <Plug>(MatchitVisualBackward)
          -- <Plug>(MatchitVisualForward)
          -- <Plug>(comment_toggle_blockwise_visual) > Comment toggle blockwise (visual)
          -- <Plug>(comment_toggle_linewise_visual) > Comment toggle linewise (visual)
          -- <Plug>luasnip-jump-prev > LuaSnip: Jump to the previous node
          -- <Plug>luasnip-jump-next > LuaSnip: Jump to the next node
          -- <Plug>luasnip-prev-choice > LuaSnip: Change to the previous choice from the choiceNode
          -- <Plug>luasnip-next-choice > LuaSnip: Change to the next choice from the choiceNode
          -- <Plug>luasnip-expand-snippet > LuaSnip: Expand the current snippet
          -- <Plug>luasnip-expand-or-jump > LuaSnip: Expand or jump in the current snippet
          -- <Plug>luasnip-expand-repeat > LuaSnip: Repeat last node expansion
          -- <Plug>(leap-backward-x)
          -- <Plug>(leap-forward-x)
          -- <Plug>(leap-cross-window)
          -- <Plug>(leap-backward-to)
          -- <Plug>(leap-forward-to)
          -- <Plug>(leap-backward-till)
          -- <Plug>(leap-backward)
          -- <Plug>(leap-forward-till)
          -- <Plug>(leap-forward)
          -- <Plug>(leap-anywhere)
          -- <Plug>(leap-from-window)
          -- <Plug>(leap)
          -- <S-Tab> > vim.snippet.jump if active, otherwise <S-Tab>
          -- <C-S> > vim.lsp.buf.signature_help()

          -- mode: N
          --  uS > Toggle Sign Column
          --  uf > Toggle Dimming
          --  ui > Toggle Indent Guides
          --  uh > Toggle Inlay Hints
          --  ub > Toggle Dark Background
          --  uT > Toggle Treesitter Highlight
          --  uc > Toggle conceallevel
          --  ul > Toggle Line Numbers
          --  ud > Toggle Diagnostics
          --  uL > Toggle Relative Number
          --  uw > Toggle Wrap
          --  us > Toggle Spelling
          --  ws > [W]indow [S]wap - Move current buffer to picked window
          --  wp > [W]indow [P]icker - Pick window
          --  xm
          --  xj
          --  xp
          --  xt
          --  Q > Open diagnostics list
          --  D > Open floating diagnostic message
          --  q > [Q]uit window
          --  o > Close all [O]ther windows
          --  w > [W]rite file
          --  H > [H]orizontal Split
          --  V > [V]ertical Split
          --  h > New [H]orizontal Pane
          --  v > New [V]ertical Pane
          --  i > Move Focus down
          --  k > Move Focus up
          --  l > Move Focus right
          --  j > Move Focus left
          --  gp > [G]rep command [P]allette
          --  U > Undo Tree Toggle
          --  cs > List [C]olor [S]cheme
          --  4 > Harpooned File [4]
          --  3 > Harpooned File [3]
          --  2 > Harpooned File [2]
          --  1 > Harpooned File [1]
          --  0 > Harpooned List
          --  ` > Append to Harpoon
          --    > Recent Files
          --  e > Mini Files Explorer
          --  E > File Explorer
          --  t > Toggle Terminal
          --  sF > Find files (only in git)
          --  sf > Find files
          --  gB > Git Browse
          --  g* > Lsp References
          --  ? > Help Pages
          --  sw > Visual Selection or word
          --  sg > Grep
          --  sk > Key maps
          --  sm > Marks
          --  sd > Diagnostics
          --  cp > Commands
          --  ch > Command History
          --  b > Buffer Lines
          --  / > Buffer Lines
          --  sa > Autocmds
          --  s/ > Search History
          --  sn > Notification History
          --  sr > Resume last search
          --  s" > Registers
          --  gd > Git Diff (Hunks)
          --  gs > Git Status
          --  gL > Git Log Line
          --  gl > Git Log
          --  z > Toggle Zen Mode
          --  lg > Open lazygit
          -- %
          -- & > :help &-default
          -- S > Leap backward
          -- Y > :help Y-default
          -- [%
          -- [  > Add empty line above cursor
          -- [B > :brewind
          -- [b > :bprevious
          -- [<C-T> >  :ptprevious
          -- [T > :trewind
          -- [t > :tprevious
          -- [A > :rewind
          -- [a > :previous
          -- [<C-L> > :lpfile
          -- [L > :lrewind
          -- [l > :lprevious
          -- [<C-Q> > :cpfile
          -- [Q > :crewind
          -- [q > :cprevious
          -- [D > Jump to the first diagnostic in the current buffer
          -- [d > Go to previous diagnostic message
          -- ]%
          -- ]  > Add empty line below cursor
          -- ]B > :blast
          -- ]b > :bnext
          -- ]<C-T> > :ptnext
          -- ]T > :tlast
          -- ]t > :tnext
          -- ]A > :last
          -- ]a > :next
          -- ]<C-L> > :lnfile
          -- ]L > :llast
          -- ]l > :lnext
          -- ]<C-Q> > :cnfile
          -- ]Q > :clast
          -- ]q > :cnext
          -- ]D > Jump to the last diagnostic in the current buffer
          -- ]d > Go to next diagnostic message
          -- gq > Format entire buffer
          -- g%
          -- gs > Leap from window
          -- gcA > Comment insert end of line
          -- gcO > Comment insert above
          -- gco > Comment insert below
          -- gbc > Comment toggle current block
          -- gb > Comment toggle blockwise
          -- g[ > Prev Reference
          -- g] > Next Reference
          -- gO > vim.lsp.buf.document_symbol()
          -- gri > vim.lsp.buf.implementation()
          -- grr > vim.lsp.buf.references()
          -- gra > vim.lsp.buf.code_action()
          -- grn > vim.lsp.buf.rename()
          -- gcc > Comment toggle current line
          -- gc > Comment toggle linewise
          -- gx > Opens filepath or URI under cursor with the system handler (file explorer, web browser, …)
          -- j
          -- k
          -- s > Leap forward
          -- y<C-G>
          -- <Plug>BlinkCmpDotRepeatHack
          -- <C-K> > Prev in QuickFix List
          -- <C-J> > Next in QuickFix List
          -- <Plug>(MatchitNormalMultiForward)
          -- <Plug>(MatchitNormalMultiBackward)
          -- <Plug>(MatchitNormalBackward)
          -- <Plug>(MatchitNormalForward)
          -- <Plug>(leap-backward-x)
          -- <Plug>(leap-forward-x)
          -- <Plug>(leap-cross-window)
          -- <Plug>(leap-backward-to)
          -- <Plug>(leap-forward-to)
          -- <Plug>(leap-backward-till)
          -- <Plug>(leap-backward)
          -- <Plug>(leap-forward-till)
          -- <Plug>(leap-forward)
          -- <Plug>(leap-anywhere)
          -- <Plug>(leap-from-window)
          -- <Plug>(leap)
          -- <C-0> > Next Harpooned File
          -- <C-9> > Previous Harpooned File
          -- <Plug>fugitive:
          -- <Plug>fugitive:y<C-G>
          -- <Plug>PlenaryTestFile
          -- <Plug>(comment_toggle_blockwise_count) > Comment toggle blockwise with count
          -- <Plug>(comment_toggle_linewise_count) > Comment toggle linewise with count
          -- <Plug>(comment_toggle_blockwise_current) > Comment toggle current block
          -- <Plug>(comment_toggle_linewise_current) > Comment toggle current line
          -- <Plug>(comment_toggle_blockwise) > Comment toggle blockwise
          -- <Plug>(comment_toggle_linewise) > Comment toggle linewise
          -- <Plug>luasnip-expand-repeat > LuaSnip: Repeat last node expansion
          -- <Plug>luasnip-delete-check > LuaSnip: Removes current snippet from jumplist
          -- <C-W><C-D> > Show diagnostics under the cursor
          -- <C-W>d > Show diagnostics under the cursor
          -- <C-L> > :help CTRL-L-default

          text = text .. v.lhs .. desc .. "\n"
        end
        printFn(text)

        -- vim.api.nvim_set_current_line(vim.api.nvim_get_current_line() .. " -- Heyyyyyyyy, brotherrrrrrr")
      end

      local opts = {}

      vim.api.nvim_buf_create_user_command(buffer, "MyCommand", cmd, opts)

      printFn("Hello, I have created MyCommand.\nPress <leader>xx to trigger")

      vim.keymap.set({ 'n' }, '<leader>xx', function()
        vim.cmd.MyCommand()
      end) -- when i press x, it should run the command

      -- /Users/heinzawoo/.config/nvim
      -- /Users/heinzawoo/.local/share/nvim/site
      -- /Users/heinzawoo/.local/share/nvim/lazy/lazy.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/nvim-colorizer.lua
      -- /Users/heinzawoo/.local/share/nvim/lazy/window-picker
      -- /Users/heinzawoo/.local/share/nvim/lazy/telescope-live-grep-args.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/telescope-fzf-native.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/telescope.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/nvim-ts-autotag
      -- /Users/heinzawoo/.local/share/nvim/lazy/vim-sleuth
      -- /Users/heinzawoo/.local/share/nvim/lazy/leap.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/vim-fugitive
      -- /Users/heinzawoo/.local/share/nvim/lazy/Comment.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/nui.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/nvim-web-devicons
      -- /Users/heinzawoo/.local/share/nvim/lazy/neo-tree.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/nvim-nio
      -- /Users/heinzawoo/.local/share/nvim/lazy/nvim-autopairs
      -- /Users/heinzawoo/.local/share/nvim/lazy/cmp-nvim-lsp
      -- /Users/heinzawoo/.local/share/nvim/lazy/cmp_luasnip
      -- /Users/heinzawoo/.local/share/nvim/lazy/LuaSnip
      -- /Users/heinzawoo/.local/share/nvim/lazy/nvim-cmp
      -- /Users/heinzawoo/.local/share/nvim/lazy/fidget.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/mason-lspconfig.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/mason.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/nvim-lspconfig
      -- /Users/heinzawoo/.local/share/nvim/lazy/undotree
      -- /Users/heinzawoo/.local/share/nvim/lazy/lualine.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/nvim-treesitter-textobjects
      -- /Users/heinzawoo/.local/share/nvim/lazy/nvim-treesitter
      -- /Users/heinzawoo/.local/share/nvim/lazy/smear-cursor.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/plenary.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/harpoon
      -- /Users/heinzawoo/.local/share/nvim/lazy/gitsigns.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/which-key.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/mini.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/friendly-snippets
      -- /Users/heinzawoo/.local/share/nvim/lazy/blink.cmp
      -- /Users/heinzawoo/.local/share/nvim/lazy/snacks.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/tokyonight.nvim
      -- /Users/heinzawoo/.local/share/nvim/lazy/luarocks.nvim
      -- /opt/homebrew/Cellar/neovim/0.11.2/share/nvim/runtime
      -- /opt/homebrew/Cellar/neovim/0.11.2/share/nvim/runtime/pack/dist/opt/netrw
      -- /opt/homebrew/Cellar/neovim/0.11.2/share/nvim/runtime/pack/dist/opt/matchit
      -- /opt/homebrew/Cellar/neovim/0.11.2/lib/nvim
      -- /Users/heinzawoo/.local/state/nvim/lazy/readme
      -- /Users/heinzawoo/.local/share/nvim/lazy/cmp-nvim-lsp/after
      -- /Users/heinzawoo/.local/share/nvim/lazy/cmp_luasnip/after
      -- /Users/heinzawoo/.local/share/nvim/lazy/mason-lspconfig.nvim/after

      --
    end

  })
