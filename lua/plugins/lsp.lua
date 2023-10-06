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
          require("lazyvim.util").on_attach(function(client, _)
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
      },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      --opts.sources = vim.list_extend(opts.sources, {
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          --nls.builtins.formatting.black,
          nls.builtins.formatting.blue,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.prettier,
          nls.builtins.formatting.gofmt,
          nls.builtins.formatting.isort,
        },
      }
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "python" },
    },
  },
}
