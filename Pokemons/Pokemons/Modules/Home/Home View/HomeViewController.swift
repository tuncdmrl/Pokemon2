//
//  HomeViewController.swift
//  Pokemons
//
//  Created by tunc on 15.07.2025.
//

import UIKit

final class HomeViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  private var pokemons: [Pokemon] = []
  
  private var activityIndicatorView: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    activityIndicatorView.hidesWhenStopped = true
    
    return activityIndicatorView
  }()
  
  var presenter: HomePresentation!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.viewDidLoad()
  }
}

extension HomeViewController: HomeView{
  func setupUI() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
    navigationItem.title = "Pokemons"

    let nib = UINib(nibName: "PokemonTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "PokemonTableViewCell")
  }
  
  func showLoading(_ isLoading: Bool) {
    isLoading ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
  }
  
  func showInitialPokemons(_ pokemons: [Pokemon]) {
    self.pokemons = pokemons
    
    tableView.reloadData()
  }
  
  func appendPokemon(_ newPokemons: [Pokemon]) {
      let currentCount = self.pokemons.count
      
      self.pokemons.append(contentsOf: newPokemons)
      
      var indexPaths: [IndexPath] = []
      for PokemonNumber in 0..<newPokemons.count {
          indexPaths.append(IndexPath(row: currentCount + PokemonNumber, section: 0))
      }
            
      DispatchQueue.main.async {
          self.tableView.performBatchUpdates({
              self.tableView.insertRows(at: indexPaths, with: .none)
          }, completion: { finished in })
      }
  }
  
  func showError(_ message: String) {
    let alertController = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Tekrar Dene", style: .default, handler: { [weak self] _ in
      self?.presenter.retry()
    }))
    
    alertController.addAction(UIAlertAction(title: "Kapat", style: .cancel))
    
    present(alertController, animated: true)
  }
}

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    pokemons.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableViewCell", for: indexPath) as! PokemonTableViewCell
    let pokemon = pokemons[indexPath.row]
    
    cell.configure(with: pokemon)
    
    return cell
  }
}

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    100
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    presenter.selectRow(indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    presenter.willDisplayRow(indexPath.row)
  }
}
