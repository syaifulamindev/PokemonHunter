import ProjectDescription

let project = Project(
    name: "PokemonHunter",
    targets: [
        .target(
            name: "PokemonHunter",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.PokemonHunter",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["PokemonHunter/Sources/**"],
            resources: ["PokemonHunter/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "PokemonHunterTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.PokemonHunterTests",
            infoPlist: .default,
            sources: ["PokemonHunter/Tests/**"],
            resources: [],
            dependencies: [.target(name: "PokemonHunter")]
        ),
    ]
)
