{
  description = "Minimal AArch64 GitHub Actions runner image built with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Define the target architecture (cross-compilation target)
      targetSystem = "aarch64-linux";
      
      # Build on x86_64-linux but targeting aarch64-linux
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        crossSystem = {
          config = "aarch64-unknown-linux-gnu";
        };
      };

      aarch64Pkgs = import nixpkgs { system = targetSystem; };
    in
    {
      packages.x86_64-linux.default = pkgs.dockerTools.buildLayeredImage {
        name = "setup-aarch64-toolchain-nix";
        tag = "latest";
        
        # Tools to include in the root
        contents = with pkgs; [
          binutils
          coreutils
          bashInteractive
          cacert
        ];

        config = {
          Cmd = [ "${pkgs.bashInteractive}/bin/bash" ];
          Env = [
            "PATH=/bin"
            "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
          ];
          WorkingDir = "/workspace";
        };
      };

      # Allow native build if on aarch64
      packages.aarch64-linux.default = aarch64Pkgs.dockerTools.buildLayeredImage {
        name = "setup-aarch64-toolchain-nix";
        tag = "latest";
        
        contents = with aarch64Pkgs; [
          binutils
          coreutils
          bashInteractive
          cacert
        ];

        config = {
          Cmd = [ "${aarch64Pkgs.bashInteractive}/bin/bash" ];
          Env = [
            "PATH=/bin"
            "SSL_CERT_FILE=${aarch64Pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
          ];
          WorkingDir = "/workspace";
        };
      };
    };
}