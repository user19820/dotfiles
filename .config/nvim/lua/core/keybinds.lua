local opts = { noremap = true, silent = true }
local map = vim.keymap.set

vim.g.mapleader = " "

map('n','<leader>pv', '<cmd>Ex<CR>', opts)
map('n','<C-u>', 'zz<C-u>', opts)
map('n','<C-d>', 'zz<C-d>', opts)
map('n','<leader>w', ':write<CR>')
map('n','<leader>q', ':quit<CR>')
map('n','<leader>e', ':lua vim.diagnostic.open_float(0, { scope = "line" })<CR>', opts)

map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
