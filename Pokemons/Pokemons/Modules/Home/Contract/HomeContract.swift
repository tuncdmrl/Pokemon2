//
//  HomeContract.swift
//  Pokemons
//
//  Created by tunc on 25.08.2025.
//

import UIKit

protocol HomeView: AnyObject {
  func setupUI()
  
  func showLoading(_ isLoading: Bool)
  func showInitialPokemons(_ items: [Pokemon])
  func appendPokemon(_ items: [Pokemon])
  
  func showError(_ message: String)
}

protocol HomePresentation: AnyObject {
  func viewDidLoad()
  
  func willDisplayRow(_ index: Int)
  
  func selectRow(_ index: Int)
  
  func retry()
}

protocol HomeInteractorInput: AnyObject {
  func getPokemons(offset: Int, limit: Int, page: Int)
  func fetchPokemonDetail(id: Int)        
}

protocol HomeInteractorOutput: AnyObject {
  func gotPokemons(_ items: [Pokemon])
  
  func gotError(_ error: Error)
  
  func FetchPokemonDetail(_ detail: PokemonDetailResponse)
  func FailToFetchPokemonDetail(_ error: Error)
}

protocol HomeWireframe : AnyObject {
  func routeToPokemonDetail(pokemonID: Int)
}
