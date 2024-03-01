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
rclone-mount () {
	echo -n "Rclone Password: "
	read -s password
	echo
	rclone --password-command "echo $password" nfsmount OneDrive: ~/OneDrive --daemon --vfs-cache-mode writes
	rclone --password-command "echo $password" nfsmount OneDriveCrypt: ~/OneDriveCrypt --daemon --vfs-cache-mode writes
}

rclone-umount () {
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

dufs-upload() {
	doc_dir="Documents/"
	start_dir=$(pwd)

	echo -n "DUFS username: "
	read username
	echo -n "DUFS password: "
	read -s password
	echo 

	echo "Choose from following directories to upload, or press enter to upload all"
	find ~/$doc_dir -maxdepth 1 -type d -printf "%P\n"
	echo -n ": "
	read directory

	#find ~/$doc_dir$directory/ -type f -printf "%P\n"
	#echo "Documents/$directory/"
	
	cd ~/$doc_dir$directory	
 	find ~/$doc_dir$directory/ -type f -printf "%P\n" | xargs -I % curl -v -u $username:$password -T % http://10.8.1.1:5000/andrew/Documents/$directory/%
	cd $start_dir
}

export DISPLAY=localhost:0
export EDITOR=vim
export VISUAL=vim

# Makes GNU find, locate, updatedb, and xargs the default.
# Without this, need to preface all these commands with "g", or MacOS versions will be used
PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
