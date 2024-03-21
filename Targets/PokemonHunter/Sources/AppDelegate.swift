import UIKit
import PokemonHunterKit
import PokemonHunterUI
import ComposableArchitecture

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = PokemonListViewController(
            store: Store<PokemonList.State, PokemonList.Action>(initialState: .init(), reducer: { PokemonList(environment: .init()) })
        )
        
        window?.rootViewController = UINavigationController(rootViewController: vc)
        
//        window?.rootViewController = PokemonDetailViewController(
//            store:
//                Store<PokemonDetail.State, PokemonDetail.Action>(
//                    initialState: .init(pokemon: Pokemon(id: 1, name: "bubaur"), pokemonImage: nil),
//                    reducer: { PokemonDetail(environment: .init())}
//                )
//        )
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
}






