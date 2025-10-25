require('core.keybinds')
require('core.settings')
require('core.lazy')

-- make statusline transparent
vim.cmd(':hi statusline guibg=NONE')
-- vim.cmd.colorscheme 'yugen'
vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "None" })

