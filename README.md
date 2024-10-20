# Script Summary

**This bash script is intented to be used in a clean ubuntu installation that has no zsh tmux and nvim.**
### 1. System Update and Package Installation
- **Updates** the package list and upgrades installed packages.
- **Installs** essential tools like `zsh`, `git`, `curl`, and `gnome-tweaks`.

### 2. fzf and zoxide Installation
- **Downloads and installs** `fzf` and `zoxide` using `wget`, `dpkg`, and `tar`.
- **Moves fzf** binary to `/usr/local/bin/fzf` and removes the tarball.
- **Installs zinit** for Zsh plugin management via a curl command.

### 3. Zsh Configuration (`~/.zshrc`)
- **Configures Powerlevel10k**, fzf, SSH completion, and custom keybindings.
- **Loads plugins** for zsh-syntax-highlighting, zsh-completions, fzf-tab, and more.
- **Sets up aliases** for commands like `ls`, `vim`, `tmux`, and docker.
- **Defines history settings**, command completion styling, and custom keybindings.

### 4. Tmux Installation and Configuration
- **Installs Tmux** and creates configuration files (`~/.tmux/tmux.conf`).
- **Configures** pane management, window numbering, and mouse support.
- **Adds plugins** like `tmux-sensible`, `vim-tmux-navigator`, `catppuccin-tmux`, and more via TPM (Tmux Plugin Manager).
  
### 5. Neovim Installation and Configuration
- **Installs Neovim** using `dpkg` and sets up `NvChad`.
- **Configures** LSP servers for multiple languages (Ansible, Bash, Lua, Docker, Helm, etc.).
- **Configures Mason** to ensure language servers are installed and links Mason with LSPConfig.
- **Sets up key mappings** for Harpoon and general editing commands.
  
### 6. Font and Theme Installation
- **Installs Nerd Fonts** (FiraCode) and **updates the font cache**.
- **Installs Gnome Terminal theme** and enables FireCode fonts via `gnome-tweaks`.

### Final Steps to mannually do:
- Change the default shell to `zsh` (`sudo chsh -s /bin/zsh $user`).
- Enable Tmux plugins (`tn 1`, `tmux source-file ~/.tmux.conf`, then `ctrl+b I` and `ctrl+b U`).
- Run `MasonInstall` for required LSPs in Neovim.
