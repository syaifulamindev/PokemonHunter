// swift-tools-version: 5.7.1

import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers


    let packageSettings = PackageSettings(
        productTypes: [
            "ComposableArchitecture": .framework,
            "PokemonAPI": .framework,
            "Shuffle": .framework,
            "PopBounceButton": .framework
        ]
    )
#endif


let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.9.2"),
        .package(url: "https://github.com/kinkofer/PokemonAPI.git", from: "6.1.1"),
        .package(url: "https://github.com/mac-gallagher/Shuffle.git", from: "0.4.2"),
//        .package(url: "https://github.com/mac-gallagher/PopBounceButton.git", from: "1.1.1"),

    ]
)
