//
//  CovidFilterViewController.swift
//  Daily Covid
//
//  Created by Basti Belmonte on 4/25/22.
//

import UIKit

class CovidFilterViewController: UIViewController { 
    
    public var completion: ((USState) -> Void)?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    var states: [USState] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
    }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "US Location Selection"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchUSStates()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
   func fetchUSStates() {
        API.shared.getUSState { [weak self] result in
            switch result {
            case .success(let states):
                self?.states = states
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension CovidFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let uSState = states[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = uSState.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("tapped")
        let uSState = states[indexPath.row]
        completion?(uSState)
        dismiss(animated: true, completion: nil)
    }
    
     }

