class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/v7.2.tar.gz"
  sha256 "54c1eec33e665a780002dda20cf39ba0cefa8e846fdeda44734fb2265cba9257"
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
      # Because homebrew-primecount is currently a tab and not a regular homebrew package
      # the shared libprimecount.7.dylib won't be found when running the primecount binary
      # unless /opt/homebrew/Cellar/primecount/7.0/lib is added to DYLD_LIBRARY_PATH.
      # See issue: https://github.com/kimwalisch/primecount/issues/48
      # In order to workaround this issue we link libprimecount statically.
      on_macos do
        system "sed -i '' 's/primecount PRIVATE libprimecount/primecount PRIVATE libprimecount-static/g' ../CMakeLists.txt"
      end
      on_linux do
        system "sed -i 's/primecount PRIVATE libprimecount/primecount PRIVATE libprimecount-static/g' ../CMakeLists.txt"
      end

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
