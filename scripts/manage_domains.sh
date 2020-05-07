#! /bin/bash
DOMAINS_DIR="/var/www/"

# Check permissions
check_permissions() {
	if [ "$EUID" -ne 0 ]
  		then echo "Please run with sudo"
  		exit
	fi
}

# Quit
quit() {
	clear
	exit 0
}

# List domains
list() {
	ls $DOMAINS_DIR | nl | column -t

	echo
	next
}

# Create https certificate
https() {
	echo
	printf "%s" "Do you want to enable https (Y/N)? "
	read INPUT
	if [ "x$INPUT" = "xy" ] || [ "x$INPUT" = "xY" ] ; then
		echo
		certbot --nginx -d $1
	else
		return
	fi
}

# Add new domain
add() {
	clear
	printf "%s" "Enter a domain name you want (for example cactus.vision): "
	read NAME

	# Check is name has been already taken
	while [ -d $DOMAINS_DIR/$NAME ]; do
		echo $NAME 'has been already taken'
		printf "%s" "Eneter another domain name you want: "
		read NAME
	done

	# Create site dir and change permissions
	mkdir -p $DOMAINS_DIR/$NAME/html
	cp $DOMAINS_DIR/html/index.nginx-debian.html $DOMAINS_DIR/$NAME/html/index.html
	chown -R gitlab:gitlab $DOMAINS_DIR/$NAME/html
	chmod -R 755 $DOMAINS_DIR/$NAME

	# Create server block
	touch /etc/nginx/sites-available/$NAME
	echo -e "server {\n\tlisten 80;\n\tlisten [::]:80;\n\n\troot /var/www/$NAME/html;\n\tindex index.html;\n\n\tserver_name $NAME;\n}" > /etc/nginx/sites-available/$NAME

	# Enable domain
	ln -s /etc/nginx/sites-available/$NAME /etc/nginx/sites-enabled/

	# Create https certificate
	https $NAME

	# Reload nginx
	systemctl reload nginx

	echo
	next
}

# Coninue or exit
next() {
	printf "%s" "Do you want to continue (Y/N)? "
	read INPUT
	if [ "x$INPUT" = "xy" ] || [ "x$INPUT" = "xY" ] ; then
		clear
		menu
	else
		quit
	fi
}

# Show menu
menu() {
	check_permissions
	clear
	echo
	echo "************************** Domain Manager **************************"
	echo "  1    List existing domains"
	echo "  2    Add new domaim"
	echo "  3    Quit"
	echo "********************************************************************"
	echo
	printf "%s" "Please make your decision: "
	read ANSWER

	case "$ANSWER" in
		1)   list ;;
		2)   add ;;
		3)   quit ;;
		*)
			echo "Unknown command: '$ANSWER'"
			menu
		;;
	esac
}

menu
