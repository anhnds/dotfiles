-- Neovim nhẹ: dùng để sửa file nhanh trong terminal. Code chính dùng VS Code.
-- Chuyển từ config vim cũ (gist macbook.vim, 2020) sang Lua, bỏ bớt plugin.
--
--   lua/config/options.lua   tuỳ chọn cơ bản
--   lua/config/keymaps.lua   phím tắt không cần plugin
--   lua/config/plugins.lua   mini.nvim + fzf-lua (cài bằng vim.pack có sẵn)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.plugins")
