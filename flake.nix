{
  description = "The purely functional static site generator in Nix expression language.";

  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, utils, nixpkgs, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        styx = pkgs.callPackage ./derivation.nix {};
        lib = import ./src/lib { inherit pkgs styx; };
        styx-themes = import ./themes { inherit pkgs; };
      in
      {
        devShell = nixpkgs.legacyPackages.x86_64-linux.mkShell {
          nativeBuildInputs = [
            self.packages.x86_64-linux.styx
          ];
        };
        packages = { inherit styx; };
        defaultPackage = styx;

        inherit lib styx-themes;
      }
    );

}
