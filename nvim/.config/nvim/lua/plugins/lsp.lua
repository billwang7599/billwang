-- Define the servers you want Mason to install and LSP to configure
local servers = {
  -- --- System & Backend ---
  gopls = {
    settings = {
      gopls = {
        analyses = { unusedparams = true, shadow = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
  clangd = {
    cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = { command = "clippy" },
        procMacro = { enable = true },
      },
    },
  },
  ruby_lsp = {}, -- The modern standard for Ruby (Shopify)

  -- --- Scripting & Data ---
  pyright = {}, -- Standard for Python; use 'basedpyright' if you want stricter types
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
      },
    },
  },

  -- --- Web Development ---
  ts_ls = {}, -- The renamed 'tsserver'
  html = {},
  cssls = {},
  tailwindcss = {},
  jsonls = {},

  -- --- Infrastructure & Tools ---
  terraformls = {},
  dockerls = {},
  bashls = {},
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        },
      },
    },
  },
}

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "Saghen/blink.cmp", -- This is the key dependency for blink
  },
  config = function()
    require("mason").setup()

    local lspconfig = require("lspconfig")

    -- Syncing Blink capabilities
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Use LspAttach autocmd instead of on_attach callback
    -- This is more reliable and works even if servers are configured elsewhere
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local bufopts = { noremap = true, silent = true, buffer = ev.buf }
        -- LSP keymaps
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format { async = true } end, bufopts)
      end,
    })

    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
      handlers = {
        function(server_name)
          local server_config = servers[server_name] or {}
          server_config.capabilities = capabilities
          lspconfig[server_name].setup(server_config)
        end,
      },
    })
  end,
}