//
//  MiniFetch.swift
//  NextTrain
//
//  Created by Gabriele Scannagatti on 07/10/21.
//

import Foundation
import SwiftUI

class MiniFethc: ObservableObject {
    @Published var res: [String]? = []
    
    func fetch(solutionsNumber: [String]) {
        for index in 0...solutionsNumber.count-1 {
            self.getFetchCodes(trainNumber: solutionsNumber[index])
            print("Res["+String(index)+"]: " + self.res![index])
            }
        }
    
    func getFetchCodes(trainNumber: String) {
        guard let url = URL(string: "https://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/cercaNumeroTrenoTrenoAutocomplete/" + trainNumber) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in guard let data = data, error == nil else{
            return
        }
            let dataString = String(decoding: data, as: UTF8.self)
            print("DATI PRESI DALLA FETCH: " +  dataString)
            DispatchQueue.main.async {
                self?.res?.append(dataString)
                //print(dataString)
            }
    }
        task.resume()
    }
}
