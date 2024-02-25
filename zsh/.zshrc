#aliases
alias ll="ls -lha"
alias mv="mv -i"
alias mkdir="mkdir -p"
alias rmdir="rm -r"

#mkdir and cd combined
mcd () {
  mkdir -p "$1"
  cd "$1"
}

#cd and ll combined
cdll () {
	cd "$1"
	ll
}

# rclone commands
# mount OneDrive and OneDriveCrypt
rclone_mount () {
	rclone mount OneDrive: ~/OneDrive --daemon --vfs-cache-mode writes
	rclone mount OneDriveCrypt: ~/OneDriveCrypt --daemon --vfs-cache-mode writes
}

rclone_umount () {
	umount ~/OneDrive
	umount ~/OneDriveCrypt
}

export DISPLAY=localhost:0

