//
//  CardView.swift
//  NextTrain
//
//  Created by Gabriele Scannagatti on 23/09/21.
//

import SwiftUI

func getDateFromTimeStamp(timeStamp : Double) -> String {

        let date = NSDate(timeIntervalSince1970: timeStamp / 1000)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "HH:mm"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
}

func getAllTrainForSolution(trains: [Trains]) -> String {
    var res = ""
    for train in trains {
        res += train.trainacronym + " + "
    }
    let index = res.lastIndex(of: "+") ?? res.endIndex
    return  String(res[..<index])
}

func getTrainId(trainName: String) -> String {
    return matches(for: #"(\d+)(?!.*\d)"#, in: trainName)[0]
}

func matches(for regex: String, in text: String) -> [String] {

    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

func getBinarioFromTrainView(myStation: String, fermate: [Fermata]) -> String {
    for fermata in fermate {
        if(fermata.stazione.lowercased().contains(myStation.lowercased()) || myStation.lowercased().contains(fermata.stazione.lowercased())) {
            return fermata.binarioProgrammatoPartenzaDescrizione ?? "N.A."
        }
    }
    return "N.A."
}

struct CardView: View {
    let card: Solution
    @StateObject var trainStatusView = TrainStatus()
    //@StateObject var trainStatusView: TrainStatus
    var body: some View {
        ZStack(alignment:.leading) {
            RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                .fill(Color.gray.opacity(0))
                VStack(alignment: .leading) {
                    HStack {
                        Text(getAllTrainForSolution(trains: card.trainlist))
                            .font(.title3)
                        Spacer()
                        Text("Da: ")
                            .font(.title2)
                        Text(card.minprice == 0 ? "N.A." : String(format: "%.2f", card.minprice) + "€")
                            .font(.title2)
                            .fontWeight(.bold)
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
                        Image(systemName: "train.side.rear.car")
                        Text(String(card.changesno))
                        Image(systemName: "train.side.front.car")
                        Spacer()
                        Image("Railway")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(getBinarioFromTrainView(myStation: card.origin, fermate: trainStatusView.trainStatus?.fermate ?? []))
                        Spacer()
                        Image(systemName: "hourglass.badge.plus")
                            .foregroundColor(.red)
                        Text(String(trainStatusView.trainStatus?.ritardo ?? -1) + "min")
                    }
                    .padding(5)
                }
                .padding(2)
        }
        .onAppear(){
            trainStatusView.fetch(s: getTrainId(trainName: card.trainlist[0].trainidentifier))
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        //CardView(card: ViewModel.example[0], trainStatusView: TrainStatus())
        CardView(card: ViewModel.example[0])
            .previewLayout(.fixed(width: 450, height: 150))
    }
}
