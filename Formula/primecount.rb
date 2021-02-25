class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/v6.2.tar.gz"
  sha256 "51626a8b2500eb30cba171e1358f3eb589552c8a672babd4eb25e0c9ac054091"
  license "BSD-2-Clause"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "libomp"
  depends_on "primesieve"

  # In 2021 integer division is slow on most CPUs,
  # hence we use libdivide instead.
  libdivide_build_option = "-DWITH_LIBDIVIDE=ON"

  on_macos do
    if Hardware::CPU.arm?
      # Apple Silicon CPUs have very fast integer division
      libdivide_build_option = "-DWITH_LIBDIVIDE=OFF"
    end
  end
  
  def install
    mkdir "build" do
      # 1) Build primecount using non-default LLVM compiler with libomp (OpenMP)
      # 2) Homebrew does not allow compiling with -O2 or -O3, instead homebrew requires using -Os
      system "cmake", "..", "-DCMAKE_CXX_COMPILER=" + Formula["llvm"].bin + "/clang++", "-DCMAKE_CXX_FLAGS=-Os", "-DBUILD_SHARED_LIBS=ON", "-DBUILD_LIBPRIMESIEVE=OFF", libdivide_build_option, *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primecount", "1e10"
  end
end
