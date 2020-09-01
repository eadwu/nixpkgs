{ stdenv, fetchurl
, kernel }:

stdenv.mkDerivation rec {
  pname = "lkrg";
  version = "0.8";

  src = fetchurl {
    url = "https://www.openwall.com/lkrg/${pname}-${version}.tar.gz";
    sha256 = "0cz4v8m5kdchckkyghmg8aar5afs8c00jc2spgmqbpiah1fc92p0";
  };

  postPatch = ''
    sed -e 's@/lib/modules/.*@${kernel.dev}/lib/modules/${kernel.modDirVersion}/build@' \
      -e 's@$(P_PWD)/$(P_BOOTUP_SCRIPT) install@@' \
      -e 's@depmod.*@@' \
      -i Makefile

    sed -i 's@do_seccomp@prctl_set_seccomp@' src/modules/exploit_detection/syscalls/p_seccomp/p_seccomp.c
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  installFlags = [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  enableParallelBuilding = true;
}
