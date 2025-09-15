//
//  SidebarItems.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 03/09/25.
//


import Foundation
import SwiftUI

struct SidebarItem: Identifiable {
    let id = UUID()
    let name: String
    let systemImage: String
    let navigationLink: AnyView
}

let SidebarItems = [
    SidebarItem(name: "Home", systemImage: "house", navigationLink: AnyView(DashboardView())),
    SidebarItem(name: "Settings", systemImage: "gear", navigationLink: AnyView(Text("Not Implemented"))),
    SidebarItem(name: "Add Server", systemImage: "plus", navigationLink: AnyView(AddServerView())),
    SidebarItem(name: "View Servers", systemImage: "cloud.fill", navigationLink: AnyView(ExistingServersView()))
]
