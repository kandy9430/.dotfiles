dufs-upload() {
	doc_dir="Documents/"
	start_dir=$(pwd)

	echo "Choose from following directories to upload, or press enter to upload all"
	find ~/$doc_dir -maxdepth 1 -type d -printf "%P\n"
	echo -n ": "
	read directory

	#find ~/$doc_dir$directory/ -type f -printf "%P\n"
	#echo "Documents/$directory/"
	
	cd ~/$doc_dir$directory	
 	find ~/$doc_dir$directory/ -type f -printf "%P\n" | xargs -I % curl -v -u andrew:DUFS@ndrew -T % http://10.8.1.1:5000/andrew/Documents/$directory/%
	cd $start_dir
}
