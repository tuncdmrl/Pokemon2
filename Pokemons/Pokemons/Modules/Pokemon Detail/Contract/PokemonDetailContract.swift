//
//  PokemonDetailContract.swift
//  Pokemons
//
//  Created by tunc on 11.08.2025.
//

import UIKit

protocol PokemonDetailView: AnyObject {
  func setupUI()
  
  func showLoading(_ isLoading: Bool)
  func render(viewModel: PokemonDetail)
  func reloadRow(for section: PokemonDetailSection)
  func showError(_ message: String)
}

protocol PokemonDetailPresentation: AnyObject {
  func viewDidLoad()
  func buttonToggle(section: PokemonDetailSection)
 func tapImage(at index: Int)
  func tapRetry()
  
  func backButtonTapped()
}

protocol PokemonDetailInteractorInput: AnyObject {
  func fetchPokemonDetail(id: Int)
  func fetchPokemonSpecies(id: Int)
  func refreshAll(id: Int)
}

protocol PokemonDetailInteractorOutput: AnyObject {
  func fetchDetail(_ detail: PokemonDetailResponse)
  func fetchSpecies(_ species: PokemonSpeciesResponse)
  func failToFetchDetail(_ error: Error)
  func failToFetchSpecies(_ error: Error)
}

protocol PokemonDetailWireframe: AnyObject {
  func pop()
}
