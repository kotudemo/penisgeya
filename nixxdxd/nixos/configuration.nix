# nixos config

{ config, lib, pkgs, inputs, ... }:

{
    imports = [
        inputs.home-manager.nixosModules.home-manager
        ./hardware-configuration.nix
        ./users.nix
        ./desktop.nix
	       #./conf.d/server.nix
    ];

    # nixos and nix daemon settings
    
    nix = {
        gc = {
	     	automatic  = true;
	 	    dates      = "weekly";
	 	    persistent = true;
         };
        settings = {
            allowed-users = [ "kd" "root" ];
            experimental-features = [ "nix-command" "flakes" ];
            sandbox = true;
            trusted-users = [ "kd" "root" ];
        };
    }; 

    # hm stuff
    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users = {
            kd = import ./home.nix;
        };
    };
    system = {
        stateVersion = config.system.nixos.release;
        name = config.networking.hostName;
        activatable = lib.mkForce true;
        copySystemConfiguration = false;
    };
}
