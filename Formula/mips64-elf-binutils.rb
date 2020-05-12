class Mips64ElfBinutils < Formula
  desc "GNU binutils for N64 mip64-elf target"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.34.tar.xz" 
  sha256 "f00b0e8803dc9bab1e2165bd568528135be734df3fabf8d0161828cd56028952"

  depends_on "gettext"
  
  uses_from_macos "zlib"

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.to_s.slice(/\d/)
    end
  end

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --infodir=#{info}
      --mandir=#{man}
      --libdir=#{lib}/mip64-elf-binutils/#{version_suffix}
      --target=mips64-elf
      --with-arch=vr4300
      --enable-64-bit-bfd
      --enable-plugins
      --enable-shared
      --disable-gold
      --disable-multilib
      --disable-nls
      --disable-rpath
      --disable-static
      --disable-werror
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
    # software. Run the test with `brew test binutils`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
