{ pkgs ? import <nixpkgs> {}, compiler ? "default" }:

let
  haskellPackages = if compiler == "default" then pkgs.haskellPackages else pkgs.haskell.packages.${compiler};

in
  pkgs.stdenv.mkDerivation {
    name = "hindent-dev";
    buildInputs = [
      haskellPackages.cabal-install
    ];
  }
