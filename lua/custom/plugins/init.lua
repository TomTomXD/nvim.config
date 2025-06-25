-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    -- Vim-doge plugin for generating documentation
    'kkoomen/vim-doge',
    run = ':call doge#install()',

    -- All mappings are turned off
    init = function()
      vim.g.doge_enable_mappings = 0
    end,

    -- Generating of documentation is mappped to <leader>d
    vim.keymap.set('n', '<leader>d', '<Plug>(doge-generate)', { desc = 'Generate [D]ocumentation' }),
  },
  {
    -- This plugin is for autoclosing tags
    'windwp/nvim-ts-autotag',
    opts = {},
    event = 'VeryLazy',
  },
  {
    -- Lazygit plugin for git integration
    'kdheepak/lazygit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },

    -- Opening of lazygit is mapped to '<leader>lg'
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
}
