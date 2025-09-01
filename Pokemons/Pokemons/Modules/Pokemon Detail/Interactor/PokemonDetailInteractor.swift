//
//  PokemonDetailInteractor.swift
//  Pokemons
//
//  Created by tunc on 11.08.2025.
//
import Foundation
import RxSwift

final class PokemonDetailInteractor: PokemonDetailInteractorInput {
  weak var output: PokemonDetailInteractorOutput?
  
  private let api: APIServiceProtocol = APIService()
  private let disposeBag = DisposeBag()
  
  func fetchPokemonDetail(id: Int) {
    api.getPokemonDetail(with: id)              
      .observe(on: MainScheduler.instance)
      .subscribe(onSuccess: { [weak self] detail in
        guard let self, let detail else { return }
        self.output?.fetchDetail(detail)
      }, onFailure: { [weak self] error in
        self?.output?.failToFetchDetail(error)
      })
      .disposed(by: disposeBag)
  }
  
  func fetchPokemonSpecies(id: Int) {
    api.getPokemonSpecies(id: id)
      .observe(on: MainScheduler.instance)
      .subscribe(onSuccess: { [weak self] species in
        guard let self, let species else { return }
        self.output?.fetchSpecies(species)
      }, onFailure: { [weak self] error in
        self?.output?.failToFetchSpecies(error)
      })
      .disposed(by: disposeBag)
  }
  
  func refreshAll(id: Int) {
    fetchPokemonDetail(id: id)
    fetchPokemonSpecies(id: id)
  }
}
