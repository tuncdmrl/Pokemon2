//
//  PokemonDetailRouter.swift
//  Pokemons
//
//  Created by tunc on 11.08.2025.
//

import UIKit

final class PokemonDetailRouter: PokemonDetailWireframe {
  weak var view: UIViewController?
  
  static func buildModule(pokemonID: Int) -> PokemonDetailViewController {
    
    let navigationController = UIStoryboard.viewController(fromStoryboard: "PokemonDetail") as! UINavigationController
    let viewController = navigationController.visibleViewController as! PokemonDetailViewController
    
    let presenter = PokemonDetailPresenter()
    let router = PokemonDetailRouter()
    let interactor = PokemonDetailInteractor()
    
    viewController.presenter =  presenter
    
    presenter.view = viewController
    presenter.router = router
    presenter.interactor = interactor
    presenter.pokemonID = pokemonID
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
  
  func pop() { 
    view?.navigationController?.popViewController(animated: true)
  }
}
