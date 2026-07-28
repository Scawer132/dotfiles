# dotfiles

终端配置统一管理仓库，通过 git submodule 组织。

## 架构

```
.
├── powershell/    → Scawer132/omp-config (Oh My Posh 配置)
└── wezterm/       → Scawer132/wezterm-config (WezTerm 配置，fork from KevinSilvester/wezterm-config)
```

每个 submodule 对应一个独立的 GitHub 仓库，拥有各自的提交历史和远程关联。本仓库仅记录各 submodule 的 commit 指针，不存储实际文件内容。

## 克隆

```bash
git clone --recurse-submodules https://github.com/Scawer132/dotfiles.git ~/dotfiles
```

如果克隆时忘记 `--recurse-submodules`：

```bash
git submodule update --init --recursive
```

## 日常维护

### 更新 submodule 到各自最新

```bash
git submodule update --remote --merge
git commit -m "update: 更新 submodule 到最新版本"
git push
```

### 同步 wezterm 上游

```bash
cd wezterm
git fetch upstream
git merge upstream/master
git push origin master
cd ..
# 主仓库会检测到 submodule commit 变化，提交并推送
git add wezterm
git commit -m "update: 同步 wezterm 上游变更"
git push
```

### 修改某个配置后

在 submodule 目录内正常提交推送，然后回到主仓库更新指针：

```bash
cd powershell
# ... 修改文件 ...
git add . && git commit -m "xxx" && git push
cd ..
git add powershell
git commit -m "update: 更新 powershell 配置"
git push
```

## 恢复配置到新机器

克隆后建立软链接，让系统读取 dotfiles 中的配置：

```bash
ln -sf ~/dotfiles/powershell ~/.config/powershell
ln -sf ~/dotfiles/wezterm ~/.config/wezterm
```
