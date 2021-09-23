#!/bin/sh

up() {
	if ! grep "AIDBOX_AUTO_ADDED_LINE" /etc/hosts; then
		printf '127.0.0.1\thost.docker.internal # AIDBOX_AUTO_ADDED_LINE\n' >> /etc/hosts
	fi
}

down() {
	# TODO: implement
}

up
