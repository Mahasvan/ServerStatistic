//
//  ComponentStatusWidget.swift
//  ComponentStatusWidget
//
//  Created by Mahasvan Mohan on 01/12/25.
//

import WidgetKit
import SwiftUI
import SwiftData

@MainActor
struct ComponentStatusProvider: TimelineProvider {
    
    var value1: Float?
    var value2: Float?
    
    func loadValues() -> (Float?, Float?) {
        let context = SharedModelContainer.container.mainContext

        // Example: Fetch latest ServerModel entry
        let items = try? context.fetch(FetchDescriptor<ServerModel>())

        // todo: need to select which model to query
        let model = items?.first
        var componentViewModel = ComponentViewModel()
        

        return (value1, value2)
   }

    
    func getSnapshot(in context: Context, completion: @escaping @Sendable (ComponentEntry) -> Void) {
        let date = Date()
        let entry = ComponentEntry(date: date, value1: value1, value2: value2)
        completion(entry)
    }
    
    
    func placeholder(in context: Context) -> ComponentEntry {
        let date = Date()
        return ComponentEntry(date: date, value1: value1, value2: value2)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ComponentEntry>) -> Void) {
        let date = Date()
        let entry = ComponentEntry(date: date, value1: value1, value2: value2)
        
        let nextUpdateDate = Calendar.current.date(byAdding: .second, value: 5, to: date)
        
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate!))
        completion(timeline)
    }
}

struct ComponentEntry: TimelineEntry {
    var date: Date
    let value1: Float?
    let value2: Float?
}

struct ComponentStatusEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var componentEntry: ComponentEntry

    @ViewBuilder
    var body: some View {
        CPUComponentView(usage: .constant(componentEntry.value1) , temp: .constant(componentEntry.value2))
    }
}

struct ComponentStatusWidget: Widget {
    let kind: String = "ComponentStatusWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: ComponentStatusProvider()) { entry in
            ComponentStatusEntryView(componentEntry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}
