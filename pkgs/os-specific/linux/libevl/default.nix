{ stdenv, fetchgit
, kernel, cpio }:

stdenv.mkDerivation rec {
  pname = "libevl";
  version = "r21";

  src = fetchgit {
    url = "https://git.evlproject.org/libevl.git";
    rev = version;
    sha256 = "094v6n5qsx7p51405rcpgcypqx711z5dpkkm67p61fbx02s4d308";
  };

  postPatch = ''
    patchShebangs utils
    sed -i 's@/bin/pwd@pwd@' config.mk
    sed -i 's@test -r $(UAPI)/Kbuild@true@' include/Makefile
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [
    cpio
  ];

  makeFlags = kernel.makeFlags ++ [
    "O=$(PWD)"
    "ARCH=x86"
    "UAPI=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
    "DESTDIR=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  checkPhase = ''
    $out/bin/evl test
  '';
}
