
TOP_DIR=$(dirname $(readlink -f $0))

SHOW_LOG_ON_ERROR=yes
. ./defaults

. functions/args
. functions/setup_env

. functions/common_funcs
. functions/download
. functions/build_toolchain
. functions/build_package

printf "> Setting up directories.\n"
setup_environment

. $TOOLCHAIN_DEFINITION
. flows/nativebuild

SAVE_PATH=$PATH

for CROSS_ARCHITECTURE in ${BUILD_ARCHITECTURES[@]}; do
	echo $CROSSARCHITECTURE

	[[ $CROSS_ARCHITECTURE == x32 ]] && {
		shortcross="linux32"
		host="i686-w64-mingw32"
		shorthost="mingw32"
		BUILD=i686-linux-gnu
		IA32_TARGET=i686-w64-mingw32
		X64_TARGET=x86_64-w64-mingw32
		x64BUILD=x86_64-linux-gnu
		x64_host="x86_64-w64-mingw32"

	} || {
		shortcross="linux32"
		shorthost="mingw64"
		x64BUILD=i686-linux-gnu
		IA32_TARGET=x86_64-w64-mingw32
		X64_TARGET=x86_64-w64-mingw32
		x64_host="x86_64-w64-mingw32"
	}

	for NATIVE_ARCHITECTURE in ${NATIVE_ARCHITECTURES[@]}; do
	[[ $NATIVE_ARCHITECTURE == x32 ]] && {
		shortname="mingw32"
		gcc_exception_opts="--enable-sjlj-exceptions --disable-dw2-exceptions"
		abisuffix="-sjlj"
		TARGET=$IA32_TARGET
	} || {
		shortname="mingw64"
		gcc_exception_opts="--enable-sjlj-exceptions --disable-dw2-exceptions"
		abisuffix="-sjlj"
		#abisuffix="-seh"
		TARGET=$X64_TARGET
		BUILD=$x64BUILD
		host=$x64_host
	}

	longname="${shorthost}${shortname}"
	ENABLE_TARGETS=${TARGET}
	crosstoolchain=$shortcross$shortname

  prereqabisuffix="$abisuffix"

	pushd $CROSSCOMPILERS_DIR > /dev/null
	rm -fr $shortname
	$DECOMPRESS "$PACKAGE_DIR/${crosstoolchain}_gcc-${gcc_version}.toolchain${PACKAGE_EXT}" || exit 1
	popd > /dev/null
	PATH=$CROSSCOMPILERS_DIR/$shortname/bin:$SAVE_PATH
	build_toolchain "${longname}" || exit 1
done
done

exit

