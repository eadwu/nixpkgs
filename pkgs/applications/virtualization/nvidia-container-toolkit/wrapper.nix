{ lib
, glibc
, linkFarm
, writeShellScript
, runCommand
, makeWrapper
, nvidia-container-toolkit
, containerRuntimePath
, configTemplate
, extraCommands ? ""
}:
let
  isolatedContainerRuntimePath = linkFarm "isolated_container_runtime_path" [
    {
      name = "runc";
      path = containerRuntimePath;
    }
  ];
  warnIfXdgConfigHomeIsSet = writeShellScript "warn_if_xdg_config_home_is_set" ''
    set -eo pipefail

    if [ -n "$XDG_CONFIG_HOME" ]; then
      echo >&2 "$(tput setaf 3)warning: \$XDG_CONFIG_HOME=$XDG_CONFIG_HOME$(tput sgr 0)"
    fi
  '';
in
runCommand "nvidia-container-toolkit-wrapper" {
    nativeBuildInputs = [ makeWrapper ];
    meta.priority = -1; # scuffed
} ''
  mkdir -p $out/etc/nvidia-container-runtime

  # nvidia-container-runtime invokes docker-runc or runc if that isn't
  # available on PATH.
  #
  # Also set XDG_CONFIG_HOME if it isn't already to allow overriding
  # configuration. This in turn allows users to have the nvidia container
  # runtime enabled for any number of higher level runtimes like docker and
  # podman, i.e., there's no need to have mutually exclusivity on what high
  # level runtime can enable the nvidia runtime because each high level
  # runtime has its own config.toml file.
  makeWrapper ${nvidia-container-toolkit}/bin/nvidia-container-runtime $out/bin/nvidia-container-runtime \
    --run "${warnIfXdgConfigHomeIsSet}" \
    --prefix PATH : ${isolatedContainerRuntimePath} \
    --set-default XDG_CONFIG_HOME $out/etc

  cp ${configTemplate} $out/etc/nvidia-container-runtime/config.toml

  substituteInPlace $out/etc/nvidia-container-runtime/config.toml \
    --subst-var-by glibcbin ${lib.getBin glibc}

  makeWrapper ${nvidia-container-toolkit}/bin/nvidia-container-toolkit $out/bin/nvidia-container-toolkit \
    --add-flags "-config $out/etc/nvidia-container-runtime/config.toml"

  ${extraCommands}
''
