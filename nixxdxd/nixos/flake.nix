# Flakes config, kinda messed up bc i'm still new in nix xd

{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-master.url = "github:nixos/nixpkgs/master";

        nix-gaming = {
            url = "github:fufexan/nix-gaming";
        };

        polymc = {
            url = "github:PolyMC/PolyMC";
        };

        nur = {
            url = "github:nix-community/NUR";
        };

        home-manager = {
            url = "github:nix-community/home-manager/";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nixpkgs, home-manager, ... }:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs { inherit system; };
        in {
            nixosConfigurations = {
                naswayos = nixpkgs.lib.nixosSystem {
                    specialArgs = { inherit inputs system; };
                    modules = [
                        ./configuration.nix
                    ];
                };
            };
            homeConfigurations = {
                nixuser = home-manager.lib.homeManagerConfiguration {        # hm option goes here, inside your new host directory
                    pkgs = nixpkgs.legacyPackages.x86_64-linux;
                    modules = [
                        ./home.nix                              # path to your home-manager configuration, standalone version
                        # here you place modules for flakes inputs like a chaotic or stylix
                    ];
                };
            };
        };
}
