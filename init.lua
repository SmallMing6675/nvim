vim.loader.enable()

vim.g.mapleader = " "
vim.g.matchparen_timeout = 20
vim.g.matchparen_insert_timeout = 20
vim.g.python3_host_prog = vim.loop.os_homedir() .. "/.virtualenvs/neovim/bin/python3"

local map = vim.keymap.set

------------ Configuration for neovim itself -------------
local options = {
	expandtab = true,
	tabstop = 4,
	shiftwidth = 4,
	nu = true,
	relativenumber = true,
	numberwidth = 4,
	updatetime = 300,
	timeoutlen = 0,
	ignorecase = true,
	shadafile = "NONE",
	clipboard = "unnamedplus",
	fillchars = { eob = " " },
	showtabline = 0,
	wrap = false,
	laststatus = 3,
	shell = "/bin/bash",
	swapfile = false, -- disables swap file, remove this line if you don't want this
}

for o, v in pairs(options) do
	vim.opt[o] = v
end
---------- keymaps ----------
local keymaps = {
	{ ";", ":" },
	{ "<leader>/", "gcc", desc = "Comment line" },
	{ "<leader>n", ":ene <BAR> startinsert <CR>", desc = "New File" },
	{ "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" } },

	{ "<Leader>q", ":wq<CR>", desc = "Save Then Exit" },
	{ "<Leader>x", ":q<CR>", desc = "Exit" },
	{ "<leader>v", ":vsplit<CR>", desc = "Open Vertical Split" },
	{ "<leader>h", ":split<CR>", desc = "Open Horizontal Split" },
	{ "<leader>q", "<Cmd>wq<CR>", desc = "Close Buffer" },
	{ "<", v = { "<gv", desc = "Indent Line" } },
	{ ">", v = { ">gv", desc = "Indent Line" } },
	{ "<C-j>", "<Cmd>bp<CR>", desc = "Go to previous Buffer" },
	{ "<C-k>", "<Cmd>bn<CR>", desc = "Go to Next Buffer" },
	{ "<leader>C", "ggVG<cr>", desc = "Select all text" },

	{ "=", "<cmd>horizontal resize +10<cr>", desc = "Resize Window Up" },
	{ "-", "<cmd>horizontal resize -10<cr>", desc = "Resize Window Down" },
	{ "+", "<cmd>vertical resize +10<cr>", desc = "Resize Window Left" },
	{ "_", "<cmd>vertical resize -10<cr>", desc = "Resize Window Right" },

	{ "<A-h>", "<C-w>h", desc = "Window Left" },
	{ "<A-j>", "<C-w>j", desc = "Window Down" },
	{ "<A-k>", "<C-w>k", desc = "Window Up" },
	{ "<A-l>", "<C-w>l", desc = "Window Right" },

	{ "<C-l>", "<cmd>tabnext<CR>", desc = "Tab: Next" },
	{ "<C-h>", "<cmd>tabprevious<CR>", desc = "Tab: Previous " },
	{ "<tab>n", "<cmd>tabnew<CR>", desc = "Tab: New" },
	{ "<tab>j", "<cmd>tabnext<CR>", desc = "Tab: Next" },
	{ "<tab>k", "<cmd>tabprevious<CR>", desc = "Tab: Previous " },
	{ "<tab>x", "<cmd>tabclose<CR>", desc = "Tab: Close " },
	{ "J", "<C-d>" },
	{ "K", "<C-u>" },
}
---------- autocmds ---------0
local autocmds = {
	{
		"BufWritePre",
		function()
			vim.cmd.Neoformat()
		end,
		desc = "Format On Save",
	},

	{
		"VimEnter",
		function()
			if vim.fn.argv(0) == "" then
				require("telescope.builtin").find_files()
			end
		end,
		desc = "Open Telescope on Vim Enter",
	},
	{
		"UIEnter",
		function()
			vim.cmd("hi LineNr guifg=#404749")
			vim.cmd("hi VertSplit guifg=#232A2D")
			vim.cmd("hi TelescopeSelection guifg=#8ccf7e guibg=bg")
			vim.cmd("hi FlashLabel guifg=fg")
			vim.cmd("silent TSUpdate")
		end,
	},
	{
		"TextYankPost",
		function()
			vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
		end,
	},
	{
		"LspAttach",
		name = vim.api.nvim_create_augroup("UserLspConfig", {}),
		function(_)
			map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP: Rename" })
			map("n", "<leader>lm", vim.lsp.buf.format, { desc = "LSP: Format" })
			map("n", "<leader>lc", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
			map("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "LSP: Type Definition" })
			map("n", "<leader>lf", vim.lsp.buf.references, { desc = "LSP: Find References" })
			map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
			map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
		end,
	},
}

---------- plugins ----------

local plugins = {
	{
		"mrjones2014/legendary.nvim",
		event = "VimEnter",
		version = "v2.1.0",
		priority = 10000,
		opts = {
			keymaps = keymaps,
			autocmds = autocmds,
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "UIEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local everblush = require("lualine.themes.everblush")
 	        -- stylua: ignore
	        local files = { {"filename", symbols = {modified = "󱇧", readonly = "",unnamed = "󰲶", newfile = ""} } }
			require("lualine").setup({
				sections = {
					lualine_b = files,
					lualine_c = { "diagnostics" },
					lualine_x = { "filetype" },
					lualine_y = { "diff" },
					lualine_z = { "tabs" },
				},
				options = {
					theme = everblush,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				extensions = { "fzf", "lazy", "neo-tree" },
			})
		end,
	},
	"nathom/filetype.nvim",
	{
		"lewis6991/gitsigns.nvim",
		event = "BufEnter",
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "󰍵" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "│" },
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		cmd = "TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
				indent = { enable = true },
				ensure_installed = { "rust", "python", "c", "lua", "vim", "vimdoc", "query" },
				auto_install = true,
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
		},
		keys = {
			{ "<a-u>", "<cmd>Telescope undo<cr>", desc = "Undo History" },
			{ "<a-f>", "<Cmd>Telescope find_files<CR>", desc = "Find Files" },
			{ "<a-r>", "<Cmd>Telescope oldfiles<CR>", desc = "Find Recent Files" },
			{ "<a-g>", "<Cmd>Telescope live_grep<CR>", desc = "Find Grep" },

			{ "<leader>ff", "<cmd> Telescope find_files <CR>", desc = "Find files" },
			{ "<leader>fw", "<cmd> Telescope live_grep <CR>", desc = "Live grep" },
			{ "<leader>fb", "<cmd> Telescope buffers <CR>", desc = "Find buffers" },
			{ "<leader>fh", "<cmd> Telescope help_tags <CR>", desc = "Help page" },
			{ "<leader>fo", "<cmd> Telescope oldfiles <CR>", desc = "Find oldfiles" },
			{ "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <CR>", desc = "Find in current buffer" },
			{ "<leader>fc", "<cmd> Telescope git_commits <CR>", desc = "Git commits" },
			{ "<leader>fs", "<cmd> Telescope git_status <CR>", desc = "Git status" },
		},
		cmd = "Telescope",
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				pickers = { find_files = { follow = true } },
				defaults = { border = true },
				extensions = { file_browser = { hijack_netrw = true } },
			})
			require("telescope").load_extension("undo")
		end,
	},
	{
		"sbdchd/neoformat",
		event = "BufWritePre",
		config = function()
			vim.g.neoformat_c_clangformat = { exe = "clang-format", args = { "--style=Webkit" } }
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		dependencies = {
			"williamboman/mason-lspconfig",
			"williamboman/mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
            -- stylua: ignore
			require("mason-tool-installer").setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "pyright", "stylua", "blackd-client", "autopep8", "prettier", "clang-format" },
			})
			require("mason").setup()
			require("mason-lspconfig").setup()
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
		keys = { { "<leader>p", "<cmd>Outline<CR>", desc = "Toggle outline" } },
		config = function()
			require("outline").setup({
                -- stylua: ignore
                symbols = { icons = { File = { icon = "󰈙", hl = "Identifier" }, Module = { icon = "󰆧", hl = "Include" }, Namespace = { icon = "󰅪", hl = "Include" }, Package = { icon = "󰏗", hl = "Include" }, Class = { icon = "󰠱", hl = "Type" }, Method = { icon = "󰊕", hl = "Function" }, Property = { icon = "󰜢", hl = "Identifier" }, Field = { icon = "󰇽", hl = "Identifier" }, Constructor = { icon = "", hl = "Special" }, Enum = { icon = "", hl = "Type" }, Interface = { icon = "", hl = "Type" }, Function = { icon = "󰊕", hl = "Function" }, Variable = { icon = "", hl = "Constant" }, Constant = { icon = "", hl = "Constant" }, String = { icon = "", hl = "String" }, Number = { icon = "#", hl = "Number" }, Boolean = { icon = "⊨", hl = "Boolean" }, Array = { icon = "󰅪", hl = "Constant" }, Object = { icon = "⦿", hl = "Type" }, Key = { icon = "", hl = "Type" }, Null = { icon = "󰟢", hl = "Type" }, EnumMember = { icon = "", hl = "Identifier" }, Struct = { icon = "", hl = "Structure" }, Event = { icon = "", hl = "Type" }, Operator = { icon = "+", hl = "Identifier" }, TypeParameter = { icon = "󰅲", hl = "Identifier" }, Component = { icon = "󰅴", hl = "Function" }, Fragment = { icon = "󰅴", hl = "Constant" }, TypeAlias = { icon = "", hl = "Type" }, Parameter = { icon = "", hl = "Identifier" }, StaticMethod = { icon = "", hl = "Function" }, Macro = { icon = "", hl = "Function" } } },
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
		},

		config = function()
			local cmp = require("cmp")
            --stylua: ignore
            local kind_icons = { Text = "", Method = "󰆧", Function = "󰊕", Constructor = "", Field = "󰇽", Variable = "", Class = "󰠱", Interface = "", Module = "", Property = "󰜢", Unit = "", Value = "", Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘", File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "", Constant = "", Struct = "", Event = "", Operator = "󰆕", TypeParameter = "󰅲", Codeium = "" }
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				formatting = {
					format = function(_, vim_item)
						vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
						return vim_item
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = {

					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "buffer", max_item_count = 5 },
				},
				window = {
					completion = { border = "shadow" },
					documentation = { border = "shadow" },
				},
			})

			cmp.setup.cmdline(
				{ "/", "?" },
				{ mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } }
			)
			cmp.setup.cmdline(
				":",
				{ mapping = cmp.mapping.preset.cmdline(), sources = cmp.config.sources({ { name = "cmdline" } }) }
			)
		end,
	},
	{
		"folke/noice.nvim",
		event = "UIEnter",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		opts = { presets = { command_palette = true, lsp_doc_border = false, long_message_to_split = true } },
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = { window = { position = "right", width = 30 } },
		keys = { { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle File Tree" } },
	},
	{
		"echasnovski/mini.nvim",
		event = "UIEnter",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.pairs").setup()
			require("mini.comment").setup()
			require("mini.animate").setup()
		end,
	},
	{
		"toppair/reach.nvim",
		config = function()
			require("reach").setup({ notifications = true })
		end,
		keys = { { "`", "<cmd>ReachOpen buffers<CR>", desc = "Open Reach" } },
	},
	{
		"Everblush/nvim",
		lazy = false,
		name = "everblush",
		config = function()
			vim.cmd.colorscheme("everblush")
		end,
	},

	{
		"folke/which-key.nvim",
		keys = { "<leader>", "c", "v", "g", "<tab>" },
		config = function()
			local which_key = require("which-key")
			which_key.setup({
				window = { border = "shadow", position = "bottom" },
				layout = { align = "center" },
			})
			which_key.register({
				["<leader>l"] = { name = "+LSP" },
				["<leader>f"] = { name = "+Telescope" },
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "UIEnter",
		main = "ibl",
		opts = { scope = { enabled = false }, indent = { highlight = "LineNr" } },
	},
	{
		"folke/flash.nvim",
		opts = {},
        -- stylua: ignore
        keys = {
            { "s",     mode = {"n", "x", "o" }, function() require("flash").jump() end,desc = "Flash" },
            { "S",     mode = {"n", "x", "o" }, function() require("flash").treesitter() end,desc = "Flash Treesitter" },
            { "r",     mode = "o",          function() require("flash").remote() end,desc = "Remote Flash" },
            { "<a-s>", mode = {"n", "o", "x" }, function() require("flash").treesitter_search() end,desc = "Treesitter Search" },
            { "<a-c>", mode = { "n" },      function() require("flash").jump({ pattern = vim.fn.expand("<cword>") }) end, desc = "Flash Current Word" },
        },
	},
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
--stylua: ignore
require("lazy").setup({
    spec = plugins,
    defaults = { lazy = true, version = false, config = true, event = "VeryLazy" },
    performance = {
        cache = { enabled = true },
        rtp = { disabled_plugins = { "2html_plugin", "bugreport", "compiler", "ftplugin", "getscript", "getscriptPlugin", "gzip", "logipat", "matchit", "netrw", "netrwFileHandlers", "netrwPlugin", "netrwSettings", "optwin", "rplugin", "rrhelper", "spellfile_plugin", "synmenu", "syntax", "tar", "tarPlugin", "tohtml", "tutor", "vimball", "vimballPlugin", "zip", "zipPlugin", "editorconfig", "man", "health", "matchparen", "spellfile", "shada", }, },
    },
})
