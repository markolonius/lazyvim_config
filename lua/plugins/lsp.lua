-- add pylsp to lspconfig
return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pylsp and ruff_lsp will be automatically installed with mason and loaded with lspconfig
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                configurationSources = { "pycodestyle", "mccabe", "rope_autoimport" },
                jedi_completion = {
                  enabled = true,
                  eager = true,
                  cache_for = { "numpy", "scipy", "matplotlib" },
                },
                jedi_definition = {
                  enabled = true,
                  follow_imports = true,
                  follow_builtin_imports = true,
                },
                jedi_hover = { enabled = true },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = { enabled = true, all_scopes = true, include_import_symbols = true },
                preload = { enabled = true, modules = { "numpy", "scipy", "matplotlib" } },
                isort = { enabled = false },
                black = { enabled = false },
                spyder = { enabled = false },
                mccabe = { enabled = true },
                ruff = { enabled = false },
                mypy = { enabled = false },
                rope_autoimport = { enabled = true },
                flake8 = { enabled = false, maxLineLength = 120 },
                yapf = { enabled = false },
                autopep8 = { enabled = false },
                pycodestyle = { enabled = false, ignore = {} },
                pyflakes = { enabled = false },
              },
            },
          },
        },
        ruff_lsp = {},
        pyright = {
          mason = false,
          autostart = false,
        },
      },
      setup = {
        ruff_lsp = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "python-lsp-server",
        "ruff-lsp",
        "blue",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = function()
      local plugin = require("lazy.core.config").plugins["conform.nvim"]
      if plugin.config ~= M.setup then
        Util.error({
          "Don't set `plugin.config` for `conform.nvim`.\n",
          "This will break **LazyVim** formatting.\n",
          "Please refer to the docs at https://www.lazyvim.org/plugins/formatting",
        }, { title = "LazyVim" })
      end
      ---@class ConformOpts
      return {
        -- LazyVim will use these options when formatting with the conform.nvim formatter
        format = {
          timeout_ms = 1000,
        },
        formatters_by_ft = {
          blue = { "blue" },
          lua = { "stylua" },
          fish = { "fish_indent" },
          sh = { "shfmt" },
          gofmt = { "gofmt" },
        },
        -- LazyVim will merge the options you set here with builtin formatters.
        -- You can also define any custom formatters here.
        ---@type table<string,table>
        formatters = {
          injected = { options = { ignore_errors = true } },
          -- # Example of using dprint only when a dprint.json file is present
          -- dprint = {
          --   condition = function(ctx)
          --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          --   end,
          -- },
          --
          -- # Example of using shfmt with extra args
          -- shfmt = {
          --   extra_args = { "-i", "2", "-ci" },
          -- },
        },
      }
    end,
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      -- Event to trigger linters
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        stylua = { "stylua" },
        prettier = { "prettier" },
        gofmt = { "gofmt" },
        isort = { "isort" },
      },
      -- LazyVim extension to easily override linter options
      -- or add custom linters.
      ---@type table<string,table>
      linters = {
        -- -- Example of using selene only when a selene.toml file is present
        -- selene = {
        --   -- `condition` is another LazyVim extension that allows you to
        --   -- dynamically enable/disable linters based on the context.
        --   condition = function(ctx)
        --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
      },
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "python" },
    },
  },
}
