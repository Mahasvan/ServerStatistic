//
//  SidebarView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 03/09/25.
//

import SwiftUI

struct SidebarView: View {
    @State private var selectedItem: SidebarItem = SidebarItems[0]
    
    var body: some View {
        List {
            ForEach(SidebarItems) {item in
                NavigationLink(destination: item.navigationLink) {
                    Label(item.name, systemImage: item.systemImage)
                }
            }
        }
            .navigationTitle("Sidebar")
            .listStyle(.sidebar)
    }
}

#Preview {
    SidebarView()
}
