{
  description = "Development environment for projects";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

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
      pythonEnv = pkgs.python3.withPackages (ps:
        with ps; [
          # tensorflowWithCuda
          tensorflow-bin
          torch-bin
          torchvision-bin
        ]);
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "python-cuda-env";
        buildInputs = with pkgs; [ pythonEnv python3Packages.virtualenv ];

        shellHook = ''
          echo "Welcome to my Python project environment!"
        '';
      };
    };
}
