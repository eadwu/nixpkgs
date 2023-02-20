{ lib
, glibc
, linkFarm
, writeShellScript
, runCommand
, makeWrapper
, libnvidia-container
, nvidia-container-toolkit
, containerRuntimePath
, configTemplate
, extraCommands ? ""
}:
let
  warnIfXdgConfigHomeIsSet = writeShellScript "warn_if_xdg_config_home_is_set" ''
    set -eo pipefail

    if [ -n "$XDG_CONFIG_HOME" ]; then
      echo >&2 "$(tput setaf 3)warning: \$XDG_CONFIG_HOME=$XDG_CONFIG_HOME$(tput sgr 0)"
    fi
  '';
in
runCommand "nvidia-container-toolkit-wrapper" {
    nativeBuildInputs = [ makeWrapper ];
    propagatedBuildInputs = [ libnvidia-container nvidia-container-toolkit ];
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
  for binary in nvidia-ctk nvidia-container-runtime nvidia-container-runtime-hook;
  do
    makeWrapper ${nvidia-container-toolkit}/bin/$binary $out/bin/$binary \
      --run "${warnIfXdgConfigHomeIsSet}" \
      --set-default XDG_CONFIG_HOME $out/etc
  done
  ln -sf $out/bin/nvidia-container-runtime-hook $out/bin/nvidia-container-toolkit

  cp ${configTemplate} $out/etc/nvidia-container-runtime/config.toml

  substituteInPlace $out/etc/nvidia-container-runtime/config.toml \
    --subst-var-by glibcbin ${lib.getBin glibc} \
    --subst-var-by nvidia-container-cli "${libnvidia-container}/bin/nvidia-container-cli" \
    --subst-var-by containerRuntimePath "${containerRuntimePath}"

  ${extraCommands}
''
