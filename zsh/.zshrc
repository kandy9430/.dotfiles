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

export DISPLAY=localhost:0

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

