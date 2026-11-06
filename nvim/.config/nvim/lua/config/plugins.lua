-- 2 plugin, cài bằng vim.pack (nvim 0.12+). Phiên bản khoá trong nvim-pack-lock.json.
--   Cập nhật: :lua vim.pack.update()
vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim", -- statusline, tabline, file explorer, git, gợi ý phím
  "https://github.com/ibhagwan/fzf-lua",    -- tìm file / nội dung (dùng fzf, fd, rg từ brew)
})

local map = vim.keymap.set

-- Giao diện (thay vim-airline)
require("mini.icons").setup()
require("mini.statusline").setup()
require("mini.tabline").setup()

-- Tìm kiếm (thay fzf.vim)
local fzf = require("fzf-lua")
fzf.setup({})
map("n", "<C-p>", fzf.files, { desc = "Tìm file" })
map("n", "<leader>/", fzf.live_grep, { desc = "Tìm nội dung" })
map("n", "<leader>r", fzf.oldfiles, { desc = "File mở gần đây" })
map("n", "<leader>bl", fzf.buffers, { desc = "Danh sách buffer" })

-- File explorer (thay NERDTree): mở tại file hiện tại, bấm lại để đóng
local files = require("mini.files")
files.setup()
map("n", "<C-b>", function()
  if files.close() then return end
  local path = vim.api.nvim_buf_get_name(0)
  files.open(vim.uv.fs_stat(path) and path or nil)
end, { desc = "Cây thư mục" })

-- Git (thay git-blame.vim + fugitive)
require("mini.git").setup()
require("mini.diff").setup() -- dấu thêm/sửa/xoá ở cột trái
map({ "n", "x" }, "<leader>gb", function() MiniGit.show_at_cursor() end, { desc = "Git: lịch sử dòng" })
map("n", "<leader>gd", function() MiniDiff.toggle_overlay() end, { desc = "Git: xem diff" })

-- Gợi ý phím khi bấm <leader>, g, z, <C-w> (thay vim-leader-guide)
local clue = require("mini.clue")
clue.setup({
  triggers = {
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    { mode = "n", keys = "z" },
    { mode = "n", keys = "<C-w>" },
  },
  clues = {
    { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
    { mode = "n", keys = "<Leader>g", desc = "+Git" },
    { mode = "n", keys = "<Leader>w", desc = "+Window" },
    clue.gen_clues.g(),
    clue.gen_clues.z(),
    clue.gen_clues.windows(),
  },
  window = { delay = 300 },
})
