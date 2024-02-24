------------------------------------------------------
-- My Simple Neovim configuration (Mostly stolen)   --
-- designed as a starting point for your own config --
-- Feel free the copy and modify the config!        --
------------------------------------------------------

vim.loader.enable()
------------ Configuration for neovim itself -------------
vim.g.mapleader = " "
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.cursorline = true
vim.opt.lazyredraw = false
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.o.wrap = false
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 0
vim.o.fillchars = "eob: "

vim.cmd("au TextYankPost * silent! lua vim.highlight.on_yank()")
---------- keymaps ----------
local map = vim.keymap.set

for i = 1, 9 do
    --stylua: ignore
	vim.api.nvim_set_keymap("n", "<A-" .. i .. ">", "<Cmd>LualineBuffersJump! " .. i .. "<CR>", { noremap = true, silent = true, desc = "Go to Buffer " .. i })
end
--stylua: ignore
vim.api.nvim_set_keymap("n", "<A-0>", "<Cmd>LualineBuffersJump! $<CR>", { noremap = true, silent = true, desc = "Go to Last Buffer" })

map("n", "<leader>n", ":ene <BAR> startinsert <CR>", { desc = "New File" })
map("n", "<leader>t", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle Term" })
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

map("n", "<leader>ff", "<Cmd>Telescope find_files<CR>", { desc = "Find: Files" })
map("n", "<leader>fg", "<Cmd>Telescope live_grep<CR>", { desc = "Find: Grep" })
map("n", "<leader>fc", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Find: Grep Within Current Buffer" })
map("n", "<leader>fb", "<Cmd>Telescope buffers<CR>", { desc = "Find: Buffers" })
map("n", "<leader>fr", "<Cmd>Telescope oldfiles<CR>", { desc = "Find: Recent Files" })
map("n", "<leader>fm", "<Cmd>Telescope man_pages<CR>", { desc = "Find: Man Pages" })

map("n", "<Leader>q", ":wq<CR>", { desc = "Save Then Exit" })
map("n", "<Leader>x", ":q<CR>", { desc = "Exit" })
map("n", "H", "_", { desc = "Start of the line" })
map("n", "L", "$", { desc = "End of the line" })
map("n", "<leader>v", ":vsplit<CR>", { desc = "Open Vertical Split" })
map("n", "<leader>h", ":split<CR>", { desc = "Open Horizontal Split" })
map("n", "<leader>q", "<Cmd>wq<CR><CR>", { desc = "Close Buffer" })
map("v", "<", "<gv", { desc = "Indent Line" })
map("v", ">", ">gv", { desc = "Indent Line" })
map("n", "<C-j>", "<Cmd>bp<CR>", { desc = "Go to previous Buffer" })
map("n", "<C-k>", "<Cmd>bn<CR>", { desc = "Go to Next Buffer" })

map("n", "<leader>C", "ggVG<cr>", { desc = "Select all text" })

map("n", "=", "<cmd>horizontal resize +5<cr>", { desc = "Resize Window Up" })
map("n", "-", "<cmd>horizontal resize -5<cr>", { desc = "Resize Window Down" })
map("n", "+", "<cmd>vertical resize +5<cr>", { desc = "Resize Window Left" })
map("n", "_", "<cmd>vertical resize -5<cr>", { desc = "Resize Window Right" })

map("n", "<A-h>", "<C-w>h", { desc = "Window Left" })
map("n", "<A-j>", "<C-w>j", { desc = "Window Down" })
map("n", "<A-k>", "<C-w>k", { desc = "Window Up" })
map("n", "<A-l>", "<C-w>l", { desc = "Window Right" })

map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP: Rename" })
map("n", "<leader>lm", vim.lsp.buf.format, { desc = "LSP: Format" })
map("n", "<leader>lc", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
map("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "LSP: Type Definition" })
map("n", "<leader>lf", vim.lsp.buf.references, { desc = "LSP: Find References" })

map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "gl", vim.diagnostic.open_float, { desc = "Open Float" })

map("n", "<C-S-k>", "<cmd>tabnext<CR>", { desc = "Tab: Next" })
map("n", "<C-S-j>", "<cmd>tabprevious<CR>", { desc = "Tab: Previous " })
map("n", "<leader><tab>n", "<cmd>tabnew<CR>", { desc = "Tab: New" })
map("n", "<leader><tab>j", "<cmd>tabnext<CR>", { desc = "Tab: Next" })
map("n", "<leader><tab>k", "<cmd>tabprevious<CR>", { desc = "Tab: Previous " })
map("n", "<leader><tab>x", "<cmd>tabclose<CR>", { desc = "Tab: Close " })

map("n", "J", "<C-d>")
map("n", "K", "<C-u>")

---------- plugins ----------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local plugins = {
	{
		"nvim-neo-tree/neo-tree.nvim",
		keys = { { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle File Tree" } },
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = { "rust", "python", "c", "lua", "vim", "vimdoc", "query" },
			auto_install = true,
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
		cmd = "Telescope",
		config = function()
			require("telescope").setup({
				defaults = { border = false },
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown({}) },
					file_browser = { hijack_netrw = true },
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"sbdchd/neoformat",
		event = "BufWritePre",
		config = function()
			vim.cmd([[augroup fmt autocmd! 
                      autocmd BufWritePre * undojoin | Neoformat
                      augroup END]])
			vim.g.neoformat_c_clangformat = { exe = "clang-format", args = { "--style=Webkit" } }
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = { "williamboman/mason-lspconfig", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "clangd" },
			})
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
			})
		end,
	},
	{
		"hedyhli/outline.nvim",
		cmd = { "Outline", "OutlineOpen" },
		keys = { { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" } },
		config = function()
			require("outline").setup({
            -- stylua: ignore
            symbols = {icons = {File = {icon = "󰈙",hl = "Identifier"},Module = {icon = "󰆧",hl = "Include"},Namespace = {icon = "󰅪",hl = "Include"},Package = {icon = "󰏗",hl = "Include"},Class = {icon = "󰠱",hl = "Type"},Method = {icon = "󰊕",hl = "Function"},Property = {icon = "󰜢",hl = "Identifier"},Field = {icon = "󰇽",hl = "Identifier"},Constructor = {icon = "",hl = "Special"},Enum = {icon = "",hl = "Type"},Interface = {icon = "",hl = "Type"},Function = {icon = "󰊕",hl = "Function"},Variable = {icon = "",hl = "Constant"},Constant = {icon = "",hl = "Constant"},String = {icon = "",hl = "String"},Number = {icon = "#",hl = "Number"},Boolean = {icon = "⊨",hl = "Boolean"},Array = {icon = "󰅪",hl = "Constant"},Object = {icon = "⦿",hl = "Type"},Key = {icon = "",hl = "Type"},Null = {icon = "󰟢",hl = "Type"},EnumMember = {icon = "",hl = "Identifier"},Struct = {icon = "",hl = "Structure"},Event = {icon = "",hl = "Type"},Operator = {icon = "+",hl = "Identifier"},TypeParameter = {icon = "󰅲",hl = "Identifier"},Component = {icon = "󰅴",hl = "Function"},Fragment = {icon = "󰅴",hl = "Constant"},TypeAlias = {icon = "",hl = "Type"},Parameter = {icon = "",hl = "Identifier"},StaticMethod = {icon = "",hl = "Function"},Macro = {icon = "",hl = "Function"}}},
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")
            -- stylua: ignore
            local kind_icons = { Text = "", Method = "󰆧", Function = "󰊕", Constructor = "", Field = "󰇽", Variable = "", Class = "󰠱", Interface = "", Module = "", Property = "󰜢", Unit = "", Value = "", Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘", File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "", Constant = "", Struct = "", Event = "", Operator = "󰆕", TypeParameter = "󰅲", Codeium = "" }
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				formatting = {
					format = function(_, vim_item)
						vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
						return vim_item
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = {
					{ name = "nvim_lsp", max_item_count = 5 },
					{ name = "buffer", max_item_count = 5 },
					{ name = "luasnip", max_item_count = 3 },
				},
				window = {
					completion = cmp.config.window.bordered({ border = "none" }),
					documentation = cmp.config.window.bordered({ border = "none" }),
				},
			})
			cmp.setup.filetype(
				"gitcommit",
				{ sources = cmp.config.sources({ { name = "git" } }, { { name = "buffer" } }) }
			)
			cmp.setup.cmdline(
				{ "/", "?" },
				{ mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } }
			)
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({ { name = "cmdline" } }),
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "BufEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
            -- stylua: ignore
            local files = { {"filename", symbols = {modified = "󱇧", readonly = "",unnamed = "󰲶", newfile = ""} },
            }
			require("lualine").setup({
				sections = { lualine_c = files, lualine_x = { "filetype" } },
				options = { theme = "tokyonight", section_separators = { left = "", right = "" } },
				tabline = { lualine_a = { "buffers" }, lualine_y = files, lualine_z = { "tabs" } },
				extensions = { "fzf", "lazy", "neo-tree", "fzf", "toggleterm" },
			})
		end,
	},
	{
		"folke/which-key.nvim",
		keys = { "<leader>", "<c-r>", '"', "'", "`", "c", "v", "g" },
		opts = {
			defaults = {
				mode = { "n", "v" },
				["<leader><tab>"] = { name = "+tabs" },
				["<leader>f"] = { name = "+file/find" },
				["<leader>l"] = { name = "+LSP" },
			},
			layout = { align = "center" },
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register(opts.defaults)
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = "ToggleTerm",
		opts = { shell = "fish", size = 25 },
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		config = function()
            --stylua: ignore
			require("noice").setup({
				presets = { command_palette = true, long_message_to_split = true, inc_rename = false, lsp_doc_border = false},
			})
		end,
	},
	{
		"folke/flash.nvim",
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
            { "<a-s>", mode = {"n"}, function() require("flash").jump({pattern = vim.fn.expand("<cword>"), }) end, desc = "Flash Current Word"},
        },
	},
	{ "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}, event = "BufEnter" },
    -- stylua: ignore
    {
        {"echasnovski/mini.pairs", event = "InsertEnter", version = false, config = function() require("mini.pairs").setup() end},
        {"echasnovski/mini.animate", event = "BufEnter", version = false, config = function() require("mini.animate").setup() end},
        {"echasnovski/mini.ai", event = "InsertEnter", version = false, config = function() require("mini.ai").setup() end},
        {"echasnovski/mini.comment", event = "InsertEnter", version = false, config = function() require("mini.comment").setup() end},
    },
}
require("lazy").setup({ plugins })
vim.cmd("silent TSUpdate")

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argv(0) == "" then
			require("telescope.builtin").find_files()
		end
	end,
})