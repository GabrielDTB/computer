{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {nixpkgs, ...}: {
    packages = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.writeShellApplication {
        name = "run";
        runtimeInputs = [pkgs.gnupg];
        text = ''
          key="$(gpg --quiet --pinentry-mode loopback --decrypt ${./key.asc})"
          gpg --batch --quiet --import <<<"$key"
          payload="$(gpg --batch --quiet --decrypt ${./payload.gpg})"
          NIXPKGS=${nixpkgs} exec bash -c "$payload" run "$@"
        '';
      };
    });
  };
}
