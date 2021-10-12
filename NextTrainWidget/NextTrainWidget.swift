//
//  NextTrainWidget.swift
//  NextTrainWidget
//
//  Created by Gabriele Scannagatti on 04/10/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func getSnapshot(for configuration: StationIntentIntent, in context: Context, completion: @escaping (TrainEntry) -> Void) {
        let dStation = (configuration.departureStation?.uppercased().replacingOccurrences(of: " ", with: "%20")) ?? "PISA%20CENTRALE"
        let aStation = (configuration.arrivalStation?.uppercased().replacingOccurrences(of: " ", with: "%20")) ?? "PIETRASANTA"
        let urlString = getUrl(d: dStation, a: aStation, hourOffset: 0)
        let url = URL(string: urlString)!
        let data = try! Data.init(contentsOf: url)
        let decoder: JSONDecoder = JSONDecoder.init()
        let solution: [Solution] = try! decoder.decode([Solution].self, from: data)
        //guard let solutionsEntry = try? JSONDecoder().decode([Solution].self, from: solutionsData) else {return}
        let entry = TrainEntry(date: Date(), solution: solution[0])
        completion(entry)
    }
    
    func getTimeline(for configuration: StationIntentIntent, in context: Context, completion: @escaping (Timeline<TrainEntry>) -> Void) {
        let dStation = (configuration.departureStation?.uppercased().replacingOccurrences(of: " ", with: "%20")) ?? "PISA%20CENTRALE"
        let aStation = (configuration.arrivalStation?.uppercased().replacingOccurrences(of: " ", with: "%20")) ?? "PIETRASANTA"
        let urlString = getUrl(d: dStation, a: aStation, hourOffset: 0)
        let url = URL(string: urlString)!
        let data = try! Data.init(contentsOf: url)
        let decoder: JSONDecoder = JSONDecoder.init()
        let solution: [Solution] = try! decoder.decode([Solution].self, from: data)
        var found = false
        var index = 0;
        while(!found) {
            if(Date() > Date(timeIntervalSince1970: TimeInterval(solution[index].departuretime/1000))) {
                index += 1
            }
            else{
                found = true;
            }
        }
        //guard let solutionsEntry = try? JSONDecoder().decode([Solution].self, from: solutionsData) else {return}
        let dateD = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        let entry: TrainEntry = TrainEntry(date: dateD, solution: solution[index])
        let timeLine = Timeline(entries: [entry], policy: .after(Date(timeIntervalSince1970: TimeInterval(solution[index].departuretime/1000))))
        completion(timeLine)
    }
    
    typealias Entry = TrainEntry
    
    typealias Intent = StationIntentIntent
    //@AppStorage("solutionsData", store: UserDefaults(suiteName: "group.Scanna.NextTrain")) var solutionsData: String = ""
    
    func placeholder(in context: Context) -> TrainEntry {
        return TrainEntry(date: Date(), solution: ViewModel.example[0])
    }
}

struct TrainEntry: TimelineEntry {
    var date: Date
    let solution: Solution

struct fooEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            WidgetTrainViewSmall(card: entry.solution)
        case .systemMedium:
            WidgetTrainView(card: entry.solution)
        case .systemLarge:
            EmptyView()
        case .systemExtraLarge:
            EmptyView()
        @unknown default:
            EmptyView()
    }
}

    class SelectDepartureStation: INIntent {
        var departureStation: String?
        var arrivalStation: String?
    }
    
@main
struct foo: Widget {
    let kind: String = "foo"
    let prov = Provider()
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind, intent: StationIntentIntent.self,
            provider: Provider()
        ) { entry in
            fooEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium, .systemSmall])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
    }
}
}
