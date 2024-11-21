{
  description = "A very basic flake";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = inputs@{ ... }:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          #cudaSupport = true;
          allowUnfree = true;
        };
      };
    in {
      devShells.x86_64-linux.default = import ./shell.nix { inherit pkgs; };
    };
}
