# dotfiles

Config terminal & tool cho macOS: zsh, Neovim (bản nhẹ), Ghostty, git, kèm danh sách Homebrew.
Editor chính là VS Code; nvim chỉ dùng để sửa file nhanh trong terminal (`$EDITOR`, git commit, `ff`).
Quản lý bằng **GNU Stow**: repo là bản gốc, còn `$HOME` chỉ chứa symlink trỏ vào repo.

> ⚠️ Repo **public**: tuyệt đối không commit token, key, mật khẩu. Xem mục [Bảo mật](#bảo-mật).

## Cài trên máy mới

```sh
# 1. Xcode CLT (có git)
xcode-select --install

# 2. Clone (cần SSH key đã add vào GitHub; hoặc dùng URL https)
git clone git@github.com:anhnds/dotfiles.git ~/workspace/dotfiles

# 3. Cài: Homebrew + Brewfile + tool AI + oh-my-zsh + symlink
cd ~/workspace/dotfiles && ./install.sh
```

`install.sh` chạy lại bao nhiêu lần cũng an toàn. Nếu một file thật đang chiếm chỗ symlink
(ví dụ `~/.zshrc` do macOS tạo sẵn), script sẽ dừng và in ra file đó: backup/xoá file đó rồi chạy lại.

## Cấu trúc

Mỗi thư mục cấp 1 là một **package** của Stow. Bên trong package mô phỏng đúng cấu trúc `$HOME`:
`zsh/.zshrc` → `~/.zshrc`, `nvim/.config/nvim/` → `~/.config/nvim`.

```
dotfiles/
├── README.md
├── Brewfile                  # brew, cask, font, npm global, VS Code extension
├── install.sh                # brew bundle + tool AI + oh-my-zsh + stow
├── zsh/
│   ├── .zprofile             # → ~/.zprofile   env + PATH
│   ├── .zshrc                # → ~/.zshrc      oh-my-zsh, source modules, plugins
│   └── .config/zsh/          # → ~/.config/zsh
│       ├── tools.zsh         #   fzf, bun, autojump, x-cmd, keybind
│       ├── aliases.zsh
│       ├── functions.zsh     #   ff, to, gff, gto
│       └── local.zsh         #   (gitignored) secrets / config riêng từng máy
├── nvim/.config/nvim/        # → ~/.config/nvim  (xem mục Neovim)
├── ghostty/.config/ghostty/  # → ~/.config/ghostty
└── git/.config/git/          # → ~/.config/git   config + global ignore
```

Ưu tiên đặt config ở `~/.config/<tool>` (chuẩn XDG) thay vì rải file ẩn trong `$HOME`.

## Tool ngoài Homebrew

`install.sh` tự cài nếu máy chưa có:

| Tool | Cài bằng | Ghi chú |
|---|---|---|
| gitnexus | npm (có trong Brewfile) | cần build native; installer tự chạy `npm install -g --allow-scripts=...`; cần `openssl@3` |
| code-review-graph (`crg`) | pipx | |
| Antigravity CLI (`agy`) | script `antigravity.google/cli/install.sh` | installer có thể ghi thêm PATH vào `~/.zprofile`, nên xoá dòng đó vì đã có sẵn |
| oh-my-zsh | script chính thức | |

## Neovim

Config nhẹ, chuyển từ config vim cũ (gist `macbook.vim`, 2020) sang Lua. Mở trong khoảng 20ms.

```
nvim/.config/nvim/
├── init.lua               # leader = Space, nạp 3 module bên dưới
├── nvim-pack-lock.json    # khoá phiên bản plugin (commit file này)
└── lua/config/
    ├── options.lua        # số dòng, tab 4 space, clipboard macOS, tắt chuột...
    ├── keymaps.lua        # phím không cần plugin
    └── plugins.lua        # mini.nvim + fzf-lua
```

Chỉ 2 plugin, cài bằng `vim.pack` có sẵn trong nvim 0.12, không cần lazy.nvim:

| Plugin cũ | Giờ dùng |
|---|---|
| vim-plug | `vim.pack` (built-in) |
| NERDTree | `mini.files` |
| fzf.vim | `fzf-lua` |
| vim-airline | `mini.statusline` + `mini.tabline` |
| vim-leader-guide | `mini.clue` |
| git-blame.vim, fugitive | `mini.git` + `mini.diff` |
| tagbar, monokai | bỏ (dùng VS Code; màu theo theme terminal) |

| Phím | Việc |
|---|---|
| `Ctrl-p` | tìm file |
| `Space /` | tìm nội dung (ripgrep) |
| `Space r` | file mở gần đây |
| `Ctrl-b` | cây thư mục tại file hiện tại (bấm lại để đóng) |
| `Ctrl-t` | tab mới |
| `Space l` / `Space h` | buffer sau / trước |
| `Space bl` / `Space bd` | danh sách buffer / đóng buffer |
| `Space wv` / `wh` / `wc` | chia dọc / chia ngang / đóng cửa sổ |
| `Space gb` | git: lịch sử dòng tại con trỏ |
| `Space gd` | git: xem diff trong file |
| `Space` (chờ) | hiện gợi ý phím |

Cập nhật plugin: `:lua vim.pack.update()` → xem thay đổi → `:write` để áp dụng, rồi commit `nvim-pack-lock.json`.

## zsh load file theo thứ tự nào

| File | Chạy khi | Để gì |
|---|---|---|
| `~/.zshenv` | mọi shell, kể cả script | (không dùng) |
| `~/.zprofile` | login shell, 1 lần khi mở terminal | **biến môi trường, PATH**, `brew shellenv` |
| `~/.zshrc` | shell tương tác (có prompt) | **oh-my-zsh, alias, function, keybind, completion, plugin** |

Trên macOS mỗi tab terminal là login shell nên cả hai file đều chạy.
Quy tắc: *export/PATH → `.zprofile`; thứ phục vụ gõ lệnh → `.zshrc` / `~/.config/zsh/*.zsh`.*

`.zshrc` tự source mọi file `~/.config/zsh/*.zsh` theo thứ tự tên. Muốn thêm nhóm mới thì
chỉ cần tạo file, ví dụ `zsh/.config/zsh/k8s.zsh`.

Cả hai file đều có `typeset -U path PATH` để PATH không bị trùng.
Sau khi sửa config, chạy `zshexec` (= `exec zsh`) để mở một shell sạch.

## Quy trình hằng ngày với GitHub

Các file trong `$HOME` là symlink, nên sửa ở đâu thì repo cũng thay đổi theo:

```sh
zshcf                      # hoặc nvim ~/.config/..., sửa xong
dotfiles                   # cd ~/workspace/dotfiles
git status && git diff     # xem lại, nhất là khi installer tự ghi vào .zprofile
git add -p                 # add từng đoạn, tránh lọt secret
git commit -m "zsh: thêm alias k=kubectl"
git push
```

**Commit message** dùng prefix theo package: `zsh:`, `nvim:`, `ghostty:`, `git:`, `brew:`, `install:`, `docs:`.

**Máy khác** cập nhật:

```sh
cd ~/workspace/dotfiles && git pull && ./install.sh
```

### Cài tool mới

```sh
brew install <tool>
brew bundle dump --file=~/workspace/dotfiles/Brewfile --force   # cập nhật Brewfile
git commit -am "brew: thêm <tool>"
```

Dọn tool không có trong Brewfile: `brew bundle cleanup --file=Brewfile` (xem trước), thêm `--force` để xoá.

### Thêm config cho tool mới (ví dụ tmux)

```sh
cd ~/workspace/dotfiles
mkdir -p tmux/.config/tmux
mv ~/.config/tmux/tmux.conf tmux/.config/tmux/   # nếu đã có file
stow -t ~ tmux                                   # tạo symlink
# thêm "tmux" vào mảng PACKAGES trong install.sh
git add tmux install.sh && git commit -m "tmux: thêm config"
```

Gỡ symlink một package: `stow -t ~ -D <package>`.

## Bảo mật

Repo public, nên:

- **Secrets** (API key, token) để trong `~/.config/zsh/local.zsh`, file này đã được gitignore:
  ```sh
  export OPENAI_API_KEY="..."
  ```
  Tốt hơn nữa là lấy từ 1Password lúc cần thay vì lưu plain text:
  ```sh
  export GITHUB_TOKEN="$(op read 'op://Private/GitHub/token')"
  ```
- Config chỉ dành cho một máy cũng để trong `local.zsh` hoặc file `*.local`.
- Trước khi push luôn xem `git diff --cached`. Installer (bun, OrbStack, Antigravity...)
  hay tự append vào `~/.zprofile` / `~/.zshrc`, mà hai file đó giờ nằm trong repo.
- Không đưa vào repo: `~/.ssh`, `~/.config/gh/hosts.yml`, `~/.config/op`, `~/.docker/config.json`, `~/.kube`.
- Lỡ commit secret: **revoke/đổi key ngay**. Xoá khỏi history là không đủ, vì repo public có thể đã bị clone.
