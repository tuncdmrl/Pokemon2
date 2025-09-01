//
//  PokemonDetailPresenter.swift
//  Pokemons
//
//  Created by tunc on 11.08.2025.
//

import UIKit

enum PokemonDetailSection: Int, CaseIterable {
  case name, image, abilities, types, stats, gallery, bio
  
  var baseHeight: CGFloat {
    switch self {
    case .name: return 50
    case .image: return 175
    case .stats: return 150
    case .gallery: return 250
    case .bio: return 250
    default: return 44
    }
  }
}
final class PokemonDetailPresenter {
  weak var view: PokemonDetailView?
  var interactor: PokemonDetailInteractorInput!
  var router: PokemonDetailWireframe!

  private var isAbilitiesExpanded = false
  private var isTypesExpanded     = false
  private var isStatsExpanded     = false
  private var isGalleryExpanded   = false
  private var isBioExpanded       = false
  
  private var detail: PokemonDetailResponse?
  private var species: PokemonSpeciesResponse?
  
  var pokemonID: Int!
  
  private func englishFlavor(from species: PokemonSpeciesResponse?) -> String? {
    guard let species else { return nil }
    return species.flavorTextEntries
      .first(where: { $0.language.name == "en" })?
      .flavorText
      .replacingOccurrences(of: "\n", with: " ")
      .replacingOccurrences(of: "\u{000c}", with: " ")
  }
  
  private func buildVM() -> PokemonDetail? {
    guard let detail = detail else { return nil }
    
    let nameCap = detail.name.capitalized
    let title = "Pokemons"
    
    let cover = detail.sprite.frontDefault
    
    let gallery: [String] = [
      detail.sprite.frontDefault,
      detail.sprite.backDefault,
      detail.sprite.frontShiny,
      detail.sprite.backShiny
    ].compactMap { $0 }
    
    let types = detail.types.map { $0.type.name.capitalized }
    let abilities = detail.abilities.map { $0.ability.name.capitalized }
    
    let stats = detail.stats
    
    let bio = englishFlavor(from: species)
    
    return PokemonDetail(
      title: title,
      name: nameCap,
      imageURLString: cover,
      abilities: abilities,
      types: types,
      stats: stats,
      galleryImageURLStrings: gallery,
      bioText: bio,
      isAbilitiesExpanded: isAbilitiesExpanded,
      isTypesExpanded: isTypesExpanded,
      isStatsExpanded: isStatsExpanded,
      isGalleryExpanded: isGalleryExpanded,
      isBioExpanded: isBioExpanded
    )
  }
   func renderIfPossible() {
    guard let viewData = buildVM() else { return }
    view?.render(viewModel: viewData)
  }
}

extension PokemonDetailPresenter: PokemonDetailPresentation {
  func viewDidLoad() {
    view?.setupUI()
    view?.showLoading(true)
    interactor.fetchPokemonDetail(id: pokemonID)
    interactor.fetchPokemonSpecies(id: pokemonID)
  }
  
  func buttonToggle(section: PokemonDetailSection) {
    switch section {
    case .abilities: isAbilitiesExpanded.toggle()
    case .types:     isTypesExpanded.toggle()
    case .stats:     isStatsExpanded.toggle()
    case .gallery:   isGalleryExpanded.toggle()
    case .bio:       isBioExpanded.toggle()
    default: break
    }
    if let viewData = buildVM() {
      view?.render(viewModel: viewData)
      view?.reloadRow(for: section)
    }
  }
  
  func tapImage(at index: Int) {
  }
  
  func tapRetry() {
    interactor.refreshAll(id: pokemonID)
  }
  
  func backButtonTapped() {
    router.pop()
  }
}
extension PokemonDetailPresenter: PokemonDetailInteractorOutput {
  func fetchDetail(_ detail: PokemonDetailResponse) {
    
    self.detail = detail
    view?.showLoading(false)
    renderIfPossible()
  }
  
  func fetchSpecies(_ species: PokemonSpeciesResponse) {
    self.species = species
    renderIfPossible()
  }
  
  func failToFetchDetail(_ error: Error) {
    view?.showLoading(false)
    view?.showError("Detay alınamadı: \(error.localizedDescription)")
  }
  
  func failToFetchSpecies(_ error: Error) {
    renderIfPossible()
  }
}
