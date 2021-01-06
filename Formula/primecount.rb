class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/v6.1.tar.gz"
  sha256 "222bb0a17ad31f09296e2f3318a367230bcda2b82bec2613e339ba5c5e8558a0"
  license "BSD-2-Clause"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "libomp"
  depends_on "primesieve"

  def install
    mkdir "build" do
      # Build primecount using non-default LLVM compiler with libomp (OpenMP)
      system "cmake", "..", "-DCMAKE_CXX_COMPILER=" + Formula["llvm"].bin + "/clang++", "-DBUILD_SHARED_LIBS=ON", "-DBUILD_LIBPRIMESIEVE=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primecount", "1e10"
  end
end
