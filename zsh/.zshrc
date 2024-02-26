#aliases
alias ll="ls -lha"
alias mv="mv -i"
alias mkdir="mkdir -p"
alias rmdir="rm -r"
alias vlc="open -a VLC"

#mkdir and cd combined
mcd() {
  mkdir -p "$1"
  cd "$1"
}

#cd and ll combined
cdll() {
	cd "$1"
	ll
}

#ssh with cockpit access
sshcockpit() {
	ssh "$1" -L 9090:"$1":9090
}

# rclone commands
# mount OneDrive and OneDriveCrypt
rclone_mount () {
	echo -n "Rclone Password: "
	read -s password
	echo
	rclone --password-command "echo $password" nfsmount OneDrive: ~/OneDrive --daemon --vfs-cache-mode writes
	rclone --password-command "echo $password" nfsmount OneDriveCrypt: ~/OneDriveCrypt --daemon --vfs-cache-mode writes
}

rclone_umount () {
	umount ~/OneDrive
	umount ~/OneDriveCrypt
}

#for organizing media libraries:
#mkdir for all files in directory
mkdir-for-all() {
	for name in *; do
		mkdir ${name%.*};
	done
}

#mv files into their respective directories
mv-all() {
	for name in *;
		if [[ ${name:(-4):4} == .* ]]; then
			mv $name ${name%.*};
		fi;
}

export DISPLAY=localhost:0
export EDITOR=vim
export VISUAL=vim
