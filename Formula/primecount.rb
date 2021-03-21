class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/v6.4.tar.gz"
  sha256 "3c7ede9344b908a2be139b8d015cd5f36adfa69a9069199af556f6a32d3a7958"
  license "BSD-2-Clause"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "libomp"
  depends_on "primesieve"

  def install
    # In 2021 integer division is slow on most CPUs,
    # hence by default we use libdivide instead.
    use_libdivide = "ON"
    
    on_macos do
      if Hardware::CPU.arm?
        # Apple Silicon CPUs have very fast integer division
        use_libdivide = "OFF"
      end
    end
    
    mkdir "build" do
      # 1) Build primecount using non-default LLVM compiler with libomp (OpenMP)
      # 2) Homebrew does not allow compiling with -O2 or -O3, instead homebrew requires using -Os
      system "cmake", "..", "-DCMAKE_CXX_COMPILER=" + Formula["llvm"].bin + "/clang++", "-DCMAKE_CXX_FLAGS=-Os", "-DBUILD_SHARED_LIBS=ON", "-DBUILD_LIBPRIMESIEVE=OFF", "-DWITH_LIBDIVIDE=#{use_libdivide}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primecount", "1e10"
  end
end
