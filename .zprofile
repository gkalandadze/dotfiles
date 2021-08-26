export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

eval `keychain --eval --agents ssh id_ed25519`