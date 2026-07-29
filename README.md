# dotfiles

终端配置统一管理仓库，通过 git submodule 组织。

## 架构

```
.
├── oh-my-posh/    submodule → Scawer132/omp-config (Oh My Posh 主题，zsh + PowerShell 共享)
├── zsh/           submodule → Scawer132/zsh-config (zsh 配置)
├── wezterm/       submodule → Scawer132/wezterm-config (fork from KevinSilvester/wezterm-config)
└── setup.sh       新机器初始化脚本
```

### Prompt 共享机制

`oh-my-posh/` 是 omp-config submodule，zsh 和 PowerShell 共同引用同一份 `config.omp.json`：

- **zsh**（WSL）：`~/dotfiles/zsh/.zshrc` → `source ~/dotfiles/zsh/.zshrc` → `oh-my-posh init --config ~/dotfiles/oh-my-posh/config.omp.json`
- **PowerShell**（Windows）：`Microsoft.PowerShell_profile.ps1` → `oh-my-posh init --config C:\Users\lenovo\dotfiles\oh-my-posh\config.omp.json`

修改 prompt 只需编辑 omp-config 仓库的 `config.omp.json`，两端 submodule update 即可同步。

## 克隆到新机器

```bash
git clone --recurse-submodules https://github.com/Scawer132/dotfiles.git ~/dotfiles
~/dotfiles/setup.sh
```

`setup.sh` 会初始化 submodule 并建立软链接。

如果克隆时忘记 `--recurse-submodules`：

```bash
git submodule update --init --recursive
~/dotfiles/setup.sh
```

## 日常维护

> ⚠️ **重要**：在 submodule 内操作前，务必先 `git checkout <branch>`。父仓库记录的是 commit SHA 而非分支名，同步后 submodule 处于分离头指针状态，此时提交会成为悬空对象，切换分支后丢失。

### 修改 Prompt（oh-my-posh）

```bash
cd ~/dotfiles/oh-my-posh
git checkout main
# 编辑 config.omp.json
git add config.omp.json
git commit -m "feat: 调整 prompt 样式"
git push origin main
cd ..
git add oh-my-posh
git commit -m "update: oh-my-posh submodule"
git push
# 另一端: git pull && git submodule update --remote
```

### 修改 zsh 配置

```bash
cd ~/dotfiles/zsh
git checkout main
# 编辑 config/*.zsh
git add .
git commit -m "feat: xxx"
git push origin main
cd ..
git add zsh
git commit -m "update: zsh submodule"
git push
# 另一端: git pull && git submodule update --remote
```

### 更新所有 submodule 到各自最新

```bash
cd ~/dotfiles
# 确保每个 submodule 在分支上（避免分离头指针下 merge 丢失提交）
git submodule foreach 'git checkout main 2>/dev/null || git checkout master'
git submodule update --remote --merge
git commit -m "update: 更新 submodule 到最新版本"
git push
# 另一端: git pull && git submodule update --remote
```

### 同步 wezterm 上游

```bash
cd ~/dotfiles/wezterm
git checkout main
git fetch upstream
git merge upstream/master
git push origin main
cd ..
git add wezterm
git commit -m "update: 同步 wezterm 上游变更"
git push
# 另一端: git pull && git submodule update --remote
```

## 常见问题

### 为什么 submodule 显示分离头指针？

父仓库记录的是 submodule 的 commit SHA 而非分支名。执行 `git submodule update` 后，submodule 会 checkout 到该 SHA，处于分离头指针状态。这是正常现象，两端内容一致。

### 在 submodule 内修改前必须做什么？

先执行 `git checkout <branch>`，确保 HEAD 指向分支而非 commit SHA。否则提交会成为悬空对象，切换分支后丢失。
