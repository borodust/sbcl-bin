#!/usr/bin/env bash

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ -z  $1 ]] ; then
   echo "Version is not provided!"
   exit 1;
fi

SBCL_URL=https://github.com/sbcl/sbcl/archive/sbcl-$1.tar.gz
SBCL_ARCHIVE=/tmp/sbcl.tar.gz
SBCL_PATH=$WORK_DIR/sbcl

download () {
    echo "Downloading $1 into $2"
    mkdir -p "$(dirname $2)"
    if curl --no-progress-bar -o $2 -L $1; then
        return 0;
    else
        echo "Couldn't download from $1"
        exit 1;
    fi
}

inflate () {
    echo "Inflating $1 into $2"
    mkdir -p $2
    if tar -C $2 --strip-components=1 -xf $1; then
       return 0;
    else
        echo "Failed to inflate $1"
        exit 1;
    fi
}

download $SBCL_URL $SBCL_ARCHIVE
inflate $SBCL_ARCHIVE $SBCL_PATH


cd $WORK_DIR/sbcl					\
    && echo "\"$1\"" > version.lisp-expr		\
    && ./make.sh --fancy

cd $WORK_DIR/sbcl && tar -czf sbcl-$1.tar.gz sbcl/
