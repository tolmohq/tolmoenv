class Tolmoenv < Formula
  desc "Version manager for the Tolmo CLI"
  homepage "https://github.com/tolmohq/tolmoenv"
  url "https://github.com/tolmohq/tolmoenv/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "e06567cfb02c59646e2dcec1e60522e44a5a66a63187a1d3dde4bb8336f88fae"
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
