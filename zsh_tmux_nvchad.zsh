#!/bin/bash

# Update package list and upgrade packages
sudo apt update
sudo apt upgrade -y  # Add -y to automatically confirm upgrades

# Install zsh and related tools
sudo apt install -y zsh git curl gnome-tweaks  # Combined installation into one line for brevity

# Download and install fzf
wget https://github.com/junegunn/fzf/releases/download/v0.55.0/fzf-0.55.0-linux_amd64.tar.gz
wget https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.6/zoxide_0.9.6-1_amd64.deb
tar -zxvf fzf-0.55.0-linux_amd64.tar.gz
sudo dpkg -i zoxide_0.9.6-1_amd64.deb
sudo mv fzf /usr/local/bin/fzf  # Ensure fzf is placed in the correct bin directory
rm -rf fzf fzf-0.55.0-linux_amd64.tar.gz  # Clean up after download
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fzf --version  # Check fzf installation

# Append configurations to ~/.zshrc
cat << 'EOF' >> ~/.zshrc
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add custom SSH completion to prioritize ~/.ssh/config entries
zstyle ':completion:*:*:ssh:*:hosts' hosts \
    $(awk '/^Host / {print $2}' ~/.ssh/config | tr '\n' ' ')

# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::docker
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
zinit snippet OMZP::tmux
zinit snippet OMZP::ssh
# Load completions
autoload -Uz compinit
compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# tmux commands
alias tn='tmux new-session -s'       # Start a new session
alias tb='tmux attach-session -t'     # Attach to a session
alias ts='tmux list-sessions'         # List sessions
alias tk='tmux kill-session -t'       # Kill a session
alias ping='ping -c 5'                  # Limit ping to 5 packets
alias ll='ls -la --color'
alias update='sudo apt update && sudo apt upgrade -y'  # Quick system update
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'  # Display cleaner docker ps output
alias h='history'
alias hgrep='history | grep $1'
alias findd='find . -name '
alias ..='cd ..'
alias ...='cd ../..'
alias untar='tar -zxvf $1'
alias tarr='tar -czvf $1'
alias start.='nautilus .'

# Bind Ctrl + Right Arrow to move forward one word
bindkey '^[[1;5C' forward-word
# Bind Ctrl + Left Arrow to move backward one word
bindkey '^[[1;5D' backward-word

# Shell integrations
source <(fzf --zsh)
#eval "\$(zoxide init --cmd cd zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"
EOF

# Install tmux and configure it
sudo apt install -y tmux  # Install tmux

# Create or append to the .tmux.conf file
mkdir -p ~/.tmux/
touch ~/.tmux/tmux.only.conf
touch ~/.tmux/tmux.extra.conf
cat << 'EOF' >> ~/.tmux.conf

set-option -sa terminal-overrides ",xterm*:Tc"
set -g mouse on

unbind C-b
set -g prefix C-b
bind C-b send-prefix

# Vim style pane selection
bind h select-pane -L
bind j select-pane -U
bind k select-pane -D
bind l select-pane -R

# Start windows and panes at 1, not 0
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

# Use Alt-arrow keys without prefix key to switch panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Shift arrow to switch windows
bind -n S-Left  previous-window
bind -n S-Right next-window

# Shift Alt vim keys to switch windows
bind -n M-H previous-window
bind -n M-L next-window

set -g @catppuccin_flavour 'mocha'

# TPM (Tmux Plugin Manager) plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'dreamsofcode-io/catppuccin-tmux'
set -g @plugin 'tmux-plugins/tmux-yank'

# Run TPM
run '~/.tmux/plugins/tpm/tpm'

# Set vi-mode
set-window-option -g mode-keys vi
# Keybindings
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

bind 6 split-window -v -c "#{pane_current_path}"  # Vertical split
bind 7 split-window -h -c "#{pane_current_path}"     # Horizontal split
EOF



# Install TPM
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

tmux source-file ~/.tmux.conf
touch ~/.local/share/zinit/snippets/OMZP::tmux/tmux.extra.conf
sudo apt install build-essential -y
sudo apt install npm -y
cd ~
wget https://github.com/neovim/neovim-releases/releases/download/v0.10.2/nvim-linux64.deb
sudo dpkg -i nvim-linux64.deb
git clone https://github.com/NvChad/starter ~/.config/nvim
echo bind M-k cut main > ~/.nanorc
nvim
cat << 'EOF' > ~/.config/nvim/lua/configs/lspconfig.lua
-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- Corrected server names
local servers = {
    "ansiblels",                 -- Ansible
    "bashls",                    -- Bash
    "lua_ls",                    -- Lua
    "dockerls",                  -- Docker
    "docker_compose_language_service",  -- Docker Compose (adjusted to its lspconfig name)
    "helm_ls",                   -- Helm
    "marksman",                  -- Markdown (Marksman)
    "nginx_language_server",     -- NGINX
    "powershell_es",             -- PowerShell
    "terraformls",               -- Terraform
    "yamlls",                    -- YAML
}

local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
EOF
cat << 'EOF' > ~/.config/nvim/lua/plugins/init.lua
return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Harpoon plugin setup
  {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({})
    end,
  },

  -- Mason setup
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "ansible-language-server",
        "bash-language-server",
        "lua-language-server",
        "docker-language-server",
        "docker-compose-language-service",
        "helm-ls",
        "markdown-oxide",
        "nginx-language-server",
        "powershell-editor-services",
        "terraform-ls",
        "yaml-language-server",
      },
    },
    config = function(_, opts)
      require("mason").setup()  -- Mason setup
    end,
  },

  -- Mason-LSPConfig to link Mason and LSPConfig
  {
    "williamboman/mason-lspconfig.nvim",  -- Ensures LSP servers are installed
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "ansiblels",                  -- Ansible
          "bashls",                     -- Bash
          "lua_ls",                     -- Lua
          "dockerls",                   -- Docker
          "docker_compose_language_service",  -- Docker Compose
          "helm_ls",                    -- Helm
          "marksman",                   -- Markdown (Marksman)
          "nginx_language_server",      -- NGINX
          "powershell_es",              -- PowerShell
          "terraformls",                -- Terraform
          "yamlls",                     -- YAML
        },
      }
    end,
  },

-- Treesitter (optional, uncomment if needed)
{
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
		"vim", "lua", "vimdoc", "html", "css"
		},
	},
},
}
EOF
cat << 'EOF' > ~/.config/nvim/lua/mappings.lua
require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
-- greatest remap ever
map("x", "<leader>p", [["_dP]])
-- next greatest remap ever : asbjornHaland
map({"n", "v"}, "<leader>y", [["+y]])
map({"n", "v"}, "<leader>d", [["_d]])
map("i", "<C-c>", "<Esc>")
map("n", "Q", "<nop>")
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map('n', '<C-s>', ':wq<CR>', { noremap = true, silent = true })
map('i', '<C-s>', '<Esc>:wq<CR>', { noremap = true, silent = true })
map('v', '<leader>o', '<Esc>o', { noremap = true, silent = true })
map('n', '<F5>', ':wqa!<CR>', { noremap = true, silent = true })
map('i', '<F5>', '<Esc>:wqa!<CR>', { noremap = true, silent = true })
map('n', '<C-q>', ':q!<CR>', { noremap = true, silent = true })
map('i', '<C-q>', '<Esc>:q!<CR>', { noremap = true, silent = true })
map('n', '<F4>', ':qa!<CR>', { noremap = true, silent = true })
map('i', '<F4>', '<Esc>:qa!<CR>', { noremap = true, silent = true })
--map('n', '<F12>', ':split<CR>', { noremap = true, silent = true })
--map('n', '<F8>', ':vsplit<CR>', { noremap = true, silent = true })
--map('i', '<F12>', ':split<CR>', { noremap = true, silent = true })
--map('i', '<F8>', ':vsplit<CR>', { noremap = true, silent = true })
map('n', '<C-a>', 'ggVG', { noremap = true, silent = true })
map('i', '<C-a>', 'ggVG', { noremap = true, silent = true })
-- ~/.config/nvim/lua/custom/mappings.lua
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

-- Key mappings for Harpoon
map("n", "<F2>", function() mark.add_file() end, { noremap = true, silent = true })
map("n", "<F3>", function() ui.toggle_quick_menu() end, { noremap = true, silent = true })

-- Navigate between marked files
map("n", "<F12>", function() ui.nav_next() end, { noremap = true, silent = true })  -- Next file
map("n", "<F8>", function() ui.nav_prev() end, { noremap = true, silent = true })  -- Previous file

-- Remove marks
map("n", "<F9>", function() mark.rm_file() end, { noremap = true, silent = true })  -- Unmark the current file
map("n", "<F10>", function() require("harpoon.mark").clear_all() end, { noremap = true, silent = true })  -- Unmark all files
EOF
cat << 'EOF' > ~/.config/nvim/lua/options.lua
require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
-- Automatically open NvimTree on startup after the plugins are loaded
vim.cmd [[
  augroup NvimTreeAutoOpen
    autocmd!
    autocmd VimEnter * if empty(argv()) | NvimTreeToggle | endif
  augroup END
]]
EOF

# Switch to zsh
# Reload zsh configuration
curl -L https://raw.githubusercontent.com/catppuccin/gnome-terminal/v0.3.0/install.py | python3 -
sudo apt install fontconfig -y
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
unzip FiraCode.zip
sudo fc-cache -fv ~/.local/share/fonts

echo steps to do:
echo terminal theme enable
echo do "tn 1" and then "tmux source-file ~/.tmux.conf" and then ctrl+b/I and ctrl+b/U
echo run gnome-tweaks and enable FireCode fonts
echo "sudo chsh -s /bin/zsh $user" #default shell zsh for current uder
echo MasonInstall ansible-language-server bash-language-server lua-language-server dockerfile-language-server docker-compose-language-service helm-ls markdown-oxide powershell-editor-services terraform-ls yaml-language-server #install your lsp's when you enter nvim
