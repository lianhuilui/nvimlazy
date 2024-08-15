return {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        local alpha = require'alpha'
        local startify = require'alpha.themes.theta'

        -- disable top buttons
        -- startify.section.top_buttons.val = {}

        -- disable MRU
        -- startify.section.mru.val = { { type = "padding", val = 0 } }

        alpha.setup(startify.config)
    end
};
