{
  description = "NixOS Developer Desktop VM with i3wm";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.dev-vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dev = import ./home.nix;
        }
      ];
    };

    # VM package that can be built and run
    packages.x86_64-linux.vm = self.nixosConfigurations.dev-vm.config.system.build.vm;
    packages.x86_64-linux.default = self.packages.x86_64-linux.vm;
  };
}
