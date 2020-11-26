class QemuIrix < Formula
  desc "adding Irix userland emulation to QEMU"
  homepage ""
  url "https://github.com/tehzz/qemu-irix/archive/v2.11.50-darwin.tar.gz"
  sha256 "e1db7eaaf6c12ea446c08e3e2ecced4873a897bb73be9f80f9e66a6a932d0c25"

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gettext"

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.to_s.slice(/\d/)
    end
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --libdir=#{lib}/qemu-irix/#{version_suffix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --target-list=irix-darwin-user
      --disable-vnc
      --disable-sdl
      --disable-gtk
      --disable-cocoa
      --disable-opengl
      --disable-capstone
      --disable-hax
      --disable-hvf
      --disable-tools
    ]
    
    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    system "qemu-irix", "--version"
  end
end
