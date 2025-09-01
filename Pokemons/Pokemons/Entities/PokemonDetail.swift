//
//  PokemonDetail.swift
//  Pokemons
//
//  Created by tunc on 27.08.2025.
//

import Foundation

final class PokemonDetail {
  let title: String
  let name: String
  let imageURLString: String?
  let abilities: [String]
  let types: [String]
  let stats: [PokemonStatSlot]
  let galleryImageURLStrings: [String]
  let bioText: String?
  
  let isAbilitiesExpanded: Bool
  let isTypesExpanded: Bool
  let isStatsExpanded: Bool
  let isGalleryExpanded: Bool
  let isBioExpanded: Bool
  
  init(title: String, name: String, imageURLString: String?, abilities: [String], types: [String], stats: [PokemonStatSlot], galleryImageURLStrings: [String], bioText: String?, isAbilitiesExpanded: Bool, isTypesExpanded: Bool, isStatsExpanded: Bool, isGalleryExpanded: Bool, isBioExpanded: Bool) {
    self.title = title
    self.name = name
    self.imageURLString = imageURLString
    self.abilities = abilities
    self.types = types
    self.stats = stats
    self.galleryImageURLStrings = galleryImageURLStrings
    self.bioText = bioText
    self.isAbilitiesExpanded = isAbilitiesExpanded
    self.isTypesExpanded = isTypesExpanded
    self.isStatsExpanded = isStatsExpanded
    self.isGalleryExpanded = isGalleryExpanded
    self.isBioExpanded = isBioExpanded
  }
}
