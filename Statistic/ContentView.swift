//
//  ContentView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/08/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            SidebarItems[0].navigationLink
        }
        .frame(minWidth: 700, minHeight: 500)
        .modelContainer(for: [ServerModel.self])
    }
}

#Preview {
    ContentView()
}
