{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "stalld";
  version = "2020-08-28";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/stalld/stalld.git";
    rev = "abe5fe5000aa8d03481ff26750281cb66e0b17eb";
    sha256 = "140wckbfrhwms53v4a614lmhi95havg4c7b5gicyv0gjw7zmg8l9";
  };

  postPatch = ''
    sed -i 's@/usr@@g' Makefile
    sed -i 's@/usr@@g' redhat/Makefile
  '';

  enableParallelBuilding = true;

  installFlags = [ "DESTDIR=${placeholder "out"}" ];
  postInstall = ''
    (cd redhat && make $installFlags install)
  '';
}
