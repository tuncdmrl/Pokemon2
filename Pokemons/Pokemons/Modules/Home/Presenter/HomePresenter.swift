//
//  HomePresenter.swift
//  Pokemons
//
//  Created by tunc on 25.08.2025.
//
import Foundation
import UIKit

final class HomePresenter {
  weak var view: HomeView?
  var interactor: HomeInteractorInput!
  var router: HomeWireframe!
  
  private var pokemons: [Pokemon] = []
  
  private var offset = 0
  private let limit = 20
  private var pageNumber = 0
  
  private var isLoading = false
  private var allLoaded = false
  
  private func idFromURL(_ url: String) -> Int? {
    return url.split(separator: "/").compactMap { Int($0) }.last
  }
}

extension HomePresenter: HomePresentation {
  func viewDidLoad() {
    view?.setupUI()
    
    loadMoreIfNeeded()
  }
  
  func willDisplayRow(_ index: Int) {
    if index >= pokemons.count - 5 {
      loadMoreIfNeeded()
    }
  }
  
  func selectRow(_ index: Int) {
    guard pokemons.indices.contains(index), let id = idFromURL(pokemons[index].url) else { return }
    
    router.routeToPokemonDetail(pokemonID: id)
  }
  
  func retry() {
    loadMoreIfNeeded()
  }
  
  private func loadMoreIfNeeded() {
    guard !isLoading, !allLoaded else { return }
    
    isLoading = true
    
    interactor.getPokemons(offset: offset, limit: limit, page: pageNumber)
    
    view?.showLoading(true)
  }
}

extension HomePresenter: HomeInteractorOutput {
  
  func gotPokemons(_ items: [Pokemon]) {
    isLoading = false
    
    view?.showLoading(false)
    
    if items.isEmpty {
      allLoaded = true
      
      return
    }
    let isFirstPage = pokemons.isEmpty
    pokemons.append(contentsOf: items)
    
    offset += items.count
    
    pageNumber += 1
    
    if isFirstPage {
      view?.showInitialPokemons(pokemons)
    } else {
      view?.appendPokemon(items)
    }
  }
  
  func gotError(_ error: Error) {
    isLoading = false
    
    view?.showLoading(false)
    view?.showError("Liste alınamadı: \(error.localizedDescription)")
  }
  
  func FetchPokemonDetail(_ detail: PokemonDetailResponse) {
  }
  
  func FailToFetchPokemonDetail(_ error: Error) {
  }
}
