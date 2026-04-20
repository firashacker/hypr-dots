# Basic shell environment
export PATH=$PATH:$HOME/.local/bin:$HOME/.local/guest-bin:$HOME/.bun/bin:$HOME/.local/scripts/theos/bin 
export THEOS=~/.local/scripts/theos 
export HSA_OVERRIDE_GFX_VERSION="10.3.0" # Force GPU for ollama [cite: 36]

# Completion system configuration
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# --- COOL PROMPT CONFIGURATION ---
# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%F{magenta}(%b)%f '

# Prompt Design: [Directory] (Git Branch) %
PROMPT='%F{cyan}%~%f %v%F{yellow}❯%f '
# ----------------------------------

# --- 1. HISTORY CONFIGURATION ---
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=5000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# --- 2. UP-ARROW HISTORY SEARCH ---
# Load the built-in zsh line editor widgets
# --- HISTORY SEARCH (Up/Down Arrow) ---
# This replicates the "matching" feature from Oh My Zsh
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Bind the keys (standard ANSI sequences for arrows)
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# History behavior settings
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups

# --- 3. AUTO-REHASH & DISTRO CHECK ---
zshcache_time="$(date +%s%N)"
autoload -Uz add-zsh-hook

rehash_logic() {
  if [[ -f /etc/arch-release ]]; then
    # ARCH LINUX: Check pacman cache
    if [[ -a /var/cache/zsh/pacman ]]; then
      local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
      if (( zshcache_time < paccache_time )); then
        rehash
        zshcache_time="$paccache_time"
      fi
    fi
  elif [[ -d /nix/store ]]; then
    # NIXOS: Rehash if the profile symlink changed (new generations)
    # Checking the user profile link is the most reliable way on Nix
    rehash
  fi
}

add-zsh-hook precmd rehash_logic


# --- 4. PLUGIN LOADING (DISTRO-AWARE) ---
# NixOS usually loads plugins via /etc/zshrc if enabled in configuration.nix
# This block handles manual loading for Arch/FHS systems
if [[ ! -d /nix/store ]]; then
    # Try Arch/Standard paths
    [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
        source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# --- 5. COMPLETIONS & UI ---
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Aliases [cite: 22, 35, 36]
alias zshconfig="nano ~/.zshrc"
alias gcl='git clone --depth 1'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push origin master'
alias vim='nvim'
alias nano='nano -T 4'
alias stow='stow -t ~'
alias venv='python3 -m venv'
alias xampp='sudo /opt/lampp/xampp'

# eza aliases [cite: 36]
if command -v eza >/dev/null 2>&1; then
    alias ll='eza -l --icons'
    alias la='eza -a --icons'
    alias ls='eza --icons'
fi


# Tmux Autostart [cite: 39]
if command -v tmux >/dev/null 2>&1; then
    kill-tmux-unattached-sessions(){
        tmux ls
    	echo "kill sessions [Y/n]?"
    	read Input
    	if [ "$Input" != "n" ] && [ "$Input" != "N" ];then
   	   tmux ls | awk 'BEGIN{FS=":"}!/attached/{print $1}' | xargs -n 1 tmux kill-ses -t
   	   tmux ls
   	 fi
  	}
    alias tmuxkill='kill-tmux-unattached-sessions'
    
    if [ -z "$TMUX" ];then
    	tmux
    	exit
    fi
fi

# MPC alias
#alias mpc='mpc --host=/tmp/mpd.socket'

# Bun completions [cite: 41]
[ -s "/home/firas/.bun/_bun" ] && source "/home/firas/.bun/_bun"

# Fastfetch [cite: 41]
command -v fastfetch >/dev/null 2>&1 && fastfetch
