//
//  WidgetTrainViewSmall.swift
//  NextTrainWidgetExtension
//
//  Created by Gabriele Scannagatti on 05/10/21.
//

import SwiftUI
import WidgetKit

struct WidgetTrainViewSmall: View {
    let card: Solution
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(card.trainlist[0].trainidentifier)
                    .font(.callout)
                    VStack(alignment: .leading) {
                        Text(getDateFromTimeStamp(timeStamp: Double(card.departuretime)))
                            .font(Font.title)
                            .foregroundColor(.teal)
                        Text(card.origin)
                            .font(.body)
                    }
                    VStack(alignment: .leading) {
                        Text(getDateFromTimeStamp(timeStamp: Double(card.arrivaltime)))
                            .font(.title)
                            .foregroundColor(.teal)
                        Text(card.destination)
                            .font(.body)
                    }
            }
        }

    }

struct WidgetTrainViewSmall_Previews: PreviewProvider {
    static var previews: some View {
        WidgetTrainViewSmall(card: ViewModel.example[0])
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}}
    
