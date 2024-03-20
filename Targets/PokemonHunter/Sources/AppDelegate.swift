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
        
        window?.rootViewController = PokemonListViewController(
            store: Store<PokemonList.State, PokemonList.Action>(initialState: PokemonList.State(), reducer: pokemonListReducer, environment: PokemonList.Environment())
        )
        window?.makeKeyAndVisible()
        
        PokemonHunterKit.hello()
        PokemonHunterUI.hello()
        
        return true
    }
    
}






