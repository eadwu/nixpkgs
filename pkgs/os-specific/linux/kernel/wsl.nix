{ lib, buildLinux, fetchFromGitHub
, version ? null
, structuredExtraConfig ? {}
, extraMeta ? {}
, argsOverride ? {}
, ... } @ args:

let
  branch = lib.versions.majorMinor version;
in buildLinux (args // {
  inherit version;

  modDirVersion = "${lib.versions.pad 3 version}.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "WSL2-Linux-Kernel";
    rev = "linux-msft-wsl-${version}.1";
    sha256 = "sha256-Ogce975l7yrca047+/nm+I5Bm8EMyzd+FdszzpAQ6NM=";
  };

  # extraMakeFlags = [ "KCONFIG_CONFIG=Microsoft/config-wsl" ];
  prePatch = ''
    cp Microsoft/config-wsl .config
  '';

  structuredExtraConfig = with lib.kernel; {
    # DRM_VIRTIO_GPU = yes;
  } // structuredExtraConfig;

  extraMeta = extraMeta // {
    inherit branch;
  };
} // argsOverride)
