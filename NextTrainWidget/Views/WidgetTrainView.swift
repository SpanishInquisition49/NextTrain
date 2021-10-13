//
//  WidgetTrainView.swift
//  NextTrain
//
//  Created by Gabriele Scannagatti on 04/10/21.
//

import SwiftUI
import WidgetKit

struct WidgetTrainView: View {
    let card: Solution
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                HStack {
                    Text(card.trainlist[0].trainidentifier)
                        .font(.title3)
                    Spacer()
                    Text("Da: ")
                        .font(.title2)
                    Text(card.minprice == 0 ? "N.A." : String(format: "%.2f", card.minprice) + "€")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text(getDateFromTimeStamp(timeStamp: Double(card.departuretime)))
                            .font(Font.title2)
                            .foregroundColor(.teal)
                        Text(card.origin + " ")
                            .font(.subheadline)
                    }
                    Spacer()
                    Text("- " + card.duration + " -")
                        .font(.caption)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(getDateFromTimeStamp(timeStamp: Double(card.arrivaltime)))
                            .font(.title2)
                            .foregroundColor(.teal)
                        Text(card.destination + " ")
                            .font(.subheadline)
                    }
                }
                .padding(5)
                HStack {
                    Text("Cambi:" + String(card.changesno))
                }
                .padding(5)
                
            }
            .padding(10)
    }
}

struct WidgetTrainView_Previews: PreviewProvider {
    
    static var previews: some View {
        WidgetTrainView(card: ViewModel.example[0])
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

}
