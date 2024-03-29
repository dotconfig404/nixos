{
  description = "My flakes configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs }@inputs:
    {
      nixosConfigurations = {
 	# "if there is a system with hostname noxy, use following config"
        noxy = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./noxy.nix ./configuration.nix ];
        };
      };
    };
}
