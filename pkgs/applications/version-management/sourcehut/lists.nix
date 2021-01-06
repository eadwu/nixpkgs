{ lib, fetchgit, buildPythonPackage
, srht, asyncpg, aiosmtpd, pygit2, emailthreads }:

buildPythonPackage rec {
  pname = "listssrht";
  version = "0.48.1";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    rev = version;
    sha256 = "pwZGNVkUNxEE1As/m9Ngc7ENU4GBtetHakQLqeX9zZM=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pygit2
    asyncpg
    aiosmtpd
    emailthreads
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/lists.sr.ht";
    description = "Mailing list service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
