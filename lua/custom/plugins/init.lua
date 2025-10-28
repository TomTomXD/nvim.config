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
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    config = function()
      local jdtls = require('jdtls')
      local home = os.getenv('HOME') or os.getenv('USERPROFILE')
      local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local config = {
        cmd = {
          'jdtls',
          '-data', home .. '/.cache/jdtls/' .. workspace_dir,
        },
        root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml' }),
      }
      jdtls.start_or_attach(config)
    end,
  },
  {
    -- Java run shortcut for .java files
    'nvim-lua/plenary.nvim', -- dependency for job control
    ft = { 'java' },
    config = function()
      vim.keymap.set('n', '<leader>jr', function()
        local file = vim.api.nvim_buf_get_name(0)
        if file:match('%.java$') then
          local cmd = string.format('java %s', file)
          vim.fn.jobstart(cmd, {
            on_stdout = function(_, data)
              if data then print(table.concat(data, '\n')) end
            end,
            on_stderr = function(_, data)
              if data then print(table.concat(data, '\n')) end
            end,
            on_exit = function(_, code)
              print('Java exited with code ' .. code)
            end,
          })
        else
          print('Not a Java file!')
        end
      end, { desc = 'Run current Java file' })
    end,
  },
  {
    -- Abstract shortcut for running Java projects (Maven/Gradle/Single file)
    'nvim-lua/plenary.nvim',
    ft = { 'java' },
    config = function()
      vim.keymap.set('n', '<leader>jp', function()
        local cwd = vim.fn.getcwd()
        if vim.fn.filereadable(cwd .. '/pom.xml') == 1 then
          -- Maven project
          vim.fn.jobstart('mvn compile exec:java', {
            cwd = cwd,
            on_stdout = function(_, data)
              if data then print(table.concat(data, '\n')) end
            end,
            on_stderr = function(_, data)
              if data then print(table.concat(data, '\n')) end
            end,
            on_exit = function(_, code)
              print('Maven exited with code ' .. code)
            end,
          })
        elseif vim.fn.filereadable(cwd .. '/build.gradle') == 1 or vim.fn.filereadable(cwd .. '/build.gradle.kts') == 1 then
          -- Gradle project
          local gradle_cmd = vim.fn.filereadable(cwd .. '/gradlew') == 1 and './gradlew run' or 'gradle run'
          vim.fn.jobstart(gradle_cmd, {
            cwd = cwd,
            on_stdout = function(_, data)
              if data then print(table.concat(data, '\n')) end
            end,
            on_stderr = function(_, data)
              if data then print(table.concat(data, '\n')) end
            end,
            on_exit = function(_, code)
              print('Gradle exited with code ' .. code)
            end,
          })
        else
          -- Single file (if not a project)
          local file = vim.api.nvim_buf_get_name(0)
          local class_name = file:match('([^/\\]+)%.java$')
          if class_name then
            local javac_cmd = string.format('javac "%s"', file)
            local java_cmd = string.format('java %s', class_name)
            vim.fn.jobstart(javac_cmd, {
              cwd = cwd,
              on_exit = function(_, code)
                if code == 0 then
                  vim.fn.jobstart(java_cmd, {
                    cwd = cwd,
                    on_stdout = function(_, data)
                      if data then print(table.concat(data, '\n')) end
                    end,
                    on_stderr = function(_, data)
                      if data then print(table.concat(data, '\n')) end
                    end,
                    on_exit = function(_, code2)
                      print('Java exited with code ' .. code2)
                    end,
                  })
                else
                  print('javac failed!')
                end
              end,
            })
          else
            print('Could not find Java class!')
          end
        end
      end, { desc = 'Run Java project (Maven/Gradle/Single file)' })
    end,
  },
}
