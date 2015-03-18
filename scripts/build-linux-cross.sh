
TOP_DIR=$(dirname $(readlink -f $0))

SHOW_LOG_ON_ERROR=yes
. ./defaults

. functions/args
. functions/setup_env

. functions/common_funcs
. functions/download
. functions/build_package
. functions/build_toolchain

printf "> Setting up directories.\n"
setup_environment

. $TOOLCHAIN_DEFINITION
. flows/crossbuild

case "$CROSS_BUILD" in
  x86_64-linux*)
    shorthost="linux64"
    host="x64_64-unknown-linux-gnu"
    ;;
  i686-linux*)
    shorthost="linux32"
    #host="i686-unknown-linux-gnu"
    host="i686-linux-gnu"
    ;;
  *)
    printf "Error: building on $CROSS_BUILD won't work!\n"
    exit 1
    ;;
esac

for ARCHITECTURE in ${BUILD_ARCHITECTURES[@]}; do
	echo $ARCHITECTURE
	[[ $ARCHITECTURE == x32 ]] && {

		shortname="mingw32"
		abisuffix="-sjlj"
		BUILD=i686-linux-gnu
		TARGET=i686-w64-mingw32
		[[ $USE_MULTILIB == yes ]] && {
			ENABLE_TARGETS=i686-w64-mingw32,x86_64-w64-mingw32
		} || {
			ENABLE_TARGETS=i686-w64-mingw32
		}
	  gcc_exception_opts="--enable-sjlj-exceptions --disable-dw2-exceptions"
		mingw_opts="--enable-lib32 --disable-lib64"
		#export PATH=$LIBS_DIR/bin:$x32_HOST_MINGW_PATH/bin:$PREFIX/bin:$ORIGINAL_PATH
	} || {
		shortname="mingw64"
		abisuffix="-sjlj"
		#abisuffix="-seh"
		BUILD=i686-linux-gnu
		TARGET=x86_64-w64-mingw32
		[[ $USE_MULTILIB == yes ]] && {
			ENABLE_TARGETS=x86_64-w64-mingw32,i686-w64-mingw32
		} || {
			ENABLE_TARGETS=x86_64-w64-mingw32
		}
	  gcc_exception_opts="--enable-sjlj-exceptions --disable-dw2-exceptions"
		mingw_opts="--enable-lib64 --disable-lib32"
		#export PATH=$LIBS_DIR/bin:$x64_HOST_MINGW_PATH/bin:$PREFIX/bin:$ORIGINAL_PATH
	}
	longname=${shorthost}${shortname}
	build_toolchain "${longname}" || exit 1
done

exit

