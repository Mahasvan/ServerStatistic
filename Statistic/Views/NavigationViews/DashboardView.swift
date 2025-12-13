//
//  DashboardView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 28/08/25.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var serverModelContext
    @Query(filter: ServerModel.getValidServers())
    private var serverModels: [ServerModel]
    
    var body: some View {
        if serverModels.isEmpty {
            Text("Add your server to get started.")
            NavigationLink(destination: AddServerView()) {
                Text("Add Server")
            }
        } else {
            ScrollView() {
                ForEach(serverModels) { server in
                    VStack {
                        Text(server.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .font(.title2)
                            .bold()
                            .fontDesign(.rounded)
                        DashboardComponentView(serverModel: .constant(server))
                    }
                    Divider()
                }
            }
            .navigationTitle("Dashboard - Statistic")
        }
    }
}

struct DashboardViewPreview: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            Button("Add Items", systemImage: "plus") {
                let vader = ServerModel(scheme: "http", name: "vader", host: "localhost", port: 8005, components: [.CPU, .Disk, .Memory])
                modelContext.insert(vader)
            }
            DashboardView()
        }
        .frame(minWidth: 300, minHeight: 200)
    }
}

#Preview {
    DashboardViewPreview()
        .modelContainer(for: ServerModel.self, inMemory: true)
}
