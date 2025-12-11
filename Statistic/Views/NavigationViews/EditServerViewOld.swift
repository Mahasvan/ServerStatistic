//
//  EditServerView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 15/09/25.
//

import SwiftUI

struct EditServerViewOld: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var server: ServerModel
    
    @State var newServer: ServerModel?
    @State var cpu = true
    @State var memory = true
    @State var disk = true
    
    @State private var isShowingAlert = false
    
    func setValues() {
        self.newServer = server
        self.cpu = server.components.contains("CPU")
        self.disk = server.components.contains("Disk")
        self.memory = server.components.contains("Memory")
    }
    
    func saveServer() {
//        newServer?.components.removeAll()
//        if cpu {newServer?.components.append("CPU")}
//        if disk {newServer?.components.append("Disk")}
//        if memory {newServer?.components.append("Memory")}
//        
        if let unwrappedServer = newServer {
            modelContext.delete(server)
            modelContext.insert(unwrappedServer)
        }
    }
    
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        VStack {
            TextField("Server Nickname", text: Binding(
                get: {newServer?.name ?? ""},
                set: {newServer?.name = $0})
            )
            TextField("Server Host", text: Binding(
                get: {newServer?.host ?? ""},
                set: {newServer?.host = $0})
            )
            TextField("Server Port",
                      value: Binding(
                        get: {newServer?.port ?? 0},
                        set: {newServer?.port = $0}),
                      formatter: numberFormatter
            )
            
            Toggle(isOn: Binding(
                get: {newServer?.components.contains("CPU") ?? true},
                set: {
                    if $0 {
                        // the toggle is on
                        if ((newServer?.components.contains("CPU") ?? true) == false) {newServer?.components.append("CPU")}
                    } else {
                        // the toggle is off
                        if ((newServer?.components.contains("CPU") ?? false) == true) {newServer?.components = newServer?.components.filter { $0 != "CPU"} ?? []}
                    }
                })
            ) {
                Text("CPU")
            }
            
            Toggle(isOn: Binding(
                get: {newServer?.components.contains("Disk") ?? true},
                set: {
                    if $0 {
                        // the toggle is on
                        if ((newServer?.components.contains("Disk") ?? true) == false) {newServer?.components.append("Disk")}
                    } else {
                        // the toggle is off
                        if ((newServer?.components.contains("Disk") ?? false) == true) {newServer?.components = newServer?.components.filter { $0 != "Disk"} ?? []}
                    }
                })
            ) {
                Text("Disk")
            }
            
            Toggle(isOn: Binding(
                get: {newServer?.components.contains("Memory") ?? true},
                set: {
                    if $0 {
                        // the toggle is on
                        if ((newServer?.components.contains("Memory") ?? true) == false) {newServer?.components.append("Memory")}
                    } else {
                        // the toggle is off
                        if ((newServer?.components.contains("Memory") ?? false) == true) {newServer?.components = newServer?.components.filter { $0 != "Memory"} ?? []}
                    }
                })
            ) {
                Text("Memory")
            }

            
            Button("Save") {
                saveServer()
                isShowingAlert = true
            }
            .alert("Updated!", isPresented: $isShowingAlert) {
                Button("OK", role: .cancel) {}
                    .modifier(GlassButton())
            }
            .modifier(GlassButton())
        }
        .onAppear(perform: setValues)
        .frame(maxWidth: 500)
        .navigationTitle("Editing Server - \(server.name)")
    }
}

#Preview {
    let server = ServerModel(scheme: "http", name: "New Name", host: "Hi", port: 123, components: [.CPU, .Disk])
    EditServerView(server: .constant(server))
        .modelContainer(for: ServerModel.self, inMemory: true)
}
