class Tolmoenv < Formula
  desc "Version manager for the Tolmo CLI"
  homepage "https://github.com/tolmohq/tolmoenv"
  url "https://github.com/tolmohq/tolmoenv/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ae2cd61f5cf673fde2d3ac212155b82680319accaddf1bcb9dd8de433610518a"
  head "https://github.com/tolmohq/tolmoenv.git", branch: "main"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/tolmo"
    bin.install_symlink libexec/"bin/tolmoenv"
  end

  test do
    system bin/"tolmoenv", "version"
  end
end
