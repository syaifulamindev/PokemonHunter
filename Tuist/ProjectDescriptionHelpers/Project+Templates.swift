import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/
public class ProjectBuilder {
    private let name: String
    private var targets: [Target] = []
    private var moduleNames: [String] = []
    private let destinations: Destinations = .iOS
    private let organizationName: String = "id.amin"
    
    public init(_ name: String) {
        self.name = name
    }
    
    public func build() -> Project {
        let infoPlist: [String: Plist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UILaunchStoryboardName": "LaunchScreen"
        ]
        
        let mainDependencies = self.moduleNames.map { TargetDependency.target(name: $0)}
        
        let mainTarget: Target = .target(
            name: name,
            destinations: destinations,
            product: .app,
            bundleId: "\(organizationName).\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: mainDependencies
        )
        
        let testTarget: Target = .target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(organizationName).\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
            ])
        
        var targets = [mainTarget, testTarget]
        targets.append(contentsOf: self.targets)
        return Project(name: name,
                       organizationName: "amin.id",
                       targets: targets)
    }
    
}

public extension ProjectBuilder {
    
    func addModule(_ name: String, path: String = "", withExample: Bool = false,  dependencies: [TargetDependency] = [], resources: ResourceFileElements = []) -> ProjectBuilder {
        moduleNames.append(name)
        
        let  relativePath: String = path == "" ? name : path
        let sources: Target = .target(name: name,
                             destinations: destinations,
                             product: .framework,
                             bundleId: "\(organizationName).\(name)",
                             infoPlist: .default,
                             sources: ["Targets/\(relativePath)/Sources/**"],
                             resources: resources,
                             dependencies: dependencies)
        
        var completeDependencies = dependencies
        completeDependencies.append(.target(name: name))
        
        let tests: Target = .target(name: "\(name)Tests",
                           destinations: destinations,
                           product: .unitTests,
                           bundleId: "\(organizationName).\(name)Tests",
                           infoPlist: .default,
                           sources: ["Targets/\(relativePath)/Tests/**"],
                           resources: resources,
                           dependencies: completeDependencies)
        targets.append(contentsOf: [sources, tests])
        
        if withExample {
            let infoPlist: [String: Plist.Value] = [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "UILaunchStoryboardName": "LaunchScreen"
            ]
            
            let example: Target = .target(name: "\(name)Example",
                                 destinations: destinations,
                                 product: .app,
                                 bundleId: "\(organizationName).\(name)Example",
                                 infoPlist: .extendingDefault(with: infoPlist),
                                 sources: ["Targets/\(relativePath)/Example/**"],
                                 resources: resources,
                                 dependencies: completeDependencies)
            targets.append(example)
        }
        
        return self
    }
}
