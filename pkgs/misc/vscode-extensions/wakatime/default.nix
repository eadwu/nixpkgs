{ lib
, wakatime, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-wakatime";
      publisher = "WakaTime";
      version = "13.0.0";
      sha256 = "sha256-ACzOyiBHCUwMni/Y+nhHzioCLLouQfghT81HlbYb7kw=";
    };

    meta = with lib; {
      description = ''
        Visual Studio Code plugin for automatic time tracking and metrics generated
        from your programming activity
      '';
      license = licenses.bsd3;
    };
  }
