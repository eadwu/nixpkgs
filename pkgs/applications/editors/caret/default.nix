{ stdenv, fetchurl
, atomEnv, systemd, fontconfig, autoPatchelfHook
, dpkg, makeWrapper, wrapGAppsHook
, glib, gtk3, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "caret-beta";
  version = "4.0.0-rc23";

  src = fetchurl {
    url = "https://github.com/careteditor/releases-beta/releases/download/${version}/caret-beta.deb";
    sha256 = "0vjs27lgnkv61ix5dz5pa9h4krcssx5lh8b1mbjax50yl210q2ff";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    wrapGAppsHook

    atomEnv.packages
    autoPatchelfHook
  ];

  buildInputs = [
    glib
    gtk3
    gsettings-desktop-schemas
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share
    {
      cd usr
      cp -r share/{doc,icons,applications} $out/share/
      cp -r share/caret-beta $out/lib/caret-beta
    }

    ln -s $out/lib/caret-beta/resources/app.asar.unpacked/bin/caret--linux.sh $out/bin/caret-beta

    sed -i "s@{{name}}@caret-beta@g" $out/bin/caret-beta

    # Override the previously determined CARET_PATH with the one we know to be correct
    sed -i "/ELECTRON=/iCARET_PATH='$out/lib/caret-beta'" $out/bin/caret-beta
    grep -q "CARET_PATH='$out/lib/caret-beta'" $out/bin/caret-beta # check if sed succeeded

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ systemd fontconfig ]})

    chmod +x $out/lib/caret-beta
  '';

  meta = with stdenv.lib; {
    homepage = "https://caret.io/";
    description = "A Markdown editor that stands out with its clean interface, productivity features and obsessive attention to detail.";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
