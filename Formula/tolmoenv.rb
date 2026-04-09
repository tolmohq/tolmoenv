class Tolmoenv < Formula
  desc "Version manager for the Tolmo CLI"
  homepage "https://github.com/tolmohq/tolmoenv"
  url "https://github.com/tolmohq/tolmoenv/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "33ee55573b9f4c93544568ef91b7dfc5fbf2c5c50caa8069807a20da461c16fc"
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
