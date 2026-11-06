# dotfiles

Config terminal & tool cho macOS: zsh, Neovim (bản nhẹ), Rex (terminal), git, kèm danh sách Homebrew.
Editor chính là VS Code; nvim chỉ dùng để sửa file nhanh trong terminal (`$EDITOR`, git commit, `ff`).
Quản lý bằng **GNU Stow**: repo là bản gốc, còn `$HOME` chỉ chứa symlink trỏ vào repo.

> ⚠️ Repo **public**: tuyệt đối không commit token, key, mật khẩu. Xem mục [Secrets](#secrets-1password) và [Bảo mật](#bảo-mật).
>
> Mở session mới (Claude / agent khác)? Đọc mục [Bối cảnh & quyết định](#bối-cảnh--quyết-định) trước.

## Cài trên máy mới

```sh
# 1. Xcode CLT (có git)
xcode-select --install

# 2. Clone (cần SSH key đã add vào GitHub; hoặc dùng URL https)
git clone git@github.com:anhnds/dotfiles.git ~/workspace/dotfiles

# 3. Cài: Homebrew + Brewfile + tool AI + oh-my-zsh + symlink + LaunchAgent
cd ~/workspace/dotfiles && ./install.sh

# 4. Đăng nhập app 1Password, bật Settings > Developer > "Integrate with 1Password CLI", rồi:
secrets-env refresh
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
├── install.sh                # brew bundle + tool AI + oh-my-zsh + stow + LaunchAgent
├── zsh/
│   ├── .zshenv               # → ~/.zshenv     chỉ nạp secret cache
│   ├── .zprofile             # → ~/.zprofile   env + PATH
│   ├── .zshrc                # → ~/.zshrc      oh-my-zsh, source modules, plugins
│   └── .config/zsh/          # → ~/.config/zsh
│       ├── tools.zsh         #   fzf, bun, autojump, keybind
│       ├── aliases.zsh
│       ├── functions.zsh     #   ff, to, gff, gto
│       └── local.zsh         #   (gitignored) config riêng từng máy
├── nvim/.config/nvim/        # → ~/.config/nvim  (xem mục Neovim)
├── rex/.config/rex/          # → ~/.config/rex   init.lua: keybind của Rex (theme, font lưu trong app)
├── git/.config/git/          # → ~/.config/git   config, global ignore, ký commit qua 1Password
└── secrets/                  # xem mục Secrets
    ├── .local/bin/secrets-env
    └── Library/LaunchAgents/dev.anhnds.secrets-env.plist
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
├── cheatsheet.md          # bảng phím: config riêng + plugin + vim cơ bản (Space ?)
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
| `Space ?` | mở cheatsheet đầy đủ (`nvim/.config/nvim/cheatsheet.md`) |

Cập nhật plugin: `:lua vim.pack.update()` → xem thay đổi → `:write` để áp dụng, rồi commit `nvim-pack-lock.json`.

## zsh load file theo thứ tự nào

| File | Chạy khi | Để gì |
|---|---|---|
| `~/.zshenv` | mọi zsh, kể cả `zsh -c`, script, `ssh host cmd` | **chỉ nạp secret cache**, giữ thật nhẹ |
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

**Commit message** dùng prefix theo package: `zsh:`, `nvim:`, `rex:`, `git:`, `brew:`, `install:`, `docs:`.

**Máy khác** cập nhật:

```sh
cd ~/workspace/dotfiles && git pull && ./install.sh
```

### Cài tool mới

```sh
brew install <tool>        # hàm brew() trong functions.zsh tự dump lại Brewfile
dotfiles && git diff Brewfile
git commit -am "brew: thêm <tool>"
```

Hàm `brew()` tự cập nhật Brewfile sau `install`, `uninstall`, `reinstall`, `tap`, `untap`, nhưng không tự commit.
Gói cài bằng `npm install -g` thì cần tự chạy `brew bundle dump --force --file=~/workspace/dotfiles/Brewfile`.

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

## Secrets (1Password)

Mọi token/API key nằm trong **1Password cloud**, không nằm trong repo hay file config.
`secrets-env` kéo chúng về một file cache, rồi mỗi lớp đọc từ file đó.

**Có 2 cách khai báo secret trong 1Password** (vault nào cũng được, hiện dùng `Private`):

| Cách | Khi nào dùng | Ví dụ |
|---|---|---|
| **A. Item tag `shell-env`**: mỗi field là một biến, **tên field = tên biến** | nhóm biến của một dự án, tạo item riêng | item `VSF-Dev-Env` (của máy công ty, **bị loại trừ trên Mac mini**): `JFROG_URL`, `JFROG_TOKEN`, ... |
| **B. Template `op://`**: Secure Note **`shell-env-refs`** (tag `shell-env-refs`), mỗi dòng `TÊN=op://vault/item/[section/]field` | lấy từ item **có sẵn** (Login, API Credential...) mà không phải sửa item, hoặc tự đặt tên biến | `GITHUB_TOKEN=op://Private/GitHub Personal Access Token/token` |

- Gắn thêm tag **`gui-env`** vào item (cách A) hoặc vào note (cách B) thì các biến đó cũng được đưa cho GUI app
  (VS Code, Claude desktop mở từ Dock). Chỉ gắn khi app thật sự cần, vì mọi GUI app đều đọc được.
- Trong note `shell-env-refs`, vế phải **bắt buộc là `op://...`**. Không ghi giá trị thẳng vào note, vì note là text thường, không được che như field Password.
- Field rỗng, field ghi chú, tên không hợp lệ làm tên biến (có dấu cách, `-`...), dòng `#` trong template đều bị bỏ qua.
- Tham chiếu `op://` lấy được bằng nút **Copy Secret Reference** trong app 1Password (chuột phải vào field).
  Tên có dấu cách vẫn dùng được. Nếu hay đổi tên item thì dùng ID thay cho tên.

**Luồng:**

```
1Password cloud ──(secrets-env refresh, cần mở khoá app)──► ~/.local/state/secrets/env.sh  (600, ngoài repo)
                                                             │
          ~/.zshenv source ◄─────────────────────────────────┤  terminal, ssh host cmd, script, zsh -c
          LaunchAgent lúc login ── launchctl setenv ◄────────┘  GUI app (chỉ biến của item gui-env)
```

| Lệnh | Việc |
|---|---|
| `secrets-env refresh` | lấy lại tất cả từ 1Password (sau khi thêm, sửa hoặc xoá), rồi `exec zsh` |
| `secrets-env status` | liệt kê **tên** biến đang có, không in giá trị |
| `secrets-env clear` | xoá cache và gỡ biến khỏi launchd |

### Thêm / sửa / xoá / nạp một secret

Mọi thay đổi đều làm **trong 1Password**, không sửa file cache. Sau đó luôn chạy 2 lệnh:

```sh
secrets-env refresh   # kéo lại từ 1Password (có thể hỏi Touch ID)
exec zsh              # mở shell mới để nhận biến (tab khác: mở tab mới hoặc chạy zshexec)
```

| Việc | Cách A: item tag `shell-env` | Cách B: note `shell-env-refs` |
|---|---|---|
| **Thêm** | mở item (vd `VSF-Dev-Env`) → *Add field* → đặt **tên field = tên biến** (`NPM_TOKEN`), loại *Password* hoặc *Text* → lưu. Nhóm mới: tạo item mới, gắn tag `shell-env` | mở note `shell-env-refs` → thêm dòng `NPM_TOKEN=op://Private/npm/token` |
| **Sửa giá trị** | sửa value của field | sửa ở **item gốc** mà tham chiếu trỏ tới, không cần sửa note |
| **Đổi tên biến** | đổi tên field | đổi phần trước dấu `=` |
| **Xoá** | xoá field (hoặc bỏ tag `shell-env` khỏi cả item) | xoá dòng hoặc thêm `#` ở đầu dòng để tắt |
| **Cho GUI app** | gắn tag `gui-env` vào item | gắn tag `gui-env` vào note (áp dụng cho mọi dòng trong note) |

Sau đó chạy `refresh` → `exec zsh` như trên. Kiểm tra bằng `secrets-env status`, hoặc `echo ${#NPM_TOKEN}` (in độ dài, không in giá trị).

Lưu ý:
- **Shell đang mở vẫn giữ giá trị cũ** cho tới khi `exec zsh`. Biến đã xoá cũng chỉ mất khỏi shell mới.
- GUI app nhận biến mới **sau khi mở lại app**. Biến đã bỏ tag `gui-env` sẽ tự bị gỡ khỏi launchd khi `refresh`.
- Tham chiếu hỏng (item bị đổi tên hoặc xoá) thì `refresh` báo `không đọc được TÊN (...)`, bỏ qua biến đó và vẫn ghi các biến khác.
- Hai nơi cùng khai báo một tên biến: `refresh` cảnh báo trùng, và nơi được đọc sau thắng (template `op://` đọc sau cùng).
- Đừng đặt `GITHUB_TOKEN`/`GH_TOKEN` trừ khi token còn sống: `gh` ưu tiên biến này hơn phiên đăng nhập keyring.
  (PAT `GitHub Personal Access Token` hiện **đã hết hiệu lực**, GitHub trả 401, nên dòng mẫu trong note đang tắt.)

### Loại trừ theo máy

Tag `shell-env` dùng chung cho mọi máy đăng nhập cùng tài khoản 1Password. Vì vậy item **của máy khác** (vd máy công ty)
thì chặn ở từng máy bằng file **`~/.config/secrets-env/exclude`**. File này nằm trên máy, không có trong dotfiles.
Mỗi dòng ghi tên hoặc ID của một item/note, dòng `#` là comment:

```
# ~/.config/secrets-env/exclude trên Mac mini
VSF-Dev-Env
```

Thêm hoặc bỏ một dòng → `secrets-env refresh` → `exec zsh`. `refresh` in ra các item bị bỏ qua.
Không gỡ tag khỏi item trong 1Password, vì máy kia vẫn cần tag đó.
Máy mới: tạo lại file này nếu máy đó cũng không được nạp item công ty.

### Secret quan trọng: `op run`, không vào cache

Token production, khoá thanh toán... không nên nằm trong cache hay có trong mọi shell. Khai báo chúng trong một file
`.env` chứa tham chiếu (file không chứa secret, nhưng **đừng commit vào repo public** vì lộ tên vault và item), rồi chạy:

```sh
# prod.env:  STRIPE_KEY=op://Private/Stripe/secret_key
op run --env-file=prod.env -- ./deploy.sh
```

Secret chỉ tồn tại trong process đó, và nếu bị in ra output thì `op run` tự che bằng `<concealed by 1Password>`.

**SSH: hai chuyện khác nhau**
- *SSH key* (đăng nhập GitHub, server, ký commit) **không** đi qua `secrets-env`, mà qua **1Password SSH Agent**:
  `~/.ssh/config` có `IdentityAgent` trỏ tới agent của 1Password, private key không bao giờ nằm trên ổ đĩa,
  `~/.ssh` chỉ chứa file `.pub` để chọn đúng key cho từng host. Ngoại lệ: `id_ed25519_gitlab_local`
  (GitLab Docker ở `localhost:2224`) là private key nằm trên ổ đĩa.
- *SSH vào máy này* (`ssh mac-mini 'cmd'`): zsh vẫn đọc `~/.zshenv`, nên các biến `shell-env` **có** trong phiên SSH.

Vì sao làm như vậy:
- **Shell không gọi `op` lúc khởi động**: tránh chậm và tránh hỏi Touch ID mỗi lần mở tab. Cache chỉ đổi khi bạn chạy `refresh`.
- **Dùng tích hợp app 1Password, không dùng service account**: service account không đọc được vault Private.
- **Nạp ở `.zshenv`, không ở `.zprofile`**: `ssh mac-mini cmd`, cron và script không chạy `.zprofile`.
- **launchd chỉ để bù cho GUI app**: biến của launchd không tới được SSH, cron hay container, và chỉ app mở *sau* lúc set mới nhận.
- Container (OrbStack/Docker) không kế thừa env của host, nên truyền bằng `docker run -e JFROG_TOKEN` hoặc `env_file`.
- File config như `.npmrc` nên tham chiếu biến (`//host/:_authToken=${NPM_TOKEN}`) thay vì ghi thẳng token.

## Bảo mật

Repo public, nên:

- **Secrets** quản lý theo mục [Secrets](#secrets-1password). Không ghi token vào file nào trong repo.
- Config chỉ dành cho một máy để trong `~/.config/zsh/local.zsh` (gitignored) hoặc file `*.local`.
- Trước khi push luôn xem `git diff --cached`. Installer (bun, OrbStack, Antigravity...)
  hay tự append vào `~/.zprofile` / `~/.zshrc`, mà hai file đó giờ nằm trong repo.
- Không đưa vào repo: `~/.ssh`, `~/.config/gh/hosts.yml`, `~/.config/op`, `~/.docker/config.json`, `~/.kube`.
- Lỡ commit secret: **revoke/đổi key ngay**. Xoá khỏi history là không đủ, vì repo public có thể đã bị clone.

## Bối cảnh & quyết định

Ghi lại để mang sang máy khác hoặc mở session mới (Claude, agent) vẫn có đủ ngữ cảnh. Mới nhất ở trên.

**2026-11-06: Mac mini không nạp secret công ty.** `VSF-Dev-Env` là secret của máy công ty. Chặn nó bằng
`~/.config/secrets-env/exclude` trên Mac mini, không gỡ tag `shell-env`, để máy công ty vẫn dùng được.
Hiện Mac mini **không nạp biến nào** (cache rỗng). Note `shell-env-refs` chỉ có dòng mẫu đang tắt.

**2026-11-06: thêm template `op://` (Secret References).** Theo một tài liệu tham khảo về `op inject`/`op run`.
Giữ cách dùng tag `shell-env`, và thêm Secure Note `shell-env-refs` chứa `TÊN=op://...` (đọc bằng `op read` khi `refresh`).
Template để trong 1Password chứ không ở repo, vì repo public sẽ lộ tên vault và item. Secret quan trọng thì dùng `op run`, không cho vào cache.
PAT GitHub trong 1Password đã chết (401), nên chưa export `GITHUB_TOKEN`.

**2026-11-06: Brewfile tự cập nhật.** Homebrew không có hook sau khi cài, nên dùng hàm bọc `brew()` (`zsh/.config/zsh/functions.zsh`):
sau install/uninstall/tap nó chạy `brew bundle dump --force`. Không tự commit, để còn xem diff trước.

**2026-11-06: Ghostty → Rex.** Terminal chính giờ là Rex (`/Applications/Rex Beta.app`, cài tay, không có trong Brewfile).
Rex **không** đọc config Ghostty: nó chỉ dùng engine hiển thị `swift-ghostty`, keybind cũ đã được import một lần vào
`~/.config/rex/init.lua`, còn theme (`midnight-tundra` / `merino-light`) và font lưu trong settings của app
(`defaults read com.superlogical.rex`). Đã xoá package `ghostty/` (vẫn còn trong git history) và gỡ cask Ghostty.

**2026-11-06: secrets từ 1Password.** Tham khảo setup trên máy khác. Mac mini kéo **trực tiếp từ 1Password cloud**,
không kết nối tới máy kia. Dùng lại quy ước tag `shell-env` đã có (item `VSF-Dev-Env`). Thiết kế 1 nguồn (cache) và 3 lớp:
`.zshenv` cho shell và SSH, file config tham chiếu `${VAR}`, launchd chỉ cho GUI app có tag `gui-env`.
Đã cân nhắc nhưng bỏ: template `op://` (không cần vì đã lấy theo tag), service account (không đọc được vault Private),
gọi `op` mỗi lần mở shell (chậm, hỏi Touch ID).
Chưa đưa vào: item `GitHub Personal Access Token` (field tên `token`). Muốn export thì đổi tên field thành `GITHUB_TOKEN`
và gắn tag `shell-env`. `gh` đã đăng nhập qua keyring nên chưa cần.

**2026-11-06: Neovim nhẹ, editor chính là VS Code.** Bỏ LazyVim vì không thuận tay. Port config vim cũ
(gist `macbook.vim` năm 2020, vim-plug + NERDTree/fzf/airline/leader-guide/fugitive) sang Lua với `vim.pack`, mini.nvim, fzf-lua.
Giữ hjkl (không remap Colemak-DH). `$EDITOR` vẫn là nvim cho git commit, Ctrl-x Ctrl-e và `ff`.

**2026-11-06: dọn tool.** Gỡ lazygit, yt-dlp, tree-sitter-cli, x-cmd, Herdr (cả app, config và hook trong
`~/.claude/settings.json` lẫn `~/.gemini/config/hooks.json`). Thêm tool AI: gitnexus (npm, cần build native và `openssl@3`),
code-review-graph (pipx), Antigravity CLI `agy`. Hook của Rex trong Claude settings giữ nguyên.

**2026-11-06: tái cấu trúc bằng Stow.** Trước đó chỉ có `zshrc` + Ghostty symlink tay. Chuyển sang package Stow, XDG,
`Brewfile`, `install.sh`. Tách `.zprofile` (env/PATH) khỏi `.zshrc` (tương tác), thêm `typeset -U path PATH`
vì PATH từng bị trùng. Bật ký commit bằng SSH qua 1Password (`op-ssh-sign`). Backup config cũ (`~/dotfiles-backup-20261106/`) đã xoá sau khi chạy ổn.

**Quy ước chung:** repo public, không chứa secret. Commit prefix theo package. `brew bundle --no-upgrade`
để installer không tự nâng cấp app. SSH key GitHub nằm trong 1Password SSH agent (`~/.ssh/config`, không có trong repo).
