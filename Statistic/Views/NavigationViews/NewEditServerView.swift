//
//  NewEditServerView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 29/11/25.
//

import SwiftUI

struct NewEditServerView: View {
    // todo: figure out the architecture for editing vs adding a model object
    @Environment(\.modelContext) private var modelContext
    
    @Binding var serverModel: ServerModel
    @Binding var isEditingModel: Bool
    
    private var editedServerModel: ServerModel
    
    @State private var showSuccessAlert: Bool = false
    
    @State private var cpu: Bool = false
    @State private var disk: Bool = false
    @State private var memory: Bool = false
    
    func addServer() -> Void {
        editedServerModel.components = []
        if cpu {
            editedServerModel.components.append("CPU")
        }
        if memory {
            editedServerModel.components.append("Memory")
        }
        if disk {
            editedServerModel.components.append("Disk")
        }
        
        // push model to disk
    }
    
    init(serverModel: Binding<ServerModel>, isEditingModel: Binding<Bool>) {
            _serverModel = serverModel
            _isEditingModel = isEditingModel
        editedServerModel = ServerModel(
            scheme: serverModel.scheme.wrappedValue,
            name: serverModel.name.wrappedValue,
            host: serverModel.host.wrappedValue,
            port: serverModel.port.wrappedValue,
            components: [])
            
            let components = serverModel.wrappedValue.components
            
            _cpu = State(initialValue: components.contains("CPU"))
            _disk = State(initialValue: components.contains("Disk"))
            _memory = State(initialValue: components.contains("Memory"))
        }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    
    var body: some View {
        
        Form {
            TextField("Nickname", text: $serverModel.name)
            Picker(selection: $serverModel.scheme, label: Text("Scheme")) {
                Text("HTTP").tag(Schemes.http.rawValue)
                Text("HTTPS").tag(Schemes.https.rawValue)
            }
            .pickerStyle(.palette)
            
            TextField("Host", text: $serverModel.host)
            TextField("Port", value: $serverModel.port, formatter: numberFormatter)
            
            Toggle(isOn: $cpu) {
                Text("CPU")
            }
            Toggle(isOn: $disk) {
                Text("Disk")
            }
            Toggle(isOn: $memory) {
                Text("Memory")
            }
            
            Button(isEditingModel ? "Save" : "Add Server") {
                addServer()
                showSuccessAlert = true
            }
            .modifier(GlassButton())
        }
        .frame(maxWidth: 500)
        .navigationTitle(isEditingModel ? "Editing Server" : "Add Server")
        .alert("Server Saved", isPresented: $showSuccessAlert) {
            if #available(macOS 26.0, *) {
                Button("OK", role: .confirm) {}
                    .modifier(GlassButton())
            } else {
                Button("OK") {}
                    .modifier(GlassButton())
            }
        } message: {
            Text("\(serverModel.name) has been registered successfully!")
        }
    
        let url = "\(serverModel.scheme)://\(serverModel.host):\(serverModel.port.description)"
        let link: URL? = URL.init(string: url)
        if link != nil {

            Text("Access Your Server At")
//                .font(.caption)
                .padding(.top, 10)
                
            HStack {
                Link(destination: link ?? URL(string: "http://localhost")!) {
                    Text(url)
//                        .foregroundStyle(.blue)
                        .font(.headline)
                    Image(systemName: "link")
                }
            }
        }
        
    }
    
    
}

#Preview {
    let serverModel: ServerModel = ServerModel(scheme: "http", name: "My Server", host: "localhost", port: 5000, components: [.CPU, .Memory])
    NewEditServerView(serverModel: .constant(serverModel), isEditingModel: .constant(true))
}
