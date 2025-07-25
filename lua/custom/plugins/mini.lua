return {
  'echasnovski/mini.nvim',
  version = '*',
  config = function()
    require('mini.files').setup({
      windows = {
        preview = true
      }
    })
  end
}
