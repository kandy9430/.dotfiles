# mount OneDrive and OneDriveCrypt
rclone-mount () {
	echo -n "Rclone Password:"
	read -s password
	echo
	rclone --password-command "echo $password"  mount OneDrive: ~/OneDrive --daemon --vfs-cache-mode writes
	rclone --password-command "echo $password" mount OneDriveCrypt: ~/OneDriveCrypt --daemon --vfs-cache-mode writes
}

rclone-umount () {
	umount ~/OneDrive
	umount ~/OneDriveCrypt
}
