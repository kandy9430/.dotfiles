# mount OneDrive and OneDriveCrypt
rclone_mount () {
	rclone mount OneDrive: ~/OneDrive --daemon --vfs-cache-mode writes
	rclone mount OneDriveCrypt: ~/OneDriveCrypt --daemon --vfs-cache-mode writes
}

rclone_umount () {
	umount ~/OneDrive
	umount ~/OneDriveCrypt
}
