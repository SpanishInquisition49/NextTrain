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
     // UnComment below to get only time
    //  dayTimePeriodFormatter.dateFormat = "hh:mm a"

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

/*func timeIntervalStringFromString(s: String) -> String{
    var dfmatter = DateFormatter()
    dfmatter.dateFormat="HH:mm"
    var date = dfmatter.date(from: s)
    var dateStamp:TimeInterval = date!.timeIntervalSince1970
}*/

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

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

struct CardView: View {
    let card: Solution
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
                .padding(2)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: ViewModel.example[0])
            .previewLayout(.fixed(width: 450, height: 80))
    }
}
