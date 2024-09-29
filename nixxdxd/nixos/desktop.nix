# Config for (my) desktop

{ config, lib, inputs, pkgs, overlays, ... }:

{
      imports = [

      ];

    # Networking
    networking = {
        firewall = { 
            allowPing = true;
            enable = true;
        };
        hostName = "naswayos";
        networkmanager = {
            enable = true;
        };
		useDHCP = lib.mkDefault true;
        proxy = {
            # allProxy = ;
            # default = ;
            # ftpProxy = ;
            # httpProxy = ;
            # httpsProxy = ;
            # noProxy = ;
            # rsyncProxy = ;
        };
		timeServers = [                         # https://wiki.nixos.org/wiki/NTP   
            "0.nixos.pool.ntp.org"
            "1.nixos.pool.ntp.org"
            "2.nixos.pool.ntp.org"
            "3.nixos.pool.ntp.org"
        ];
        wireless = {
            enable = false;
        };
    };  


    # Packages
    nixpkgs = {
        config = { 
            allowUnfree = true;
            allowBroken = false;
            config.permittedInsecurePackages = ["python-2.7.18.8" ];
        };
        overlays = [ ];                     # overlays in case you have
        system = "x86_64-linux";
        hostPlatform = lib.mkDefault "x86_64-linux"
	};

	 environment = {
        systemPackages = with pkgs; [
			zsh
			zsh-autosuggestions
			zsh-syntax-highlighting
			foot
			hyprland
			waybar
			cava
			wttrbar
			xwayland
			wl-clipboard
			ly
			swayimg
			swww
			xdg-desktop-portal-hyprland
			slurp
			grim
			pamixer
			wlsunset
			mako
			nemo
			nwg-look
			gruvbox-dark-gtk
			gruvbox-dark-icons-gtk
			flatpak
			home-manager
	        gutenprint
	        obs-studio
	        mpv
	        gparted
	        cups
	        canon-cups-ufr2
			cups-filters
            polkit
            polkit_gnome
            python3Full
            nodejs
            python.pkgs.pip
            gcc
            gnumake
            jq        ];
        shellAliases =                             # global aliases
            let
                flakeDir = "/etc/nixos";
            in { 
                cl = "clear";
                ls="eza -al --color=always --group-directories-first --icons"; # preferred listing
				la="eza -a --color=always --group-directories-first --icons";  # all files and dirs
				ll="eza -l --color=always --group-directories-first --icons";  # long format
				lt="eza -aT --color=always --group-directories-first --icons"; # tree listing
				l.="eza -a | grep -e '^\.'";       # show only dotfiles
				a
				..="cd ..";
				...="cd ../..";
				....="cd ../../..";
				.....="cd ../../../..";
				......="cd ../../../../..";
				please="sudo";
				jctl="journalctl -p 3 -xb";
      	        pf = "clear && nix run nixpkgs#pfetch";
	            ff = "clear && nix run nixpkgs#fastfetch";
	            nf = "clear && nix run nixpkgs#neofetch";
                unzip = "nix run nixpkgs#unzip -- ";
                unrar = "nix run nixpkgs#unrar -- ";
                zip = "nix run nixpkgs#zip -- ";
                sv = "sudo nvim";
                v = "nvim";
                vi = "nvim";
                vim = "nvim";
                nv = "nvim";
                nvim = "nvim";
                git = "nix run nixpkgs#git -- ";
	            btop = "clear && nix run nixpkgs#btop";
	            nsp = "nix-shell -p";
	            ncg = "nix store gc -v && nix-collect-garbage --delete-old";
	            upd = "sudo nix-channel --update nixos && sudo nixos-rebuild switch --upgrade-all --flake ${flakeDir}";
                hms = "home-manager switch --flake ${flakeDir}";
        };
        sessionVariables = {
        	WLR_NO_HARDWARE_CURSORS = "1";
			NIXOS_OZONE_WL = "1";
        };
		variables = {
			EDITOR = "nvim";
        	VISUAL = "nvim";
        	RANGER_LOAD_DEFAULT_RC = "FALSE";
            	QT_QPA_PLATFORMTHEME = "qt5ct";
        };
     };

    fonts = {                               # wiki page for fonts - https://wiki.nixos.org/wiki/Fonts
        fontDir = {
            # decompressFonts 
            enable = false;
        };
        fontconfig = {
            enable = true;                  # more options - https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=alpha_asc&type=packages&query=fonts.fontconfig
        };
        packages =  with pkgs; [
            hack-font
	    	noto-fonts
	    	noto-fonts-emoji
	    	twemoji-color-font
	    	font-awesome
	    	jetbrains-mono
	    	powerline-fonts
        	powerline-symbols
        	nerdfonts
        	miracode
        	monocraft
        ];
    };

    # Keeb and smth like it
    i18n = {                                  # basic locale config
        defaultLocale = "en_US.UTF-8";        # i prefer english or US / American 
        extraLocaleSettings = { };            # locale optinos, see https://wiki.archlinux.org/title/Locale
        inputMethod = {
        # enabled = ;
            # see https://search.nixos.org/options?channel=unstable&show=i18n.inputMethod.enabled&from=0&size=50&sort=alpha_asc&type=packages&query=i18n.
        };
        supportedLocales = [
            "en_US.UTF-8/UTF-8"
            "ru_RU.UTF-8/UTF-8"
        ];
    };
    console = {
        enable = true;
        keyMap = "us";
        useXkbConfig = false;  
    };


    # Services
     hardware.pulseaudio.enable = false;  
     sound.enable = true;
	systemd = {
		user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
   # wantedBy = [ "graphical-session.target" ];
   # wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
      };
    };
};
     security = { 
        polkit.enable = true; 
        rtkit.enable = true;
     };

     services = {
		fstrim.enable = true;
        gvfs.enable = true;
        udisks2.enable = true;
		automatic-timezoned.enable = true;
        xserver = {
            enable = true;
			display = 0;
            videoDrivers = [ "nvidia" ];  
	        xkb = {
                layout = "us,ru";
	            variant = "qwerty";
	            options = "grp:shift_alt_toggle"; };
        };
        pipewire = {
	        enable = true;
	        audio.enable = true;
	        pulse.enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
		};	
		printing = {
            enable = true;
            drivers = with pkgs; [ canon-cups-ufr2 cups-filters gutenprint ];
            listenAddresses = [
                "localhost:631"
            ];
            openFirewall = true;
            package = with pkgs; [
                cups
            ];
            webInterface = true;
		};
    };
	programs = {
		nh = {
            enable = true;
            flake = /etc/nixos/;
        };
		
		steam = {
            enable = true;
            remotePlay = {
                openFirewall = true;
            };
            gamescopeSession = {
                enable = true;
            };
        };
        gamemode = {
            enable = true;
		};
        bash = {
 	        interactiveShellInit = ''
    		    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    		        then
      			shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      			exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    		    fi
  	        '';
		};
		zsh = {
			interactiveShellInit = ''
				source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
				source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
				source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
			'';
		};
    };
}
