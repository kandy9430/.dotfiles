alias ll="ls -lha"
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
