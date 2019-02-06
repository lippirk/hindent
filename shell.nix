{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, Cabal, containers
      , criterion, deepseq, Diff, directory, exceptions, filepath
      , ghc-prim, haskell-src-exts, hspec, monad-loops, mtl
      , optparse-applicative, path, path-io, stdenv, text, transformers
      , unix-compat, utf8-string, yaml
      }:
      mkDerivation {
        pname = "hindent";
        version = "5.2.7";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        enableSeparateDataOutput = true;
        libraryHaskellDepends = [
          base bytestring Cabal containers directory exceptions filepath
          haskell-src-exts monad-loops mtl text transformers utf8-string yaml
        ];
        executableHaskellDepends = [
          base bytestring deepseq directory exceptions ghc-prim
          haskell-src-exts optparse-applicative path path-io text
          transformers unix-compat utf8-string yaml
        ];
        testHaskellDepends = [
          base bytestring deepseq Diff directory exceptions haskell-src-exts
          hspec monad-loops mtl utf8-string
        ];
        benchmarkHaskellDepends = [
          base bytestring criterion deepseq directory exceptions ghc-prim
          haskell-src-exts mtl utf8-string
        ];
        homepage = "https://github.com/commercialhaskell/hindent";
        description = "Extensible Haskell pretty printer";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
