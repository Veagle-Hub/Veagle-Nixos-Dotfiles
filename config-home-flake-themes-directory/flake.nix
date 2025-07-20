{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    #nur.url = "github:nix-community/NUR";
    #nur.inputs.nixpkgs.follows = "nixpkgs";
  };

      outputs = { self, nixpkgs, flake-utils, home-manager, hyprland, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      # System (NixOS) configuration
      nixosConfigurations = {
        veagle = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/veagle/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.users.veagle = import ./hosts/veagle/home.nix;
            }
          ];
        };
      };

      # Optional: separate home-only rebuild if you want it
      homeConfigurations.veagle = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        #extraSpecialArgs = {
        # inherit inputs;
        # nur = nur;
        #};
        modules = [
          ./hosts/veagle/home.nix
          hyprland.homeManagerModules.default
          {
            home.username = "veagle";
            home.homeDirectory = "/home/veagle";
          }
        ];
      };
    };
}

