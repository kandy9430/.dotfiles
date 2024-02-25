# mount OneDrive and OneDriveCrypt
rclone_mount () {
	echo -n "Rclone Password:"
	read -s password
	echo
	rclone --password-command "echo $password"  mount OneDrive: ~/OneDrive --daemon --vfs-cache-mode writes
	rclone --password-command "echo $password" mount OneDriveCrypt: ~/OneDriveCrypt --daemon --vfs-cache-mode writes
}

rclone_umount () {
	umount ~/OneDrive
	umount ~/OneDriveCrypt
}
