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
        dashboard = { enabled = true, preset = {
            header = [[
                $              
              .s$$             
             s$$$’            s
           .s$$$³´       ,   s$
          s$$$$³      .s$’   $ 
     ,    $$$$$.      s$³    ³$
     $   $$$$$$s     s$³     ³ 
    s$   ‘³$$$$$$s   $$$       
    $$    ³$$$$$$s.  ³$$s      
    ³$.    ³$$$$$$$s .s$$$    s
    `$$.    ³$$$$$$$ $$$$   s³ 
     ³$$s    ³$$$$$$s$$$³  s$’ 
      ³$$s    $$$$$s$$$$’  s$$ 
   $$ s$$$$..s$$$$$$$$$$$$$$³  
  s$$$$$$$$$$$$$$$$$$$$$$$$$$$³
$$s§§§§§§§§§s$$$$$$s§§§§§§§§s$,
 ³§§§§§§§§§§§§§§§§§§§§§§§§§§§³ 
     ³§§§§§§§§§§§§§§§§§§§³     
            ³§§§§§³            
]]

        } },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = false },
        quickfile = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        toggle = { enabled = true },
        words = { enabled = true },
    },
}
