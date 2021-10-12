//
//  RequestHandler.swift
//  NextTrain
//
//  Created by Gabriele Scannagatti on 28/09/21.
//
import Foundation
import SwiftUI

func getUrl(d: String, a: String, hourOffset: Int) -> String {
    let departure = d.uppercased().replacingOccurrences(of: " ", with: "%20")
    let arrival = a.uppercased().replacingOccurrences(of: " ", with: "%20")
    
    let date = Date()
    let calendar = NSCalendar.current
    let hour = calendar.component(.hour, from: date) + hourOffset
    let urlString = "https://www.lefrecce.it/msite/api/solutions?origin="+departure+"&destination="+arrival+"&arflag=A&adate="+date.getFormattedDate(format: "dd/MM/yyyy")+"&atime="+String(hour)+"&adultno=1&childno=0&direction=A&frecce=false&onlyRegional=false"
    
    return urlString
}

class ViewModel: ObservableObject {
    @AppStorage("solutionsData", store: UserDefaults(suiteName: "group.Scanna.NextTrain")) var solutionsData: String = "" //?? URL("https://www.lefrecce.it/msite/api/solutions?origin=PISA%CENTRALE&destination=PIETRASANTA&arflag=A&adate="+Date().getFormattedDate(format: "dd/MM/yyyy")+"&atime="+String(NSCalendar.current.component(.hour, from: Date()))+"&adultno=1&childno=0&direction=A&frecce=false&onlyRegional=false")
    @Published var solutions: [Solution] = []
    static var example: [Solution] = [
        Solution(idsolution: "451917a0f6cf8636c7f8460cf4d236bdi0", origin: "Pisa Centrale", destination: "Pietrasanta", direction: "A", departuretime: 1582891800000, arrivaltime: 1582918020000, minprice: 4.70, optionaltect: nil, duration: "40", changesno: 0, bookable: false, saleable: false, trainlist: [Trains(trainidentifier: "Frecciarossa 9539", trainacronym: "FR", traintype: "F", pricetype: "F")], onlycustom: false, extraInfo: nil, showSeat: false, specialOffer: nil, transportMeasureList: nil)
    ]
    
    func fetch(d: String, a:String) {
        
        self.solutions = []
        
        guard let url = URL(string: getUrl(d: d, a: a, hourOffset: 0)) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in guard let data = data, error == nil else{
            return
        }
        //Convert To JSON
        do{
            let solutions = try JSONDecoder().decode([Solution].self, from: data)
            DispatchQueue.main.async {
                self?.solutions = solutions
                //self?.solutionsData = self!.getUrl(d: d, a: a, hourOffset: 0)
                print(data)
                
            }
        }
        catch{
            print(error)
        }
        }
        task.resume()
    }
    
    func fetch() {
        fetch(d: "Pisa Centrale", a: "Pietrasanta")
    }

}

struct Solution: Hashable, Codable {
    let idsolution: String
    let origin: String
    let destination: String
    let direction: String
    let departuretime: Int
    let arrivaltime: Int
    let minprice: Double
    let optionaltect: String?
    let duration: String
    let changesno: Int
    let bookable: Bool
    let saleable: Bool
    let trainlist: [Trains]
    let onlycustom: Bool
    let extraInfo: [String]?
    let showSeat: Bool
    let specialOffer: String?
    let transportMeasureList: [String]?
    
    
}

struct Trains: Hashable, Codable {
    let trainidentifier: String
    let trainacronym: String
    let traintype: String
    let pricetype: String
    
}
