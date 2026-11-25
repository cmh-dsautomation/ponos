{
  description = "NixOS WSL system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixos-wsl, ... }: {
    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        nixos-wsl.nixosModules.default
        
        ({ pkgs, ... }: {
      	  wsl.enable = true;
          wsl.defaultUser = "nixos";          

          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

          environment.systemPackages = with pkgs; [
            git
            gh
            helix
            lazygit
            nodejs
            opencode
            codex
            bubblewrap
          ];

          system.stateVersion = "26.11";
        })
      ];
    };
  };
}
