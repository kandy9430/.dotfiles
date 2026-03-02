dufs-upload() {
	doc_dir="Documents/"
	start_dir=$(pwd)

	echo -n "DUFS username: "
	read username
	echo -n "DUFS password: "
	read -s password
	echo 
	echo -n "Choose from following directories to upload, or press enter to upload all"
	find ~/$doc_dir -maxdepth 1 -type d -printf "%P\n"
	echo -n ": "
	read directory

	#find ~/$doc_dir$directory/ -type f -printf "%P\n"
	#echo "Documents/$directory/"
	
	cd ~/$doc_dir$directory	
 	find ~/$doc_dir$directory/ -type f -printf "%P\n" | xargs -I % curl -v -u $username:$password -T % "http://10.8.1.1:5000/andrew/Documents/$directory/%"
	cd $start_dir
}

alias dufs-local="sudo docker run -v /run/media/atkeane/X9\ Pro/mycloud:/data -p 127.0.0.1:80:5000 --rm sigoden/dufs /data -A"
