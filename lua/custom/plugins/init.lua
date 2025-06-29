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
  {
    -- Configuration of Roslyn LSP for C#
    'seblyng/roslyn.nvim',
    ft = 'cs',
    opts = {
      -- Automatic solution searching in parent folders
      broad_search = true,

      -- If you have multiple .sln files, you can lock the solution selection
      lock_target = false,

      -- Let Roslyn handle filewatching
      filewatching = 'roslyn',
    },
    config = function()
      require('roslyn').setup {}

      -- Enable Treesitter for better documentation highlighting
      vim.treesitter.language.register('c_sharp', 'csharp')

      -- LSP configuration for maximum autocomplete, suggestions and fixes
      vim.lsp.config('roslyn', {
        settings = {
          -- Inlay hints (types, parameters, implicit variables)
          ['csharp|inlay_hints'] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = false,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = false,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = false,
          },
          -- Code lens (references, tests)
          ['csharp|code_lens'] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
          },
          -- Completions (including unimported types)
          ['csharp|completion'] = {
            dotnet_provide_regex_completions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          -- Automatic import fixing during formatting
          ['csharp|formatting'] = {
            dotnet_organize_imports_on_format = true,
          },
          -- Symbol search (including in referenced assemblies)
          ['csharp|symbol_search'] = {
            dotnet_search_reference_assemblies = true,
          },
          -- Diagnostics for the entire solution (not just open files)
          ['csharp|background_analysis'] = {
            background_analysis_dotnet_analyzer_diagnostics_scope = 'fullSolution',
            background_analysis_dotnet_compiler_diagnostics_scope = 'fullSolution',
          },
        },
      })
    end,
  },
}
