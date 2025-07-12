return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 
        'nvim-treesitter/nvim-treesitter', 
        'echasnovski/mini.nvim' -- For mini.icons
    },
    config = function()
        require('render-markdown').setup({})
    end,
    ft = { 'markdown' }, -- Only load for markdown files
} 