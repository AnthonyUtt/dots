return {
  -- {
  --   "epwalsh/obsidian.nvim",
  --   version = "*",
  --   lazy = true,
  --   event = {
  --     -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --     -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --     -- refer to `:h file-pattern` for more examples
  --     "BufReadPre " .. vim.fn.expand "~" .. "/source/notes/*.md",
  --     "BufNewFile " .. vim.fn.expand "~" .. "/source/notes/*.md",
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "epwalsh/pomo.nvim",
  --   },
  --   opts = require "configs.obsidian",
  -- },
  {
    "epwalsh/pomo.nvim",
    version = "*",
    lazy = true,
    cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
    dependencies = {
      "rcarriga/nvim-notify",
    },
    opts = {
      notifiers = {
        {
          name = "Default",
          opts = {
            sticky = false,
            title_icon = "⏳",
            text_icon = "⏱️",
          },
        },
        { name = "System" },
      },
      sessions = {
        work = {
          { name = "Work", duration = "25m" },
          { name = "Short Break", duration = "5m" },
          { name = "Work", duration = "25m" },
          { name = "Short Break", duration = "5m" },
          { name = "Work", duration = "25m" },
          { name = "Long Break", duration = "15m" },
        },
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "MCPHub" },
    lazy = false,
    opts = require "configs.mcphub",
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = require "configs.avante",
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for copilot provider
      "ravitemer/mcphub.nvim",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
      },
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "GeorgesAlkhouri/nvim-aider",
    cmd = "Aider",
    dependencies = {
      "folke/snacks.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    opts = require "configs.aider".opts,
    keys = require "configs.aider".keys,
  },
  "AnthonyUtt/lspcontainers.nvim",
  "ethanholz/nvim-lastplace",
  "onsails/lspkind.nvim",
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   opts = require "configs.copilot",
  -- },
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    opts = {
      font = "ComicShannsMono Nerd Font=34",
      to_clipboard = true,
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = require("configs.flash").opts,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lspconfig").config()
    end,
  },
  { "williamboman/mason.nvim", enable = false },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                targetDir = "./.rust-analyzer"
              }
            }
          }
        }
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      return require "configs.cmp"
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      return require "configs.nvimtree".opts
    end,
    init = function()
      require("configs.nvimtree").init()
    end,
  },
  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "css",
        "csv",
        "diff",
        "dockerfile",
        "dot",
        "gdscript",
        "gdshader",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "glsl",
        "graphql",
        "hlsl",
        "html",
        "javascript",
        "jinja",
        "json",
        "kdl",
        "liquid",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "ruby",
        "rust",
        "scss",
        "sql",
        "toml",
        "tsv",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
  		},
  	},
  },
  {
    -- Other
    {
      "Glench/Vim-Jinja2-Syntax",
      init = function()
        vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
          pattern = { "*.tera", "*.njk" },
          command = "set ft=jinja",
        })
      end,
    },
    {
      "tpope/vim-rails",
      config = function()
        -- disable autocmd set filetype=eruby.yaml
        vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
          pattern = { "*.yml" },
          callback = function()
            vim.bo.filetype = "yaml"
          end,
        })
      end,
    },
  },
}
