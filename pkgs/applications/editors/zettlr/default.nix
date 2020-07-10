{ stdenv, fetchurl
, mesa, libdrm, atomEnv
, dpkg, cpio, makeWrapper, wrapGAppsHook, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "zettlr";
  version = "1.7.1";

  src = fetchurl {
    url = "https://github.com/Zettlr/Zettlr/releases/download/v${version}/Zettlr-${version}-amd64.deb";
    sha256 = "0wylkkx6p9p3hwf50xr0s1kjphld0a64m8gfm438lhg2ypla8q93";
  };

  nativeBuildInputs = [ dpkg makeWrapper wrapGAppsHook ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    dpkg --fsys-tarfile $src | tar --extract

    mkdir -p $out
    cp -r usr/share $out
    cp -r opt/Zettlr $out/share

    mkdir -p $out/bin
    ln -s $out/share/Zettlr/zettlr $out/bin/zettlr

    runHook postInstall
  '';

  preFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/share/Zettlr:${atomEnv.libPath}:${stdenv.lib.makeLibraryPath [ mesa libdrm ]}" \
      $out/share/Zettlr/zettlr
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "A markdown editor for writing academic texts and taking notes";
    homepage = "https://www.zettlr.com";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
