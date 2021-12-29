class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  # This is a beta version of primecount-7.3. primecount-7.3 can now be built using
  # the default AppleClang C/C++ compiler. This significantly speeds up the installation
  # as homebrew does not need to download + install LLVM/Clang anymore.
  url "https://github.com/kimwalisch/primecount/archive/6eaddf2edde8ed3bf7d3ee2b0dc08fd38bf52334.tar.gz"
  sha256 "2d3939f746ecf7b8e54f3b956beb9791c5f9b9de78ac295c11f103684bdfcd9e"
  license "BSD-2-Clause"

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "primesieve"

  def install
    # In 2021 integer division is slow on most CPUs,
    # hence by default we use libdivide instead.
    use_libdivide = "ON"
    use_div32 = "ON"

    on_macos do
      if Hardware::CPU.arm?
        # Apple Silicon CPUs have very fast integer division
        use_libdivide = "OFF"
        use_div32 = "OFF"
      end
    end

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", "-DBUILD_LIBPRIMESIEVE=OFF", "-DWITH_LIBDIVIDE=#{use_libdivide}", "-DWITH_DIV32=#{use_div32}", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/primecount", "1e10"
  end
end
