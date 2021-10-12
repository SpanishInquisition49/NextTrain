//
//  DetailHandler.swift
//  NextTrain
//
//  Created by Gabriele Scannagatti on 04/10/21.
//

import Foundation
//https://www.lefrecce.it/msite/api/solutions/451917a0f6cf8636c7f8460cf4d236bdi0/info

class DetailModel: ObservableObject {
    @Published var solutionDetails: [Details] = []
    
    func fetch(idSolution: String) {
        
        self.solutionDetails = []
        
        guard let url = URL(string: getUrl(idSolution: idSolution)) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in guard let data = data, error == nil else{
            return
        }
        //Convert To JSON
        do{
            let solutions = try JSONDecoder().decode([Details].self, from: data)
            DispatchQueue.main.async {
                self?.solutionDetails = solutions
                
            }
        }
        catch{
            print(error)
        }
        }
        task.resume()
    }
    
    private func getUrl(idSolution: String) -> String {
        let urlString = "https://www.lefrecce.it/msite/api/solutions/"+idSolution+"/info"
        return urlString
    }
}

struct Details: Hashable, Codable {
    let idsolution: String
    let idleg: String
    let direction: String
    let trainidentifier: String
    let trainacronym: String
    let departurestation: String
    let departuretime: Int
    let arrivalstation: String
    let arrivaltime: Int
    let duration: String
}
