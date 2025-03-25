-- Custom Remaps

vim.keymap.set('v', '<leader>yy', '"+y') -- yank to clipboard
vim.keymap.set('n', '<leader>ys', '0y$') -- yank to eol
vim.keymap.set('n', '<leader>a', 'ggVG') -- select all
vim.keymap.set('n', '<leader>ii', 'gg=G') -- reindent all
vim.keymap.set('n', '<leader>fm', ':Format<CR') -- format current buffer using current LSP)
-- vim.keymap.set('v', 'zf', ':set foldmethod=syntax') -- quick fold {}
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle <CR>') -- Toggle nvim tree open or close
vim.keymap.set('n', '<leader>hs', '<C-w>s<CR>') -- horizontal split
vim.keymap.set('n', '<leader>vs', '<C-w>v<CR>') -- vertical split
vim.keymap.set('n', '<leader><Tab>', '<C-^>') -- hop to previous file buffer
vim.keymap.set('n', 'gs', function() -- hop to previous file buffer 
    vim.cmd('vsplit')
    vim.lsp.buf.definition()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>to', function() -- open small terminal at bottom
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 5)
end)
-- vim.keymap.set('n', '<Esc><Esc>', '<C-\\><C-n>')
