# Neovim cheatsheet

Mở nhanh: `Space ?` (q / Esc để đóng). Leader = `Space`. Bấm `Space` rồi chờ sẽ hiện gợi ý phím.

## Phím riêng (config này)

| Phím              | Việc                                   |
|-------------------|----------------------------------------|
| `Ctrl-p`          | tìm file                               |
| `Space /`         | tìm nội dung trong project (ripgrep)   |
| `Space r`         | file mở gần đây                        |
| `Ctrl-b`          | cây thư mục tại file hiện tại          |
| `Ctrl-t`          | tab mới                                |
| `Space l` / `h`   | buffer sau / trước                     |
| `Space bl`        | danh sách buffer                       |
| `Space bd`        | đóng buffer                            |
| `Space wv` / `wh` | chia dọc / chia ngang                  |
| `Space wc`        | đóng cửa sổ                            |
| `Space gb`        | git: lịch sử dòng / vùng tại con trỏ   |
| `Space gd`        | git: bật/tắt xem diff ngay trong file  |
| `Esc`             | bỏ highlight tìm kiếm                  |
| `Space ?`         | mở cheatsheet này                      |

## Trong ô tìm kiếm (fzf-lua)

| Phím                  | Việc                                    |
|-----------------------|-----------------------------------------|
| `Enter`               | mở                                      |
| `Ctrl-v` / `Ctrl-s`   | mở chia dọc / chia ngang                |
| `Ctrl-t`              | mở ở tab mới                            |
| `Tab`                 | chọn nhiều                              |
| `Alt-a`               | chọn / bỏ chọn tất cả                   |
| `Alt-q`               | đưa mục đã chọn vào quickfix            |
| `Ctrl-g`              | (khi grep) chuyển giữa regex và fuzzy   |
| `Shift-↑` / `Shift-↓` | cuộn preview                            |
| `F4`                  | ẩn/hiện preview                         |
| `F1`                  | xem tất cả phím                         |

## Trong cây thư mục (mini.files)

| Phím          | Việc                                        |
|---------------|---------------------------------------------|
| `l` / `h`     | vào thư mục, mở file / ra thư mục cha       |
| `L`           | mở file và đóng cây                         |
| `q`           | đóng                                        |
| `=`           | **áp dụng thay đổi** (tạo / xoá / đổi tên)  |
| `@`           | nhảy về thư mục làm việc (cwd)              |
| `<BS>`        | về lại vị trí ban đầu                       |
| `g?`          | xem tất cả phím                             |

Sửa file như sửa text: thêm dòng `ten.txt` hoặc `thu-muc/` để tạo, `dd` để xoá, sửa tên để đổi tên.
`yy` rồi `p` ở thư mục khác để copy. Xong bấm `=` để xác nhận.

## Git trong file (mini.diff)

| Phím          | Việc                                     |
|---------------|------------------------------------------|
| `]h` / `[h`   | đoạn thay đổi sau / trước                |
| `]H` / `[H`   | đoạn thay đổi cuối / đầu                 |
| `ghgh`        | stage đoạn tại con trỏ                   |
| `gHgh`        | huỷ (reset) đoạn tại con trỏ             |
| `gh` (visual) | stage vùng đã chọn                       |

Lệnh `:Git <bất kỳ>` chạy git ngay trong nvim, ví dụ `:Git log --oneline`, `:Git blame -- %`.

## Vim cơ bản

**Di chuyển**

| Phím                | Việc                                  |
|---------------------|---------------------------------------|
| `h j k l`           | trái / xuống / lên / phải             |
| `w` / `b` / `e`     | từ sau / từ trước / cuối từ           |
| `0` / `^` / `$`     | đầu dòng / ký tự đầu / cuối dòng      |
| `gg` / `G` / `42G`  | đầu file / cuối file / dòng 42        |
| `Ctrl-d` / `Ctrl-u` | cuộn nửa trang xuống / lên            |
| `%`                 | nhảy tới ngoặc tương ứng              |
| `f x` / `t x`       | tới / trước ký tự x trên dòng (`;` lặp) |
| `Ctrl-o` / `Ctrl-i` | về vị trí trước / sau                 |

**Sửa**

| Phím                | Việc                                      |
|---------------------|-------------------------------------------|
| `i` / `a`           | chèn trước / sau con trỏ                  |
| `I` / `A`           | chèn đầu / cuối dòng                      |
| `o` / `O`           | dòng mới dưới / trên                      |
| `x`                 | xoá ký tự                                 |
| `dd` / `yy` / `p`   | cắt dòng / copy dòng / dán (clipboard macOS) |
| `ciw` / `ci"` / `ci(` | sửa từ / trong "" / trong ()            |
| `diw` / `da"`       | xoá từ / xoá cả "..."                     |
| `u` / `Ctrl-r`      | undo / redo                               |
| `.`                 | lặp lại thao tác vừa làm                  |
| `>>` / `<<`         | thụt vào / ra                             |
| `gcc` / `gc` (visual) | comment dòng / vùng chọn                |
| `~`                 | đổi hoa / thường                          |

**Chọn (visual)**: `v` theo ký tự, `V` theo dòng, `Ctrl-v` theo khối. Chọn xong dùng `d` `y` `c` `>` `gc`.
Sửa nhiều dòng cùng lúc: `Ctrl-v`, chọn cột, `I`, gõ, `Esc`.

**Tìm và thay**

| Phím / lệnh          | Việc                                 |
|----------------------|--------------------------------------|
| `/text` / `?text`    | tìm xuôi / ngược (`n` / `N` lặp)     |
| `*` / `#`            | tìm từ dưới con trỏ xuôi / ngược     |
| `:%s/cu/moi/g`       | thay toàn file                       |
| `:%s/cu/moi/gc`      | thay toàn file, hỏi từng chỗ         |

**File, cửa sổ, buffer**

| Phím / lệnh               | Việc                                  |
|---------------------------|---------------------------------------|
| `:w` / `:q` / `:wq` / `:q!` | lưu / thoát / lưu và thoát / thoát bỏ thay đổi |
| `ZZ`                      | lưu và thoát                          |
| `Ctrl-w h/j/k/l`          | chuyển cửa sổ                         |
| `Ctrl-w =`                | chia đều cửa sổ                       |
| `]b` / `[b`               | buffer sau / trước (có sẵn)           |
| `gt` / `gT`               | tab sau / trước                       |
| `]q` / `[q`               | mục quickfix sau / trước              |

**Gập code**: `za` mở/gập, `zR` mở hết, `zM` gập hết.

**Macro**: `qa` bắt đầu ghi vào a, `q` dừng, `@a` chạy, `@@` chạy lại.

## Từ terminal

| Lệnh                 | Việc                                          |
|----------------------|-----------------------------------------------|
| `ff` / `gff`         | chọn file (thư mục hiện tại / cả `~`) rồi mở nvim |
| `Ctrl-x Ctrl-e`      | sửa dòng lệnh đang gõ bằng nvim               |
| `nvimcf`             | mở config nvim                                |
| `:lua vim.pack.update()` | cập nhật plugin (`:write` để áp dụng)     |
