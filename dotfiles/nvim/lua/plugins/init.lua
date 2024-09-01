return {{
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
        require "configs.conform"
    end
},
{
    "codethread/qmk.nvim",
    ft = { "devicetree" },
    config = function()
        require('qmk').setup({
            name = 'Sweep',
            layout = {
              'x x x x x _ x x x x x',
              'x x x x x _ x x x x x',
              'x x x x x _ x x x x x',
              '_ _ _ x x _ x x _ _ _'
            },
            variant = 'zmk'
        })
    end
}

 -- These are some examples, uncomment them if you want to see them work!
-- {
--   "neovim/nvim-lspconfig",
--   config = function()
--     require("nvchad.configs.lspconfig").defaults()
--     require "configs.lspconfig"
--   end,
-- },
--
-- {
-- 	"williamboman/mason.nvim",
-- 	opts = {
-- 		ensure_installed = {
-- 			"lua-language-server", "stylua",
-- 			"html-lsp", "css-lsp" , "prettier"
-- 		},
-- 	},
-- },
--
-- {
-- 	"nvim-treesitter/nvim-treesitter",
-- 	opts = {
-- 		ensure_installed = {
-- 			"vim", "lua", "vimdoc",
--      "html", "css"
-- 		},
-- 	},
-- },
}
