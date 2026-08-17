if status is-interactive
    set -g fish_greeting ""
    
    fastfetch

    oh-my-posh init fish --config /home/puppy/.config/ohmyposh/pywal.json | source
end

fish_add_path /home/puppy/.spicetify
export PATH="$HOME/.local/bin:$PATH"
