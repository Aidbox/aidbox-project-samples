#!/bin/sh

if [ -z "$2" ]

if ! [ -f aidbox-project/.type ]; then
	echo "No type specified, removing project"
	make cleanup
	make 
fi

read project_type < ./aidbox-project

if [ "$2" != "$project_type" ]
	echo "Switching from type $project_type to $2"
	make cleanup
fi
