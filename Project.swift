import ProjectDescription
import ProjectDescriptionHelpers


/*
                +-------------+
                |             |
                |     App     | Contains PokemonHunter App target and PokemonHunter unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

// Creates our project using a helper function defined in ProjectDescriptionHelpers

let project = ProjectBuilder("PokemonHunter")
    .addModule("PokemonHunterKit", dependencies: [
        .external(name: "ComposableArchitecture"),
        .external(name: "PokemonAPI"),
        .external(name: "Alamofire")
    ])
    .addModule("PokemonHunterUI", dependencies: [
        .external(name: "Shuffle")
    ])
    .build()
