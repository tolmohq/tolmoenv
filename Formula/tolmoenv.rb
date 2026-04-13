class Tolmoenv < Formula
  desc "Version manager for the Tolmo CLI"
  homepage "https://github.com/tolmohq/tolmoenv"
  url "https://github.com/tolmohq/tolmoenv/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "dedd4106277109364724bb6bc7f31cc4b0a921a6b28405c2bca750b27507737b"
  head "https://github.com/tolmohq/tolmoenv.git", branch: "main"

  conflicts_with "tolmo", because: "tolmoenv symlinks tolmo binaries"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/tolmo"
    bin.install_symlink libexec/"bin/tolmoenv"
  end

  test do
    system bin/"tolmoenv", "version"
  end
end
