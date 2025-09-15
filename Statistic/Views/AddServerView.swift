//
//  AddServerView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 03/09/25.
//

import SwiftUI

struct AddServerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var name: String = "My Cool Server"
    @State private var host: String = "http://127.0.0.1"
    @State private var port: Int = 5001
    
    @State private var cpu: Bool = false
    @State private var disk: Bool = false
    @State private var memory: Bool = false
    
    func addServer() -> Void {
        var serverComponents: [ServerComponents] = []
        if cpu {
            serverComponents.append(.CPU)
        }
        if disk {
            serverComponents.append(.Disk)
        }
        if memory {
            serverComponents.append(.Memory)
        }
        
        let serverModel: ServerModel = .init(name: self.name, host: self.host, port: self.port, components: serverComponents)
        modelContext.insert(serverModel)
    }
    
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    
    var body: some View {
        Form {
            TextField("Server Nickname", text: $name)
            TextField("Server Host URL", text: $host)
            TextField("Port", value: $port, formatter: numberFormatter)
            Toggle(isOn: $cpu) {
                Text("CPU")
            }
            Toggle(isOn: $disk) {
                Text("Disk")
            }
            Toggle(isOn: $memory) {
                Text("Memory")
            }
            
            Button(action: addServer, label: { Text("Add Server") })
        }
        .frame(maxWidth: 500)
        .navigationTitle("Add Server")
    }
}

#Preview {
    AddServerView()
}
