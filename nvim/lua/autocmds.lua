-- Create group to assign commands
-- "clear = true" must be set to prevent loading autocmd repaetedly everytime a file is resourced

local autocmd_group = vim.api.nvim_create_augroup("Custom auto-commands", { clear = true})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go", "*.templ", "*.js", "*.jsx", "*.ts", "*.tsx" },
  desc = "Auto-format go files after saving",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end,
  group = autocmd_group,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("nvim-term", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

--vim.api.nvim_exec([[
--  autocmd BufWritePre *.sql silent! :SQLFmt
--  ]], false) 

--[[
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.sql" },
  desc = "Auto-format sql files after saving",
  callback = function()
    local filename = vim.api.nvim_buf_get_name(0)
    vim.cmd(":silent !SQLFmt "..filename)
  end,
  group = autocmd_group,
})
]]
