//
//  StationView.swift
//  NextTrain
//
//  Created by Gabriele Scannagatti on 23/09/21.
//
import Swift
import SwiftUI
import CoreGraphics

func swapStation(a: inout String, b: inout String) -> Void {
    var t: String
    t = a
    a = b
    b = t
}

struct StationView: View {
    @Binding var departureStation: String
    @Binding var arrivalStation: String
    var body: some View {
        HStack {
            Section{
                VStack {
                    HStack {
                        VStack {
                            TextField(
                                "Stazione di partenza",
                                 text: $departureStation
                            )
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(.roundedBorder)
                            TextField(
                                "Stazione di arrivo",
                                 text: $arrivalStation
                            )
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(.roundedBorder)
                        }
                        Button(action: { swapStation(a: &departureStation, b: &arrivalStation) }, label: {
                            Label {} icon: {
                                Image(systemName: "arrow.up.arrow.down")
                            }
                        }).submitScope()
                    }
                }
            }
        }
        .padding(10)
        
 }
}

struct StationView_Previews: PreviewProvider {
    static var previews: some View {
        StationView(departureStation: .constant(""), arrivalStation: .constant(""))
    }
}
