//
//  ListViewController.swift
//  HomeWork 10 Network 10.04.2025
//
//  Created by Dmitry on 10.04.25.
//
import UIKit
import Foundation


class ListViewController: UITableViewController {
    
    private var cats: [CatImage] = [] // массив для хранения данных
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
           loadCats() // Загружаем данные при запуске
       }
    
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.addTarget(self, action: #selector(refreshCats(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshCats(_ sender: UIRefreshControl) {
        NetworkService.shared.fetchTenCats { [weak self] result in
            DispatchQueue.main.async {
                sender.endRefreshing()
                switch result {
                case .success(let newCats):
                    self?.cats = newCats
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showErrorAlert(error: error)
                }
            }
        }
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
            )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        present(alert, animated: true)
    }
    
    
    
    private func loadCats() {
        NetworkService.shared.fetchTenCats { [weak self] (result: Result<[CatImage], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cats):
                    self?.cats = cats
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Ошибка: \(error.localizedDescription)")
                    let alert = UIAlertController(
                        title: "Ошибка",
                        message: error.localizedDescription,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    // MARK: - TableView Methods
    
       
    // 1 секция
        override func numberOfSections(in tableView: UITableView) -> Int { 1 }

        // количество ячеек
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return cats.count
        }

    
    // Создание ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatTableViewCell
        let cat = cats[indexPath.row]
        
        cell.breedLabel.text = cat.breeds?.first?.name ?? "Порода неизвестна"
        cell.catImageView.loadImage(from: cat.url) // загрузка картинки
        
        return cell
        
    }
    
    
        // Высота ячейки
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
             return 70
            
        }

        
       
   }

