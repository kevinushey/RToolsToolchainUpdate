#!/usr/bin/env bash
set -e

SRC_FILE=$PACKAGE_DIR/gcc-${GCC_VERSION}${MY_REVISION}.tar.zx
if [ "$HOST" == "x86_64-w64-mingw32" ] || [ "$HOST" == "i686-w64-mingw32" ]
then
    BIN_COMPRESS="zip -r9X"
    BIN_FILE=$PACKAGE_DIR/$TARGET-gcc-${GCC_VERSION}${MY_REVISION}.zip
else
    if [ "$HOST" == "x86_64-linux-gnu" ] || [ "$HOST" == "i686-linux-gnu" ]
    then
        PLATFORM_SUFFIX="linux"
    elif [ "$HOST" == "x86_64-apple-darwin10" ] || [ "$HOST" == "i686-apple-darwin10" ]
    then
        PLATFORM_SUFFIX="mac"
    elif [ "$HOST" == "i686-pc-cygwin" ]
    then
        PLATFORM_SUFFIX="cygwin"
    else
        echo "-> unknown host set: $HOST"
    fi
    BIN_COMPRESS="tar  -Jcf"
    BIN_FILE=$PACKAGE_DIR/$TARGET-gcc-${GCC_VERSION}${MY_REVISION}-${PLATFORM_SUFFIX}.tar.zx
fi

if [ -f $BIN_FILE ]
then
    echo "--> Binary file already exists"
else
    echo "--> Zipping binaries"
    cd $PREFIX/..
    # Base package
    echo "---> Base package"
    $BIN_COMPRESS $BIN_FILE $SHORT_NAME > $LOG_DIR/zipping.log
fi

if [ -f $SRC_FILE ]
then
    echo "--> Source file already exists"
else
    echo "--> Zipping sources"
    cd $TOP_DIR
    tar  -Jcf $SRC_FILE --exclude='*.git' --exclude='*.svn' src scripts patches *.sh
fi

cd $TOP_DIR

