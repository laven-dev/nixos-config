{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nix-darwin,
    ...
  } @ inputs: let
    # Import the system helper function with required inputs.
    mkSystem = import ./lib/mksystem.nix {
      inherit self inputs nixpkgs nixpkgs-unstable;
    };
  in {
    nixosConfigurations = {
      server = mkSystem "server" {
        system = "x86_64-linux";
      };
      desktop = mkSystem "desktop" {
        system = "x86_64-linux";
      };
      elster = mkSystem "elster" {
        system = "x86_64-linux";
      };
      blaidd-wsl = mkSystem "blaidd-wsl" {
        system = "x86_64-linux";
        wsl = true;
      };
    };

    darwinConfigurations = {
      money-machine-darwin = mkSystem "money-machine-darwin" {
        system = "aarch64-darwin";
        darwin = true;
      };
    };
  };
}
