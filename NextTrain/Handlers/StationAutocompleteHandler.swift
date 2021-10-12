//
//  StationAutocompleteHandler.swift
//  NextTrain
//
//  Created by Gabriele Scannagatti on 29/09/21.
//

import Foundation

//API TRENITALIA
//https://www.lefrecce.it/msite/api/geolocations/locations?name=[INIZIALE]
//API VIAGGIATRENO
//http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/autocompletaStazione/[INIZIALE]

class StationModel: ObservableObject {
    @Published var stations: [Station] = []
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                print(jsonData)
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode([Station].self, from: jsonData)
            self.stations = decodedData
        } catch {
            print("decode error")
        }
    }
    
    func loadJs() {
        let data = readLocalFile(forName: "Station.json")
        parse(jsonData: data!)
    }
    
    func fetch(stationName: String) -> [String] {
        var res: [String] = []
        for station in stations {
            res.append(station.stationName)
        }
        return res;
    }

}

struct Station: Hashable, Codable {
    let stationName: String
    let stationId: String
}

