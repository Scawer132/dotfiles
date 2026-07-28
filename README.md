# dotfiles

终端配置统一管理仓库，通过 git submodule 组织。

## 架构

```
.
├── powershell/    submodule → Scawer132/omp-config (Oh My Posh 配置)
├── wezterm/       submodule → Scawer132/wezterm-config (fork from KevinSilvester/wezterm-config)
└── setup.sh       新机器初始化脚本
```

本地 `~/.config/powershell` 和 `~/.config/wezterm` 为软链接，指向本仓库对应的 submodule 目录。日常在 `~/.config/` 下编辑和 git 操作，改动天然记录在本仓库中。

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

### 修改配置

在 `~/.config/powershell/` 或 `~/.config/wezterm/` 下正常操作（软链接透明）， submodule 内直接 commit & push 即可。

### 更新 submodule 到各自最新

```bash
cd ~/dotfiles
git submodule update --remote --merge
git commit -m "update: 更新 submodule 到最新版本"
git push
```

### 同步 wezterm 上游

```bash
cd ~/dotfiles/wezterm
git fetch upstream
git merge upstream/master
git push origin master
cd ..
git add wezterm
git commit -m "update: 同步 wezterm 上游变更"
git push
```
