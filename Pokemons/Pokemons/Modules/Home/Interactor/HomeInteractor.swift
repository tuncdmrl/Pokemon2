//
//  HomeInteractor.swift
//  Pokemons
//
//  Created by tunc on 25.08.2025.
//

import Foundation
import RxSwift

final class HomeInteractor: HomeInteractorInput {
  weak var output: HomeInteractorOutput?
  
  private let apiService: APIServiceProtocol = APIService()
  private let disposeBag = DisposeBag()
  
  func getPokemons(offset: Int, limit: Int, page: Int) {
    apiService.getPokemons(offset: offset, limit: limit, pageNumber: page)
      .observe(on: MainScheduler.instance)
      .subscribe(onSuccess: { [weak self] response in
        guard let self, let response else { return }
        
        self.output?.gotPokemons(response.results)
      }, onFailure: { [weak self] error in
        self?.output?.gotError(error)
      }).disposed(by: disposeBag)
  }
  
  func fetchPokemonDetail(id: Int) {
    apiService.getPokemonDetail(with: id)
      .observe(on: MainScheduler.instance)
      .subscribe(onSuccess: { [weak self] detail in
        guard let self, let detail else { return }
        
        self.output?.FetchPokemonDetail(detail)
      }, onFailure: { [weak self] error in
        self?.output?.FailToFetchPokemonDetail(error)
      }).disposed(by: disposeBag)
  }
}
//buraya extension ekliyimmi gerek var mi cleanerda extension ile vermis ama ordada base var iste. 
