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

    -- Opening of lazygit is mapped to '<leader>g'
    keys = {
      { '<leader>g', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  -- Plugin for .NET/C# tests
  {
    'Issafalcon/neotest-dotnet',
  },
  -- Plugin for running tests
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'Issafalcon/neotest-dotnet',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-dotnet' { discovery_root = 'solution' },
        },
      }
      -- Map '<leader>tA' to run all tests
      vim.keymap.set('n', '<leader>tA', function()
        require('neotest').summary.open()
        require('neotest').run.run(vim.loop.cwd())
      end, { desc = 'Open summary and run all tests in workspace' })
    end,
  },
}
