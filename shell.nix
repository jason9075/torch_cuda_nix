{ pkgs }:
let
  pythonEnv = pkgs.python3.withPackages (ps:
    with ps; [
      # tensorflowWithCuda
      tensorflow-bin
      torch-bin
      torchvision-bin
    ]);
in pkgs.mkShell {
  name = "python-cuda-env";
  buildInputs = with pkgs; [ pythonEnv pkgs.python3Packages.virtualenv ];

  shellHook = ''
    echo "Welcome to my Python project environment!"
  '';
}
