//
//  CPUWidget.swift
//  CPUWidget
//
//  Created by Mahasvan Mohan on 01/12/25.
//

import SwiftUI
import WidgetKit

func formatFloatAsInt(_ value: Float?) -> String {
    if value != nil {
        return String(Int(value!))
    }
    return "?"
}


struct CPUShortView: View {

    @Binding var usage: Float?
    @Binding var temp: Float?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "cpu")
                    .scaleEffect(1.5)
                Text("CPU")
                    .font(.title2)
            }
            HStack(spacing: 0.0) {
                Text(formatFloatAsInt(usage))
                Text("%")
                    .font(.system(size: 20, weight: .bold))
            }
            .font(.system(size: 40, weight: .bold))
            Text("\(formatFloatAsInt(temp))°C")
//                .font(.system(size: 30, weight: .bold))
        }
//        .frame(width: 120, height: 120)
    }
}

struct CPUEntry: TimelineEntry {
    var date: Date
    let usage: Float?
    let temp: Float?
}

struct CPUStatusProvider: TimelineProvider {
    
    var CPUUsage: Float?
    var CPUTemp: Float?
    
    func getSnapshot(in context: Context, completion: @escaping @Sendable (CPUEntry) -> Void) {
        let date = Date()
        let entry = CPUEntry(date: date, usage: CPUUsage, temp: CPUTemp)
        completion(entry)
    }
    
    
    func placeholder(in context: Context) -> CPUEntry {
        let date = Date()
        return CPUEntry(date: date, usage: 10, temp: 12)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CPUEntry>) -> Void) {
        let date = Date()
        let entry = CPUEntry(
            date: date,
            usage: 10,
            temp: 12
        )
        
        let nextUpdateDate = Calendar.current.date(byAdding: .second, value: 5, to: date)
        
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate!))
        completion(timeline)
    }
}

struct CPUStatusView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var CPUStatus: CPUEntry

    @ViewBuilder
    var body: some View {
        CPUShortView(usage: .constant(CPUStatus.usage), temp: .constant(CPUStatus.temp))
    }
}


struct CPUWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "com.mahas.CPUstatusWidget",
            provider: CPUStatusProvider()
        ) { entry in
            CPUStatusView(CPUStatus: entry)
        }
    }
}


#Preview(as: .systemMedium, widget: {
    CPUWidget()
}, timeline: {
    CPUEntry(date: Date(), usage: 50, temp: 50)
})
