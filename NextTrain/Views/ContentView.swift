//
//  ContentView.swift
//  NextTrain
//
//  Created by Gabriele Scannagatti on 21/09/21.
//

import SwiftUI

func perfomrMiniFetch(a: [Solution], f: MiniFethc) {
    var solutionsA: [String] = []
    for index in 0...a.count-1 {
        solutionsA.append(getTrainId(trainName: a[index].trainlist[0].trainidentifier))
    }
    f.fetch(solutionsNumber: solutionsA)
}

struct ContentView: View {
    
    @State private var departureStation: String = ""
    @State private  var arrivalStation: String = ""
    @StateObject var viewModel = ViewModel()
    @StateObject var miniFetch = MiniFethc()
    var body: some View {
        VStack {
            Section {
                StationView(departureStation: $departureStation, arrivalStation: $arrivalStation)
            }
            .background(Color.clear)
            NavigationView {
                List{
                    if(!viewModel.solutions.isEmpty) {
                        ForEach(viewModel.solutions, id:\.self) { solution in
                            if(Date() < Date(timeIntervalSince1970: TimeInterval(solution.departuretime/1000))) {
                                NavigationLink(destination: SolutionDetailView(solution: solution)){
                                    CardView(card: solution)
                                }
                            }
                        }
                    }
                    else {
                        Text("Nessun treno trovato!")
                    }
                }
                .background(Color.blue)
                .navigationTitle("Treni")
                .onAppear() {
                    viewModel.fetch(d: departureStation, a: arrivalStation)
                }
            }
            .background(Color.blue)
        }
        .onChange(of: departureStation, perform: { value in
            viewModel.fetch(d: departureStation, a: arrivalStation)
        })
        .onChange(of: arrivalStation, perform: { value in
            viewModel.fetch(d: departureStation, a: arrivalStation)
        })
        .onSubmit({
            viewModel.fetch(d: departureStation, a: arrivalStation)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
