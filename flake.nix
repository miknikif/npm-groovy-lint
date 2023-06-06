{
  description = "Groovy npm linter";
  inputs = {
    # Giant monorepo with recipes called derivations that say how to build software
    nixpkgs.url = "github:nixos/nixpkgs/release-23.05"; # Can be nixpkgs-unstable
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in rec {
      packages.npm-groovy-lint = pkgs.buildNpmPackage rec {
        pname = "npm-groovy-lint";
        version = "v11.1.1";

        src = pkgs.fetchFromGitHub {
          owner = "nvuillam";
          repo = pname;
          rev = version;
          sha256 = "sha256-JBfMLvo51RhtbVobtfv5/+qgo7UHTLZascU08D4l9Vk=";
        };
        buildInputs = with pkgs; [jdk11];
        # The prepack script runs the build script, which we'd rather do in the build phase.
        npmPackFlags = ["--ignore-scripts"];
        npmDepsHash = "sha256-op6ddqPPD1eSCPdwbTOSDMhe6ABi647RlnHC0b0DlxY=";

        meta = with pkgs.lib; {
          description = "Groovy npm linter";
          homepage = "https://github.com/nvuillam/npm-groovy-lint";
          sourceProvenance = with sourceTypes; [fromSource];
          license = licenses.gpl3Only;
        };
      };
      packages.default = packages.npm-groovy-lint;
      apps.npm-groovy-lint = flake-utils.lib.mkApp {
        drv = packages.npm-groovy-lint;
        name = "npm-groovy-lint";
      };
      apps.default = apps.npm-groovy-lint;
    });
}
