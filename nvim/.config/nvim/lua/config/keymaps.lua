-- Phím tắt không phụ thuộc plugin. Phím của plugin nằm trong plugins.lua.
local map = vim.keymap.set

map("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Bỏ highlight tìm kiếm" })
map("n", "<C-t>", "<Cmd>tabnew<CR>", { desc = "Tab mới" })

-- Window
map("n", "<leader>wv", "<Cmd>vsplit<CR>", { desc = "Chia dọc" })
map("n", "<leader>wh", "<Cmd>split<CR>", { desc = "Chia ngang" })
map("n", "<leader>wc", "<Cmd>close<CR>", { desc = "Đóng cửa sổ" })

-- Buffer
map("n", "<leader>l", "<Cmd>bnext<CR>", { desc = "Buffer sau" })
map("n", "<leader>h", "<Cmd>bprevious<CR>", { desc = "Buffer trước" })
map("n", "<leader>bd", "<Cmd>bprevious | bdelete #<CR>", { desc = "Đóng buffer" })

-- Cheatsheet: mở cheatsheet.md trong cửa sổ nổi, q / Esc để đóng
map("n", "<leader>?", function()
  local path = vim.fn.stdpath("config") .. "/cheatsheet.md"
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(path))
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  local w = math.min(90, vim.o.columns - 4)
  local h = math.floor(vim.o.lines * 0.85)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor", style = "minimal", border = "rounded", title = " Cheatsheet ",
    width = w, height = h, col = math.floor((vim.o.columns - w) / 2), row = math.floor((vim.o.lines - h) / 2),
  })
  for _, k in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", k, "<Cmd>close<CR>", { buffer = buf, nowait = true })
  end
end, { desc = "Cheatsheet" })
