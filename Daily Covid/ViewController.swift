//
//  ViewController.swift
//  Daily Covid
//
//  Created by Basti Belmonte on 4/25/22.
//

import UIKit
import Charts

class ViewController: UIViewController {
    @IBOutlet weak var covidImage: UIImageView!
    
    
    let tableView: UITableView = {
        let dataTable = UITableView(frame: .zero)
        dataTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return dataTable
    }()
    
    var dailyCovidCases: [DailyCovidCases] = [] {
        didSet {
            DispatchQueue.main.async {
                self.generateGraph()
                self.tableView.reloadData()
            }
        }
    }
    
    var range: API.DataRange = .national
    
    var states: [USState] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableOrganizer()
        fetchUSStates()
        generateFilterButton()
        //configureItems()
        title = "US Covid Count"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "house"), style: .done, target: self, action: #selector(homeTapped))

    }
        
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        }
        
//    func configureItems() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "house"), style: .done, target: self, action: #selector(homeTapped))
        
        @objc func homeTapped() {
            dismiss(animated: true, completion: nil)
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: nil)
    }
    
    
    func generateGraph() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        tableView.tableHeaderView = headerView
        headerView.clipsToBounds = true
        var entries: [BarChartDataEntry] = []
        let barLimitter = dailyCovidCases.prefix(150)
        for index in 0..<barLimitter.count {
            let data = barLimitter[index]
            entries.append(.init(x: Double(index), y: Double(data.count)))
            }
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.colors = [NSUIColor(cgColor: UIColor.systemBlue.cgColor)]
        let data: BarChartData = BarChartData(dataSet: dataSet)
        let chart = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        chart.data = data
        headerView.addSubview(chart)


    }

    func tableOrganizer() {
            view.addSubview(tableView)
            tableView.dataSource = self
        }
    
    func fetchUSStates() {
        API.shared.getData(for: range) { [weak self] result in
             switch result {
             case .success(let dailyCovidCases):
                 self?.dailyCovidCases = dailyCovidCases
             case .failure(let error):
                 print(error)
             }
         }
     }
    
//   private func fetchUSStates() {
//       API.shared.getUSState(completion: <#T##(Result<[USState], Error>) -> Void#>for: range) { [weak self] result in
//            switch result {
//            case .success(let dailyCovidCases):
//                print("\(dailyCovidCases.count)")
//                self?.dailyCovidCases = dailyCovidCases
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    func generateFilterButton() {
        let buttonName: String = {
            switch range {
            case .national: return "Find Location"
            case .uSState(let uSState): return uSState.name
            }
        }()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: buttonName, style: .done, target: self, action: #selector(filterTapped)) }
    
    @objc private func filterTapped() {
        let controller = CovidFilterViewController()
        controller.completion = { [weak self] uSState in
            self?.range = .uSState(uSState)
            self?.fetchUSStates()
            self?.generateFilterButton()
        }
        let nController = UINavigationController(rootViewController: controller)
        present(nController, animated: true)
    }
}
       
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dailyCovidCases.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let data = dailyCovidCases[indexPath.row]
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = textFunction(with: data)
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            print("tapped")
    }
    
    func textFunction(with data: DailyCovidCases) -> String? {
            let dateView = DateFormatter.tableFormatter.string(from: data.date)
            return "\(dateView): \(data.count)"
        }
}

        
        
        
        
        
        

//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return states.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let uSState = states[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = uSState.name
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let uSState = states[indexPath.row]
//        //completion?(uSState)
//        dismiss(animated: true, completion: nil)
//    }
    
