package("bsci")
    add_urls("https://github.com/OEOTYAN/BedrockServerClientInterface.git")
    add_versions("0.1.3", "09b93fe157be697ba84a2cbec242454e9290b67c")
    add_versions("0.1.4", "f3fbbdca5df9c10b6c8f1276a7e0ee03497ad098")
    add_versions("0.1.5", "93a09bc81bba0dfcb489e8df122353dc616c3c7d")
    add_versions("0.1.6", "4b3e5c0104e5c2f4c8d22e7cc40f7b0c95248d36")
    add_versions("0.1.7", "6f74e2d00e574ea24cdac76238d7d67310586eec")
    add_versions("0.3.0", "35a49d2f7f393ed3870822c3dfc987665dcb0631")
    add_versions("0.3.1", "b1edcd3951b18d99b5e6e70cad156a83191a7a93")
    add_configs("target_type", {default = "server", values = {"server", "client"}})
    on_install(function(package)
        if package:config("target_type") == "server" then
            import("package.tools.xmake").install(package)
        else
            import("package.tools.xmake").install(package, {"--target_type=client"})
        end
    end)
