#!/bin/bash

CDIR="$(pwd)"

FR_BS_PATH="$CDIR"
FR_PK_PATH="$CDIR/../FlexRoad-Packages/"
FR_PATH="$CDIR/../FlexRoad/"

DEFAULTS=$(pwd)/.defaults
REMOTE=origin
BRANCH=flexroad-dev-1
BUILD_ID=0
TARGET=router

git_get_remote() {
	local path="$1"

	cd $path &> /dev/null
	git branch -r | sed "s/^\s\+\([^\/]\+\).*/\1/" | uniq
	cd - &> /dev/null
}


git_get_branch() {
	local path="$1"
	local remote="$2"

	cd $path &> /dev/null
	git branch -r | grep -v $remote | sed "s/^\s\+[^\/]\+\/\(.*\)/\1/"
	cd - &> /dev/null
}

git_get_allowed_remote() {
	_FIN_=`mktemp tmp.XXXXXXXXXX`
	TMP_BS=`mktemp tmp.XXXXXXXXXX`; git_get_remote $FR_BS_PATH | sort > $TMP_BS
	TMP_PK=`mktemp tmp.XXXXXXXXXX`; git_get_remote $FR_PK_PATH | sort > $TMP_PK
	TMP_FR=`mktemp tmp.XXXXXXXXXX`; git_get_remote $FR_PATH | sort > $TMP_FR
	comm -1 -2 $TMP_BS $TMP_PK &> $_FIN_
	comm -1 -2 $TMP_FR $_FIN_
	rm -f $TMP_BS $TMP_PK $_FIN_ $TMP_FR
}

git_get_allowed_branches() {
	local remote=$1

	_FIN_=`mktemp tmp.XXXXXXXXXX`
	TMP_BS=`mktemp tmp.XXXXXXXXXX`; git_get_branch $FR_BS_PATH $remote | sort > $TMP_BS
	TMP_PK=`mktemp tmp.XXXXXXXXXX`; git_get_branch $FR_PK_PATH $remote | sort > $TMP_PK
	TMP_FR=`mktemp tmp.XXXXXXXXXX`; git_get_branch $FR_PATH $remote | sort > $TMP_FR

	comm -1 -2 $TMP_BS $TMP_PK &> $_FIN_
	comm -1 -2 $TMP_FR $_FIN_
	rm -f $TMP_BS $TMP_PK $_FIN_ $TMP_FR
}

update_config() {
	local tmp=`mktemp tmp.XXXXXXXXXX`

	if [ -e $DEFAULTS ]; then
		rm $DEFAULTS
	fi

	echo REMOTE=$REMOTE >> $tmp
	echo BRANCH=$BRANCH >> $tmp
	echo BUILD_ID=$BUILD_ID >> $tmp
	echo TARGET=$TARGET >> $tmp

	mv $tmp $DEFAULTS
}

# Usage:

TARGETS=`ls -1 config-*.mk | sed -e "s/config-\(.*\).mk/\1/"`

ACTION=empty
CURR_BRANCH=`git branch | grep '*' | sed "s/\*\s//"`


[ -e $DEFAULTS ] && . $DEFAULTS
update_config

# choose action
case $1 in
	rootfs)
		BUILD_ID=$(($BUILD_ID+1))
		update_config
		make image TARGET=$TARGET
		;;
	initramfs)
		update_config
		make initramfs TARGET=$TARGET
		;;
	listremote)
		git_get_allowed_remote
		;;
	setremote)
		if git_get_allowed_remote | grep -E "^$2$" &> /dev/null; then
			REMOTE=$2
			update_config
		else
			echo Unknown remote "'"$2"'"
		fi
		;;
	getremote)
		echo $REMOTE
		;;
	getbranch)
		echo $BRANCH
		;;
	branches)
		git_get_allowed_branches $REMOTE
		;;
	setbranch)
		if git_get_allowed_branches $REMOTE | grep -E "^$2$" &> /dev/null; then
			BRANCH=$2
			update_config
		else
			echo Unknown branch "'"$2"'"
		fi
		;;
	switch)
		;;
	gettarget)
		echo $TARGET
		;;
	target)
		if echo $TARGETS | tr ' ' '\n' | grep -E "^$2$" &> /dev/null; then
			TARGET=$2
			update_config
		else
			echo Unknown target "'"$2"'"
		fi
		;;
	checkout)
		echo "... not implemented yet ..."
		;;
	tag)
		echo tag current configuration [$REMOTE/$BRANCH/$TARGET/$BUILD_ID]
		echo "... not implemented yet ..."
		;;
	*)
		if [ -e $FR_PATH/.config ]; then
			echo rebuild last configuration [$REMOTE/$BRANCH/$TARGET/$BUILD_ID]
			make build_rootfs TARGET=$TARGET
			make copy_rootfs TARGET=$TARGET
		else
			echo Please configure system first.
		fi
		;;
esac


exit 0

