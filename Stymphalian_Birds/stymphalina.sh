#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Help
help()
{
	echo "Set up the basic requirements of a project."
	echo "usage:	./script.sh [-r -m -l -h]"
	echo "NAME		- Your project's name"
	echo "LANGUAGE	- Your project's language (C)"
	echo "DIRECTORY	- Where should this project be created"
	echo "General options:"
	echo "-h		- Display this help message"
	echo "-g		- Prompt for custom .gitignore"
	echo "-r		- Start the project with a README.md"
	echo "-R		- Prompt for custom README.md"
	echo "-l		- Clone libft to project"
}

# Gitignore
gitignore()
{
	echo -e "${PURPLE}Enter the content of your .gitignore"
	echo -e "(press CTRL + D to finish):${NC}"
	cat >> $1/.gitignore
}

# Readme
readme()
{
	if [ "$2" == "-r" ]
	then
		echo -e "${PURPLE}Creating README.md..${NC}"
		touch $1/README.md
	elif [ "$2" == "-R" ]
	then
		echo -e "${PURPLE}Enter the content of your README.md"
		echo -e "(press CTRL + D to finish):${NC}"
		cat > $1/README.md
	fi
}

# Libft
libft()
{
	if [ "$2" == 1 ]
	then
		echo -e "${PURPLE}Copying libft.." 
		rm -rf $1/lib
		git clone https://github.com/jt-taylor/Libft.git $1/libft
	elif [ "$2" == 2 ]
	then
		echo -e "${RED}-l option only valid for C projects${NC}"
	fi
}

# Build minimun requirements for C project
build_c()
{
	if ! mkdir $dir ; then
		echo -e "${RED}"
		msg="There was a problem while creating the directory. ABORT!!"
		error "$msg"
	fi
	echo -e "${GREEN}Making structure in $dir"
	mkdir $dir/src
	mkdir $dir/includes
	mkdir $dir/lib
	# fix me once pushed
	#curl https://raw.githubusercontent.com/erredavila/hercules/master/stymphalian_birds/Makefile > $dir/Makefile
	echo ".DS_Store" > $dir/.gitignore
}

# Error
error()
{
	exit 1
}

# Check for help first
for i in $@; do 
	if [ "$i" = "-h" ]
	then
		help
		exit 0
	fi
done

# Get the project NAME
while [ "$prename" == "" ]
do
	echo -e "${BLUE}How shall I call it?${NC}"
	echo -n "Name: "
	read prename
done
name=$(echo $prename | tr -d ' ')

# Get the project STRUCTURE
while (( language != 1 && language != 2 ))
do
	echo -e "${BLUE}Confirm C project"
	echo "1. C"
	echo -e "${NC}"
	read language
done

# Get the project DIRECTORY
while [ "$directory" == "" ]
do
	echo -e "${BLUE}Where should I make it?${NC}"
	echo -n "~/"
	read directory
done

echo -e "${NC}"

if [ "${directory: -1}" == "/" ]
then
	dir="$HOME/$directory$name"
else
	dir="$HOME/$directory/$name"
fi

# Create minimun requirements for the project
if [ "$language" == 1 ]
then
	build_c "$directory"
elif [ "$language" == 2 ]
then
	build_html "$directory"
fi

# Handle extra params
for i in $@; do 
	if [ "$i" = "-g" ]
	then
		echo -e "${NC}"
		gitignore "$dir"
	elif [ "$i" = "-r" ] || [ "$i" = "-R" ]
	then
		echo -e "${NC}"
		readme "$dir" "$i"
	elif [ "$i" = "-l" ]
	then
		echo -e "${NC}"
		libft "$dir" "$language"
	fi
done

echo -e -n "${YELLOW}"
echo -e "Project base made successfully made!\n"
