{ lib, stdenv, fetchFromGitHub, wrapGAppsHook
, autoconf, autoconf-archive, automake, gettext, intltool, libtool, pkg-config
, libICE, libSM, libXScrnSaver, libXtst, cheetah
, gobject-introspection, glib, glibmm, gtkmm3, atk, pango, pangomm, cairo
, cairomm , dbus, dbus-glib, gdome2, gstreamer, gst-plugins-base
, gst-plugins-good, libsigcxx, boost, python3Packages }:

stdenv.mkDerivation rec {
  pname = "workrave";
  version = "1.10.44";

  src = fetchFromGitHub {
    sha256 = "sha256-A4UX6QclKT0ZNU7qP+h/Wkocj920SggJYhOS5PDBkYw=";
    rev = with lib;
      "v" + concatStringsSep "_" (splitVersion version);
    repo = "workrave";
    owner = "rcaelers";
  };

  nativeBuildInputs = [
    autoconf autoconf-archive automake gettext intltool libtool pkg-config wrapGAppsHook
  ];
  buildInputs = [
    libICE libSM libXScrnSaver libXtst cheetah
    gobject-introspection glib glibmm gtkmm3 atk pango pangomm cairo cairomm
    dbus dbus-glib gdome2 gstreamer gst-plugins-base gst-plugins-good libsigcxx
    boost python3Packages.python python3Packages.jinja2
  ];

  preConfigure = "./autogen.sh";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A program to help prevent Repetitive Strain Injury";
    longDescription = ''
      Workrave is a program that assists in the recovery and prevention of
      Repetitive Strain Injury (RSI). The program frequently alerts you to
      take micro-pauses, rest breaks and restricts you to your daily limit.
    '';
    homepage = "http://www.workrave.org/";
    downloadPage = "https://github.com/rcaelers/workrave/releases";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prikhi ];
    platforms = platforms.linux;
  };
}
