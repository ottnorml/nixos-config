{ lib, ... }:

let
  emacsOverlaySha256 = "11p1c1l04zrn8dd5w8zyzlv172z05dwi9avbckav4d5fk043m754";
in
{
  # Shared ssh client configration
  programs.ssh.extraConfig = lib.mkAfter ''
    Host *
      HostKeyAlgorithms -ecdsa-sha2-nistp*,sk-ecdsa-sha2-nistp*
      KexAlgorithms -ecdh-sha2-nistp*
      MACs -hmac-sha1*
  '';

  # Shared ssh server configration
  services.openssh.extraConfig = lib.mkAfter ''
    HostKeyAlgorithms -ecdsa-sha2-nistp*,sk-ecdsa-sha2-nistp*
    KexAlgorithms -ecdh-sha2-nistp*
    MACs -hmac-sha1*
  '';

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };

    overlays =
      # Apply each overlay found in the /overlays directory
      let
        path = ../../overlays;
      in
      with builtins;
      map (n: import (path + ("/" + n))) (
        filter (n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix"))) (
          attrNames (readDir path)
        )
      )

      ++ [
        (import (
          builtins.fetchTarball {
            url = "https://github.com/dustinlyons/emacs-overlay/archive/refs/heads/master.tar.gz";
            sha256 = emacsOverlaySha256;
          }
        ))
      ];
  };
}
