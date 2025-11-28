//
//  AddServerView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 03/09/25.
//

import SwiftUI

enum Schemes: String, Hashable {
    case http
    case https
}



struct AddServerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var scheme: Schemes = .http
    @State private var name: String = "My Cool Server"
    @State private var host: String = "localhost"
    @State private var port: Int = 5001
    
    @State private var cpu: Bool = false
    @State private var disk: Bool = false
    @State private var memory: Bool = false
    
    @State private var showSuccessAlert: Bool = false
    
    
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
        
        let serverModel: ServerModel = .init(
            scheme: self.scheme.rawValue,
            name: self.name,
            host: self.host,
            port: self.port,
            components: serverComponents
        )
        modelContext.insert(serverModel)
    }
    
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    
    var body: some View {
        
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
            
            Button("Add Server") {
                addServer()
                showSuccessAlert = true
            }
        }
        .frame(maxWidth: 500)
        .navigationTitle("Add Server")
        .alert("Server Added", isPresented: $showSuccessAlert) {
            if #available(macOS 26.0, *) {
                Button("OK", role: .confirm) {}
            } else {
                Button("OK") {}
            }
        } message: {
            Text("\(name) has been registered successfully!")
        }
    
        let url = "\(scheme.rawValue)://\(host):\(port.description)"
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
    AddServerView()
}
