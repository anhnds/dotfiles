local o = vim.opt

-- Giữ từ config cũ
o.number = true
o.tabstop = 4          -- tab hiển thị rộng 4
o.shiftwidth = 4       -- >> thụt 4
o.expandtab = true     -- Tab chèn dấu cách
o.clipboard = "unnamedplus" -- y/p dùng chung clipboard macOS
o.mouse = ""           -- tắt chuột
o.list = true          -- hiện tab và khoảng trắng thừa
o.listchars = { tab = "▸ ", trail = "·", nbsp = "␣", extends = "#" }

-- Bổ sung
o.ignorecase = true    -- tìm không phân biệt hoa thường...
o.smartcase = true     -- ...trừ khi gõ chữ hoa
o.undofile = true      -- undo được cả sau khi đóng file
o.signcolumn = "yes"   -- chừa cột trái cho dấu git
o.splitright = true
o.splitbelow = true
o.scrolloff = 5
