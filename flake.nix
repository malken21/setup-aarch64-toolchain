{
  description = "Minimal AArch64 GitHub Actions runner image built with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        let
          # Helper to build the image (native or cross)
          buildImage =
            p:
            p.dockerTools.buildLayeredImage {
              name = "setup-aarch64-toolchain";
              tag = "latest";

              contents = with p; [
                binutils
                coreutils
                bashInteractive
                cacert
              ];

              config = {
                Cmd = [ "${p.bashInteractive}/bin/bash" ];
                Env = [
                  "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
                  "SSL_CERT_FILE=${p.cacert}/etc/ssl/certs/ca-bundle.crt"
                ];
                WorkingDir = "/workspace";
              };
            };

          # Cross-pkgs for x86_64-linux targeting aarch64
          # If building on aarch64-linux, use native pkgs.
          targetPkgs = if system == "x86_64-linux" then pkgs.pkgsCross.aarch64-multiplatform else pkgs;
        in
        {
          # Default package is the AArch64 image
          packages.default = buildImage targetPkgs;

          # Formatter for nix files (Nix RFC 166 style)
          formatter = pkgs.nixfmt-rfc-style;

          # Dev shell containing tools for local testing/development
          devShells.default = pkgs.mkShell {
            packages = with targetPkgs; [
              binutils
              coreutils
            ];
          };
        };
    };
}