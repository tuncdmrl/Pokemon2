//
//  HomeRouter.swift
//  Pokemons
//
//  Created by tunc on 25.08.2025.
//

import UIKit

final class HomeRouter: HomeWireframe {
  weak var view: UIViewController?
  
  static func buildModule() -> HomeViewController {
    let navigationController = UIStoryboard.viewController(fromStoryboard: "Home") as! UINavigationController
    let viewController = navigationController.visibleViewController as! HomeViewController
    
    let presenter = HomePresenter()
    let router = HomeRouter()
    let interactor = HomeInteractor()
    
    viewController.presenter =  presenter
    
    presenter.view = viewController
    presenter.router = router
    presenter.interactor = interactor
    
    router.view = viewController
    
    interactor.output = presenter
    
    return viewController
  }
  
  func routeToPokemonDetail(pokemonID: Int) {
    let pokemonDetailViewController = PokemonDetailRouter.buildModule(pokemonID: pokemonID)
    
    view?.navigationController?.pushViewController(pokemonDetailViewController, animated: true)
  }
}
