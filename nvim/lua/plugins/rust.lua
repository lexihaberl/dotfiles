return {
  -- Extend auto completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
          src = {
            cmp = { enabled = true },
          },
        },
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "crates" },
      }))
    end,
  },

  -- Add Rust & related to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
    end,
  },

  -- Ensure Rust debugger is installed
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "codelldb" })
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          vim.lsp.inlay_hint.enable(bufnr, true)
          -- register which-key mappings
          local wk = require("which-key")
          wk.register({
            ["<leader>cR"] = {
              function()
                vim.cmd.RustLsp("codeAction")
              end,
              "Code Action",
            },
            ["<leader>dr"] = {
              function()
                vim.cmd.RustLsp("debuggables")
              end,
              "Rust debuggables",
            },
          }, { mode = "n", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
  },

  -- Correctly setup lspconfig for Rust 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
      servers = {
        rust_analyzer = {},
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      vim.list_extend(opts.adapters, {
        require("rustaceanvim.neotest"),
      })
    end,
  },
}
