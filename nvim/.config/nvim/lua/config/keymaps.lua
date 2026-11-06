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
