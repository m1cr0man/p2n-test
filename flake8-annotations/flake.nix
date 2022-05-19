{
  description = "Application packaged using poetry2nix";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    {
      # Nixpkgs overlay providing the application
      overlay = nixpkgs.lib.composeManyExtensions [
        poetry2nix.overlay
        (final: prev: {
          # The application
          myapp = prev.poetry2nix.mkPoetryApplication {
            projectDir = ./.;
            overrides = prev.poetry2nix.overrides.withDefaults (self: super: {
              flake8-annotations = super.flake8-annotations.overridePythonAttrs (oldAttrs: {
                nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ super.poetry-core ];
              });
            });
          };
        })
      ];
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
      {
        apps = {
          myapp = pkgs.myapp;
        };

        defaultApp = pkgs.myapp;
      }));
}
