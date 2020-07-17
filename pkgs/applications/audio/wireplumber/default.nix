{ stdenv, fetchFromGitHub, fetchFromGitLab
, meson, ninja, pkgconfig, cmake
, glib, pipewire, gobject-introspection, gir-rs }:

let
  # Latest commit on master
  cpptoml = fetchFromGitHub {
    owner = "skystrife";
    repo = "cpptoml";
    rev = "fededad7169e538ca47e11a9ee9251bc361a9a65";
    sha256 = "0zlgdlk9nsskmr8xc2ajm6mn1x5wz82ssx9w88s02icz71mcihrx";
  };
in stdenv.mkDerivation rec {
  pname = "wireplumber";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = "wireplumber";
    rev = version;
    sha256 = "0pyvg1n3aq4mi7pxna7wjq5ipfaak51930vh360qypnbwvvg57aw";
  };

  postUnpack = ''
    mkdir -p $sourceRoot/subprojects/cpptoml
    cp -r ${cpptoml}/* $sourceRoot/subprojects/cpptoml
  '';

  postPatch = ''
    sed -i "s@(wireplumber_config_file)@(\'/etc/wireplumber/wireplumber.conf\')@" src/meson.build
    sed -i "s@(wireplumber_config_dir)@(\'/etc/wireplumber\')@" src/meson.build
  '';

  mesonFlags = [
    # needs hotdoc
    "-Ddoc=disabled"
  ];

  nativeBuildInputs = [ meson ninja pkgconfig cmake ];
  buildInputs = [ glib pipewire.dev gobject-introspection gir-rs ];
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";
}
