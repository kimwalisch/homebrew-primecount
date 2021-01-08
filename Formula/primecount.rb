class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/v6.2.tar.gz"
  sha256 "51626a8b2500eb30cba171e1358f3eb589552c8a672babd4eb25e0c9ac054091"
  license "BSD-2-Clause"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      # Build primecount using non-default LLVM compiler with libomp (OpenMP)
      system "cmake", "..", "-DCMAKE_CXX_COMPILER=" + Formula["llvm"].bin + "/clang++", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primecount", "1e10"
  end
end
