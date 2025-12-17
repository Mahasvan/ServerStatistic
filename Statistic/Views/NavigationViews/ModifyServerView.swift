//
//  ModifyServerView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 14/12/25.
//

import SwiftUI
import SwiftData


struct ModifyServerView: View {
    
    @Environment(\.modelContext) var modelContext
    
    private var server: ServerModel
    private var addingNewServer: Bool
    
    @State private var scheme: Schemes = .http
    @State private var name: String = "My Cool Server"
    @State private var host: String = "localhost"
    @State private var port: Int = 5001
    
    @State private var cpu: Bool = true
    @State private var disk: Bool = true
    @State private var memory: Bool = true
    
    @State private var showSuccessAlert: Bool = false
    
    @Query(filter: ServerModel.getInvalidServers())
    private var invalidServers: [ServerModel]
    
    init(server: ServerModel, addingNewServer: Bool = false) {
        // Initialize the binding wrapper
        self.server = server
        self.addingNewServer = addingNewServer

        // Initialize state using underscored storage
        if (!server.placeholder) {
            self._scheme = State(initialValue: server.scheme == "http" ? .http : .https)
            self._name = State(initialValue: server.name)
            self._host = State(initialValue: server.host)
            self._port = State(initialValue: server.port)
            self._cpu = State(initialValue: server.components.contains("CPU"))
            self._disk = State(initialValue: server.components.contains("Disk"))
            self._memory = State(initialValue: server.components.contains("Memory"))
            self._showSuccessAlert = State(initialValue: false)
        }
    }
    
    func pruneInvalidServers() -> Void {
        for server in invalidServers {
            modelContext.delete(server)
        }
    }

    func saveChanges() -> Void {
        // prune placeholder servers that may be orphaned first
        pruneInvalidServers()
        
        self.server.name = self.name
        self.server.scheme = self.scheme.rawValue
        self.server.host = self.host
        self.server.port = self.port
        
        
        var serverComponents: [String] = []
        if cpu {
            serverComponents.append("CPU")
        }
        if disk {
            serverComponents.append("Disk")
        }
        if memory {
            serverComponents.append("Memory")
        }
        self.server.components = serverComponents
        self.server.placeholder = false
        
        if addingNewServer {
            modelContext.insert(server)
        }
    }
    
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        VStack {
            Form {
                TextField("Nickname", text: $name)
                Picker(selection: $scheme, label: Text("Scheme")) {
                    Text("HTTP").tag(Schemes.http)
                    Text("HTTPS").tag(Schemes.https)
                }
                .pickerStyle(.palette)
                
                TextField("Host", text: $host)
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
                
                Button("Save") {
                    saveChanges()
                    showSuccessAlert = true
                }
                .modifier(GlassButton())
            }
            .frame(maxWidth: 500)
            .navigationTitle(self.addingNewServer ? "Adding Server" : "Editing Server")
            
            .alert("Saved Successfully!", isPresented: $showSuccessAlert) {
                
                if #available(macOS 26.0, *) {
                    Button("OK", role: .confirm) {}
                        .modifier(GlassButton())
                } else {
                    Button("OK") {}
                        .modifier(GlassButton())
                }
                
            } message: {
                Text("\(name) has been saved successfully!")
            }
            
            let url = "\(scheme.rawValue)://\(host):\(port.description)"
            let link: URL? = URL.init(string: url)
            if link != nil {
                
                Text("Access Your Server At")
                    .padding(.top, 10)
                
                HStack {
                    Link(destination: link ?? URL(string: "http://localhost")!) {
                        Text(url)
                            .font(.headline)
                        Image(systemName: "link")
                    }
                }
            }
        }
    }
}

#Preview {
    let sample = ServerModel(
        scheme: "http",
        name: "My Cool Server",
        host: "hostURL",
        port: 5001,
        components: [.CPU, .Disk, .Memory],
        placeholder: true
    )
    
    ModifyServerView(server: sample)
}
