//
//  PokemonDetailViewController.swift
//  Pokemons
//
//  Created by tunc on 11.08.2025.
//

import UIKit
import Kingfisher

final class PokemonDetailViewController: UIViewController {
  @IBOutlet weak var detailTableView: UITableView!
  
  private var currentVM: PokemonDetail?
  
  private var isAbilitiesExpanded = false
  private var isTypesExpanded     = false
  private var isStatsExpanded     = false
  private var isGalleryExpanded   = false
  private var isBioExpanded       = false
  
  var presenter: PokemonDetailPresentation!
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    presenter.viewDidLoad() 
  }
  
  @objc private func closeButtonTapped() {
    presenter.backButtonTapped()
  }
}

extension PokemonDetailViewController: PokemonDetailView {

  func setupUI() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
    
    let cellsToRegister: [(String, String)] = [
      ("NameCell", "detailNameCell"),
      ("ImageCell", "detailImageCell"),
      ("AbilityCell", "detailAbilityCell"),
      ("TypeCell", "detailTypeCell"),
      ("StatsCell", "detailStatsCell"),
      ("GalleryCell", "detailGalleryCell"),
      ("BioPokemonsCell", "BioPokemonsCell")
    ]
    
    for (nib, id) in cellsToRegister {
      detailTableView.register(UINib(nibName: nib, bundle: nil), forCellReuseIdentifier: id)
    }
  }
  
  func setTitle(_ text: String) { title = text }
  
  func showLoading(_ isLoading: Bool) {
    detailTableView.isHidden = isLoading
  }
  
  func render(viewModel: PokemonDetail) {
    currentVM = viewModel
    
    isAbilitiesExpanded = viewModel.isAbilitiesExpanded
    isTypesExpanded     = viewModel.isTypesExpanded
    isStatsExpanded     = viewModel.isStatsExpanded
    isGalleryExpanded   = viewModel.isGalleryExpanded
    isBioExpanded       = viewModel.isBioExpanded
    
    setTitle(viewModel.title)
    detailTableView.reloadData()
  }
  
  func reloadRow(for section: PokemonDetailSection) {
    let ip = IndexPath(row: section.rawValue, section: 0)
    detailTableView.beginUpdates()
    detailTableView.reloadRows(at: [ip], with: .automatic)
    detailTableView.endUpdates()
  }
  
  func showError(_ message: String) {
    let ac = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Tamam", style: .default))
    present(ac, animated: true)
  }
}

extension PokemonDetailViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    PokemonDetailSection.allCases.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let section = PokemonDetailSection(rawValue: indexPath.row) else { return 44 }
    switch section {
    case .abilities:
      let count = currentVM?.abilities.count ?? 0
      return dynamicHeight(for: section, expanded: isAbilitiesExpanded, count: count)
    case .types:
      let count = currentVM?.types.count ?? 0
      return dynamicHeight(for: section, expanded: isTypesExpanded, count: count)
    case .stats:
      return dynamicHeight(for: section, expanded: isStatsExpanded)
    case .gallery:
      return dynamicHeight(for: section, expanded: isGalleryExpanded)
    case .bio:
      return dynamicHeight(for: section, expanded: isBioExpanded)
    default:
      return section.baseHeight
    }
  }
  
  private func dynamicHeight(for section: PokemonDetailSection, expanded: Bool, count: Int = 0) -> CGFloat {
    switch section {
    case .abilities, .types:
      return expanded && count > 0 ? CGFloat(count) * 30 + 44 + 10 : 44
    case .stats, .gallery, .bio:
      return expanded ? section.baseHeight : 44
    default:
      return section.baseHeight
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let vm = currentVM,
          let section = PokemonDetailSection(rawValue: indexPath.row) else {
      return UITableViewCell()
    }
    
    switch section {
    case .name:
      let cell = tableView.dequeueReusableCell(withIdentifier: "detailNameCell", for: indexPath) as! NameCell
      cell.configure(name: vm.name)
      return cell
      
    case .image:
      let cell = tableView.dequeueReusableCell(withIdentifier: "detailImageCell", for: indexPath) as! ImageCell
      cell.configure(with: vm.imageURLString!) // <- DÜZGÜN İMZA
      return cell
      
    case .abilities:
      let cell = tableView.dequeueReusableCell(withIdentifier: "detailAbilityCell", for: indexPath) as! AbilityCell
      cell.configure(with: vm.abilities, expanded: isAbilitiesExpanded)
      cell.onToggle = { [weak self] in self?.presenter.buttonToggle(section: .abilities) }
      return cell
      
    case .types:
      let cell = tableView.dequeueReusableCell(withIdentifier: "detailTypeCell", for: indexPath) as! TypeCell
      cell.configure(with: vm.types, expanded: isTypesExpanded)
      cell.toggleButtonTapped = { [weak self] in self?.presenter.buttonToggle(section: .types) }
      return cell
      
    case .stats:
      let cell = tableView.dequeueReusableCell(withIdentifier: "detailStatsCell", for: indexPath) as! StatsCell
      cell.configure(with: vm.stats, expanded: isStatsExpanded) // [PokemonStatSlot]
      cell.toggleButtonTapped = { [weak self] in self?.presenter.buttonToggle(section: .stats) }
      return cell
      
    case .gallery:
      let cell = tableView.dequeueReusableCell(withIdentifier: "detailGalleryCell", for: indexPath) as! GalleryCell
      cell.configure(with: vm.galleryImageURLStrings, expanded: isGalleryExpanded, pokemonName: vm.name)
      cell.toggleButtonTapped = { [weak self] in self?.presenter.buttonToggle(section: .gallery) }
      return cell
      
    case .bio:
      let cell = tableView.dequeueReusableCell(withIdentifier: "BioPokemonsCell", for: indexPath) as! BioPokemonsCell
      if let text = vm.bioText {
        cell.configure(with: text, isExpanded: isBioExpanded)
        cell.onToggle = { [weak self] in self?.presenter.buttonToggle(section: .bio) }
      }
      return cell
    }
  }
}
