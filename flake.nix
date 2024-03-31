{
  description = "My flakes configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, home-manager, nixpkgs }@inputs:
  let
    system = "x86_64-linux";
    specialArgs = inputs // { inherit system; };
    shared-modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
        };
      }
    ];
  in {
    nixosConfigurations = {
      # "if there is a system with hostname noxy, use following config"
      noxy = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        system = system;
        modules = shared-modules ++ [ ./noxy.nix ];
      };
      titania = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        system = system;
        modules = shared-modules ++ [ ./titania.nix ];
      };
    };
  };
}
