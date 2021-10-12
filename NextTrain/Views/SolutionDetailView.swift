//
//  SolutionDetailView.swift
//  NextTrain
//
//  Created by Gabriele Scannagatti on 04/10/21.
//

import SwiftUI

struct SolutionDetailView: View {
    let solution: Solution
    @StateObject var detailsView = DetailModel()
    var body: some View {
        VStack {
            List {
                ForEach(detailsView.solutionDetails, id: \.self) { detail in
                    ZStack(alignment:.leading) {
                        RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                            .fill(Color.gray.opacity(0))
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(detail.trainidentifier)
                                        .font(.title3)
                                    Spacer()
                                }
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(getDateFromTimeStamp(timeStamp: Double(detail.departuretime)))
                                            .font(Font.title2)
                                            .foregroundColor(.teal)
                                        Text(detail.departurestation + " ")
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                    Text("--- " + detail.duration + " ---")
                                        .font(.caption)
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text(getDateFromTimeStamp(timeStamp: Double(detail.arrivaltime)))
                                            .font(.title2)
                                            .foregroundColor(.teal)
                                        Text(detail.arrivalstation + " ")
                                            .font(.subheadline)
                                    }
                                }
                                .padding(5)
                            }
                            .padding(2)
                    }
                }
            }
        }
        .onAppear() {
            detailsView.fetch(idSolution: solution.idsolution)
        }
    }

}

struct SolutionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SolutionDetailView(solution: ViewModel.example[0])
    }
}
