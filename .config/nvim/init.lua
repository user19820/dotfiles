--[[
-- My config
--]]


-- locals to reduce boilerplate
local opt = vim.opt
local map = vim.keymap.set
local pack = vim.pack
local lsp = vim.lsp.buf
local api = vim.api
local cmd = vim.cmd
local bindopts = { noremap = true, silent = true }

-- neovim settings
opt.swapfile = false
opt.number = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.smartindent = true
opt.scrolloff = 20
opt.wrap = false
opt.helpheight = 999
opt.clipboard = "unnamedplus"

vim.g.mapleader = " "

-- general keybinds

map("n", "<leader>pv", ":Ex<CR>", bindopts)
map("n", "<C-u>", "<C-u>zz", bindopts)
map("n", "<C-d>", "<C-d>zz", bindopts)
-- show warnings/errors
map("n", "<leader>e", ":lua vim.diagnostic.open_float(0, { scope = 'line' })<CR>")
map("n", "<leader>ca", lsp.code_action, bindopts)
map("n", "<leader>rn", lsp.rename, bindopts)
map("n", "K", lsp.hover, bindopts)

-- This is a hack to enable me to use plugins which would require a "build"
-- step, like telescope-fzf-native.
-- More info about this here: 
-- https://github.com/neovim/neovim/pull/35360#issuecomment-3212327279
local augroup = api.nvim_create_augroup("build_system", { clear = false })
api.nvim_create_autocmd("PackChanged", {
	group = augroup,
	pattern = "*",
	callback = function (e)
		local p = e.data
		local run_task = (p.spec.data or {}).run
		if p.kind ~= "delete" and type(run_task) == "function" then
			pcall(run_task, p)
		end
	end
})

-- ADD NEW PLUGINS HERE
pack.add(
	{
		"https://github.com/bettervim/yugen.nvim",
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/mason-org/mason.nvim",
		"https://github.com/neovim/nvim-lspconfig",
		"https://github.com/tpope/vim-vinegar",
		{
			src = "https://github.com/nvim-treesitter/nvim-treesitter",
			version = "master",
		},
		{
			src = "https://github.com/nvim-telescope/telescope.nvim",
			version =  "v0.2.0",
		},
		{
			src = "https://github.com/ThePrimeagen/harpoon",
			version = "harpoon2",
		},
		{
			src = "https://github.com/saghen/blink.cmp",
			version = vim.version.range("^1"),
		},
		"https://github.com/nvim-telescope/telescope-ui-select.nvim",
		{
			src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
			data = {
				run = function (p)
					vim.system("bash", {stdin = "which make && cd" .. p.spec.path .. "&& make"})
				end
			},
		}
	}
)

-- lsp config

-- lua
vim.lsp.config["luals"] = {
  -- Command and arguments to start the server.
  cmd = { "lua-language-server" },
  -- Filetypes to automatically attach to.
  filetypes = { "lua" },
  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains either a ".luarc.json" or a
  -- ".luarc.jsonc" file. Files that share a root directory will reuse
  -- the connection to the same LSP server.
  root_markers = { ".luarc.json", ".luarc.jsonc" },
  -- Specific settings to send to the server. The schema for this is
  -- defined by the server. For example the schema for lua-language-server
  -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      }
    }
  }
}

-- rust (Uncomment when you need to configure rust-analyzer)
--
-- vim.lsp.config["rust-analyzer"] = {}

-- go

-- This autocmd runs gofmt on save
api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function ()
		pcall(function ()
			lsp.code_action({
				context = {
					only = {
						"source.organizeImports",
					},
					diagnostics = {},
				},
				apply = true,
			})

			lsp.format()
		end)
	end
})

-- c
vim.lsp.config["clang"] = {}

vim.lsp.enable({
	"gopls",
	"lua_ls",
	"rust_analyzer",
	"clangd",
})


-- plugin startup and configuration

-- mason

require("mason").setup({})

-- harpoon

local harpoon = require "harpoon"
harpoon:setup()

map("n", "<leader>a",function() harpoon:list():add() end, bindopts)
map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, bindopts)
map("n", "<C-h>", function() harpoon:list():select(1) end, bindopts)
map("n", "<C-j>", function() harpoon:list():select(2) end, bindopts)
map("n", "<C-k>", function() harpoon:list():select(3) end, bindopts)
map("n", "<C-l>", function() harpoon:list():select(4) end, bindopts)

-- telescope
require("telescope").setup({
	-- this part configures ui-select, which allows
	-- telescope to be used as the selection menu UI by
	-- other parts of neovim, like lsp code actions
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown()
		}
	}
})

local builtin = require "telescope.builtin"
map("n", "<leader>fh", builtin.help_tags, bindopts)
map("n", "<leader>sf", builtin.find_files, bindopts)
map("n", "<leader>sg", builtin.live_grep, bindopts)
map("n", "<leader><leader>", builtin.help_tags, bindopts)
map("n", "<leader>fd", builtin.diagnostics, bindopts)

map("n", "gr", builtin.lsp_references, bindopts)
map("n", "gd", builtin.lsp_definitions, bindopts)
map("n", "gI", builtin.lsp_implementations, bindopts)
map("n", "<leader>E", builtin.diagnostics, bindopts)
map("n", "<leader>/",function ()
	builtin.current_buffer_fuzzy_find(
		require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		})
	)
end , bindopts)

-- telescope requires you to load extensions after
-- you call it's setup function
require("telescope").load_extension("ui-select")

-- treesitter

require "nvim-treesitter.configs".setup({
	ensure_installed = { "c" },
	auto_install = true,
	highlight = {
		enable = true,
	},
})

-- blink

require "blink.cmp".setup({
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
	keymap = {
		preset = "default",
		["<C-space>"] =  {},
		["<Tab>"] =  {},
		["<S-Tab>"] =  {},
		["<C-e>"] =  {},
		["<CR>"] =  { "accept", "fallback" },
		["<C-p>"] =  { "select_prev", "fallback" },
		["<C-n>"] =  { "select_next", "fallback" },
		["<C-b>"] =  { "scroll_documentation_down", "fallback" },
		["<C-f>"] =  { "scroll_documentation_up", "fallback" },
	},
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "normal",
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},
	cmdline = {
		keymap = {
			preset = "inherit",
		["<CR>"] = { "accept_and_enter", "fallback" },
		},
	},
	sources = { default = { "lsp" }, },
})

-- statusline

local get_branch = function()
	local gitB = io.popen("git branch --show-current")

	if gitB == nil then
		error("statusline: show git branch: returned null")
	end

	local branch = gitB:read("*all")
	gitB:close()
	branch = branch:gsub("%s+$", "")

	return branch
end

local statusline = {
	"%<%f %= ",
	get_branch(),
	" ",
}

vim.o.statusline = table.concat(statusline)

-- visual settings and themecmd(":hi statusline guibg=NONE")
opt.guicursor = "i:block"
opt.winborder = "rounded"
opt.termguicolors = true
cmd.colorscheme "yugen"

local function set_transparent_bg()
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
end

set_transparent_bg()
