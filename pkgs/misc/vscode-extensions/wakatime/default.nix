{ lib
, wakatime, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-wakatime";
      publisher = "WakaTime";
      version = "14.0.0";
      sha256 = "1d5jdsvdqhpx2nf2qiv7jb3mzhx1jc2svf33yf9xjjp3bf251jbg";
    };

    meta = with lib; {
      description = ''
        Visual Studio Code plugin for automatic time tracking and metrics generated
        from your programming activity
      '';
      license = licenses.bsd3;
    };
  }
