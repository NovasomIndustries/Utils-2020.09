# $1 = error
# $2 = text message
exit_if_error() {
	if [ "$1" = "1" ]; then
		echo "\e[31m${2} reported error\e[39m"
		echo "1" > /tmp/result
		exit 1
	else
		echo "\e[32mFunction ${2} completed successfully on `date`\e[39m"
	fi
}

exit_ok() {
	echo "0" > /tmp/result
	exit 0
}

clear_resfile() {
	rm -f /tmp/result
}
