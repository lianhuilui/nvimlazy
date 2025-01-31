return {
    'ggandor/leap.nvim',
    config = function()
        local leap = require('leap')
        leap.create_default_mappings()

        leap.opts.safe_labels = 'sfnut'
        leap.opts.labels = 'abcdefghijklmnopqrstuvwxyz'
    end,
}
