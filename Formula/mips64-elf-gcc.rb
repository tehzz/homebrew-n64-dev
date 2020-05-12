# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Mips64ElfGcc < Formula
  desc "GNU GCC C toolchain for N64 mips64-elf target"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-10.1.0/gcc-10.1.0.tar.xz"
  mirror "https://mirror.clarkson.edu/gnu/gcc/gcc-10.1.0/gcc-10.1.0.tar.xz" 
  sha256 "b6898a23844b656f1b68691c5c012036c2e694ac4b53a8918d4712ad876e7ea2"

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "mips64-elf-binutils"

  uses_from_macos "zlib"

  # BSD/Darwin sed cannot build gcc, or there will be this error:
  #   xgcc: error: addsf3: No such file or directory
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?format=multiple&id=62097
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66032
  # https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=235293
  # Patch to use awk instead
  patch :p0 do
    url "https://gcc.gnu.org/bugzilla/attachment.cgi?id=41380"
    sha256 "8a11bd619c2e55466688e328da00b387d02395c1e8ff4a99225152387a1e60a4"
  end

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.to_s.slice(/\d/)
    end
  end

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --infodir=#{info}
      --mandir=#{man}
      --libdir=#{lib}/mip64-elf-gcc/#{version_suffix}
      --target=mips64-elf
      --with-arch=vr4300
      --enable-languages=c 
      --without-headers 
      --with-newlib
      --with-gnu-as=mips64-elf-as
      --with-gnu-ld=mips64-elf-ld
      --enable-checking=release
      --enable-shared
      --enable-shared-libgcc
      --disable-decimal-float
      --disable-gold
      --disable-libatomic
      --disable-libgomp
      --disable-libitm
      --disable-libquadmath
      --disable-libquadmath-support
      --disable-libsanitizer
      --disable-libssp
      --disable-libunwind-exceptions
      --disable-libvtv
      --disable-multilib
      --disable-nls
      --disable-rpath
      --disable-static
      --disable-threads
      --disable-win32-registry
      --enable-lto
      --enable-plugin
      --enable-static
      --without-included-gettext
    ]

    mkdir "build" do
      system "../configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test gcc`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
