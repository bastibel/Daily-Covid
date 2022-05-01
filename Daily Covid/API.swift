//
//  API.swift
//  Daily Covid
//
//  Created by Basti Belmonte on 4/25/22.
//

import Foundation

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.dateFormat = "YYYY-MM-dd"
    dateFormatter.timeZone = .current
    dateFormatter.locale = .current
    return dateFormatter
}()
    static let tableFormatter: DateFormatter = {
    let tableFormatter = DateFormatter()
        tableFormatter.dateStyle = .medium
        tableFormatter.timeStyle = .none
        tableFormatter.timeZone = .current
        tableFormatter.locale = .current
    return tableFormatter
}()
}
class API {
    static let shared = API()
    
    private init() {}
    
    struct Constants {
        static let statesURL = URL(string: "https://api.covidtracking.com/v2/states.json")
    }
    
    enum DataRange {
        case national
        case uSState(USState)
    }
    
  public func getData(for scope: DataRange, completion: @escaping (Result<[DailyCovidCases], Error>) -> Void) {
        let urlString: String
        switch scope {
        case .national: urlString = "https://api.covidtracking.com/v2/us/daily.json"
        case .uSState(let uSState):
            urlString = "https://api.covidtracking.com/v2/states/\(uSState.state_code.lowercased())/daily.json"
    
        guard let url = URL(string: urlString) else {
        return
        }
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
            }
                do {
                    let result = try JSONDecoder().decode(CovidDataFeedback.self, from: data)
                    print(result.data.count)
                    let dateConverter: [DailyCovidCases] = result.data.compactMap {
                        guard let value = $0.cases?.total.value,
                        let date = DateFormatter.dateFormatter.date(from: $0.date) else {
                            return nil
                        }
                        return DailyCovidCases(date: date, count: value)
                    }
                    completion(.success(dateConverter))
            }
                catch {
                    completion(.failure(error))
            }
            }
        task.resume()
   }
   }
    func getUSState(completion: @escaping (Result<[USState], Error>) -> Void) {
        guard let url = Constants.statesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                //print("\(error?.localizedDescription)")
                return
            }
            do {
                let result = try JSONDecoder().decode(USStateDataFeedback.self, from: data)
                let states = result.data
                completion(.success(states))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
}
    
    public struct USStateDataFeedback: Codable {
         let data: [USState]
     }

    public struct USState: Codable {
         let name: String
         let state_code: String
     }
struct CovidDataFeedback: Codable {
    let data: [DailyCases]
}
struct DailyCases: Codable {
    let cases: Cases?
    let date: String
}
struct Cases: Codable {
    let total: TotalCases
}
struct TotalCases: Codable {
    let value: Int?
}
struct DailyCovidCases {
    let date: Date
    let count: Int
}
