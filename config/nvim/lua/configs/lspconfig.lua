local M = {}

M.config = function()
  -- load defaults i.e lua_lsp
  -- require("nvchad.configs.lspconfig").defaults()

  local lspconfig = require "lspconfig"

  local servers = {
    "bashls",
    "docker_compose_language_service",
    "dockerls",
    "dotls",
    "emmet_ls",
    "gdscript",
    "glsl_analyzer",
    "html",
    "jsonls",
    "solargraph",
    "sqlls",
  }
  local nvlsp = require "nvchad.configs.lspconfig"

  local on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    nvlsp.on_attach(client, bufnr)
  end
  local on_init = nvlsp.on_init
  local capabilities = nvlsp.capabilities

  -- lsps with default config
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
    }
  end

  lspconfig.cssls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    on_init = on_init,
    settings = {
      css = {
        lint = {
          unknownAtRules = "ignore",
        },
      },
    },
  })

  lspconfig.eslint.setup({
    capabilities = capabilities,
    on_init = on_init,
    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
      on_attach(client, bufnr)
    end,
    cmd = { 'eslint', '--stdin' },
  })

  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    on_init = on_init,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  })

  -- lspconfig.ruby_lsp.setup({
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   on_init = on_init,
  --   init_options = {
  --     formatter = 'standard',
  --     linters = { 'standard' },
  --     addonSettings = {
  --       ["Ruby LSP Rails"] = {
  --         enablePendingMigrationsPrompt = false,
  --       },
  --     },
  --   },
  -- })

  -- lspconfig.rust_analyzer.setup({
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   on_init = on_init,
  --   filetypes = {"rust"},
  --   root_dir = lspconfig.util.root_pattern("Cargo.toml"),
  --   settings = {
  --     ["rust-analyzer"] = {
  --       checkOnSave = {
  --         enable = true,
  --         command = 'check',
  --         extraArgs = {
  --           "--target-dir", "./.rust-analyzer",
  --         }
  --       }
  --     }
  --   },
  -- })

  lspconfig.ts_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    on_init = on_init,
    before_init = function(params)
      params.processId = vim.NIL
    end,
    on_new_config = function(new_config, new_root_dir)
      if new_root_dir:match("amplify/client$") then
        new_config.cmd = require("lspcontainers").command(
          'ts_ls',
          {
            root_dir = new_root_dir,
            docker_volume = "client_node_modules",
            cmd_builder = function(runtime, workdir, image, network, docker_volume)
              local mnt_volume = "--volume="..workdir..":"..workdir..":z"
              local node_volume = "--volume="..docker_volume..":"..workdir.."/node_modules:z"
              return {
                runtime,
                "container",
                "run",
                "--interactive",
                "--rm",
                "--network="..network,
                "--workdir="..workdir,
                mnt_volume,
                node_volume,
                image
              }
            end,
          }
        )
      end
    end,
  })
end

M.mappings = {
  -- { mode, mapping, effect, options },
  {
    "n",
    "<leader>f",
    function()
      vim.diagnostic.open_float { border = "rounded" }
    end,
    { desc = "floating diagnostic" },
  },
  {
    "n",
    "<leader>ls",
    function()
      vim.lsp.buf.signature_help()
    end,
    { desc = "LSP signature help" },
  },
  {
    "n",
    "<leader>D",
    function()
      vim.lsp.buf.type_definition()
    end,
    { desc = "LSP type definition" },
  },
  {
    "n",
    "<leader>ra",
    function()
      vim.lsp.buf.rename()
    end,
    { desc = "LSP rename" },
  },
  {
    "n",
    "<leader>ca",
    function()
      vim.lsp.buf.code_action()
    end,
    { desc = "LSP code action" },
  },
  {
    "n",
    "gD",
    function()
      vim.lsp.buf.declaration()
    end,
    { desc = "LSP declaration" },
  },
  {
    "n",
    "gd",
    function()
      vim.lsp.buf.definition()
    end,
    { desc = "LSP definition" },
  },
  {
    "n",
    "gi",
    function()
      vim.lsp.buf.implementation()
    end,
    { desc = "LSP implementation" },
  },
  {
    "n",
    "K",
    function()
      vim.lsp.buf.hover()
    end,
    { desc = "LSP hover" },
  },
}

return M
