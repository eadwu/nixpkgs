{ stdenv, fetchFromGitHub, fetchpatch
, cmake, pkgconfig, SDL2, SDL, SDL2_ttf, openssl, spice-protocol, fontconfig
, libX11, freefont_ttf, nettle, libconfig, wayland, libpthreadstubs, libXdmcp
, libXfixes, libbfd, libffi, expat, libXi
}:

stdenv.mkDerivation rec {
  pname = "looking-glass-client";
  version = "2020-07-17";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = "bd42445ea751dafe8b6ce7a49fd2169a29b07b10";
    sha256 = "1ivnkmgrp11symdqibsf77p8qs8rwlc48g2pzyz30p886k51yg8s";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    SDL SDL2 SDL2_ttf openssl spice-protocol fontconfig
    libX11 freefont_ttf nettle libconfig wayland libpthreadstubs
    libXdmcp libXfixes libbfd cmake libffi expat libXi
  ];

  enableParallelBuilding = true;

  sourceRoot = "source/client";

  installPhase = ''
    mkdir -p $out/bin
    mv looking-glass-client $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A KVM Frame Relay (KVMFR) implementation";
    longDescription = ''
      Looking Glass is an open source application that allows the use of a KVM
      (Kernel-based Virtual Machine) configured for VGA PCI Pass-through
      without an attached physical monitor, keyboard or mouse. This is the final
      step required to move away from dual booting with other operating systems
      for legacy programs that require high performance graphics.
    '';
    homepage = "https://looking-glass.hostfission.com/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.alexbakker ];
    platforms = [ "x86_64-linux" ];
  };
}
