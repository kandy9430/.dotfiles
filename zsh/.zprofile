eval "$(/opt/homebrew/bin/brew shellenv)"

# rbenv
eval "$(rbenv init - zsh)"
# Add rbenv shims to PATH
export PATH="$HOME/.rbenv/shims:$PATH"



#SMLNJ
export PATH=/usr/local/smlnj/bin:"$PATH"
