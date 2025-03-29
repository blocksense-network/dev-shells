{
  description = "Blocksense Dev Shells";

  nixConfig = {
    extra-substituters = [
      "https://blocksense.cachix.org"
      "https://mcl-blockchain-packages.cachix.org"
      "https://mcl-public-cache.cachix.org"
    ];
    extra-trusted-public-keys = [
      "blocksense.cachix.org-1:BGg+LtKwTRIBw3BxCWEV//IO7v6+5CiJVSGzBOQUY/4="
      "mcl-blockchain-packages.cachix.org-1:qoEiUyBgNXmgJTThjbjO//XA9/6tCmx/OohHHt9hWVY="
      "mcl-public-cache.cachix.org-1:OcUzMeoSAwNEd3YCaEbNjLV5/Gd+U5VFxdN2WGHfpCI="
    ];
  };

  inputs = {
    mcl-blockchain.url = "github:metacraft-labs/nix-blockchain-development";
    nixpkgs.follows = "mcl-blockchain/nixpkgs";
    mcl-nixos-modules.follows = "mcl-blockchain/nixos-modules";
    flake-parts.follows = "mcl-blockchain/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        {
          lib,
          pkgs,
          inputs',
          ...
        }:
        let
          mcl-pkgs = inputs'.mcl-blockchain.legacyPackages;
          commonPkgs =
            with pkgs;
            [
              pkg-config
              curl
              libusb1
              openssl
              zstd
            ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              udev
            ]
            ++ lib.optionals stdenv.isDarwin [
              iconv
            ];

          rustPkgs = commonPkgs ++ [
            mcl-pkgs.rust-latest
          ];

          nodejsPkgs =
            let
              nodejs = pkgs.nodejs_22;
              oldYarn = pkgs.yarn.override { inherit nodejs; };
              yarn = pkgs.yarn-berry.override {
                inherit nodejs;
                yarn = oldYarn;
              };
            in
            commonPkgs
            ++ [
              nodejs
              yarn
              pkgs.python3
            ];

          mkShell = pkgSet: pkgs.mkShell { packages = pkgSet; };
        in
        {
          devShells = {
            default = mkShell (rustPkgs ++ nodejsPkgs);
            rust = mkShell rustPkgs;
            nodejs = mkShell nodejsPkgs;
          };
        };
    };
}
