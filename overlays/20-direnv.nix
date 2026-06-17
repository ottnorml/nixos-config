_final: prev:
let
  doCheck = prev.direnv.doCheck or true;
in
{
  # FIXME(nixpkgs#513019): cache.nixos.org can serve fish/zsh binaries with
  # broken code signatures on aarch64-darwin (NixOS/nix#15638). direnv's
  # checkPhase invokes shell integration tests and can hang there. Drop this
  # overlay after nixpkgs#513081 lands in our pinned nixpkgs.
  #
  # Issue: https://github.com/NixOS/nixpkgs/issues/513019
  # Fix:   https://github.com/NixOS/nixpkgs/pull/513081
  # Root:  https://github.com/NixOS/nix/pull/15638
  # Inspired-by: https://github.com/yu-sz/dotfiles/commit/c18062a2547b82a5e4ba5ede76c048c38fb2afff
  direnv =
    assert prev.lib.assertMsg (prev.direnv.version == "2.37.1" && doCheck)
      "Overlay overlays/20-direnv.nix may no longer be needed: direnv=${prev.direnv.version}, doCheck=${prev.lib.boolToString doCheck}. Try removing the overlay.";
    prev.direnv.overrideAttrs (_old: {
      doCheck = false;
    });
}
