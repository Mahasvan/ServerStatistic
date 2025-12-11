import SwiftUI

struct EditServerView: View {
    @Environment(\.modelContext) private var modelContext

    // Binding to the existing server we want to edit
    @Binding var server: ServerModel

    // Local editable copies of fields
    @State private var scheme: Schemes = .http
    @State private var name: String = ""
    @State private var host: String = ""
    @State private var port: Int = 0

    @State private var cpu: Bool = false
    @State private var disk: Bool = false
    @State private var memory: Bool = false

    @State private var showSuccessAlert: Bool = false

    init(server: Binding<ServerModel>) {
        self._server = server
        // State will be populated in onAppear to ensure latest values
    }

    private func loadFromServer() {
        // Map model to local state
        if let parsedScheme = Schemes(rawValue: server.scheme) {
            scheme = parsedScheme
        } else {
            scheme = .http
        }
        name = server.name
        host = server.host
        port = server.port

        // Components
        cpu = server.components.contains("CPU")
        disk = server.components.contains("Disk")
        memory = server.components.contains("Memory")
    }

    private func saveServer() {
        // Build components selection
        var comps: [String] = []
        if cpu { comps.append("CPU") }
        if disk { comps.append("Disk") }
        if memory { comps.append("Memory") }

        // Apply back to the bound model
        server.scheme = scheme.rawValue
        server.name = name
        server.host = host
        server.port = port
        server.components = comps

        // For SwiftData, changes to a model bound in the context are tracked automatically.
        // If your model uses transactions, you could wrap in a do/catch with try modelContext.save().
        do {
            try modelContext.save()
            showSuccessAlert = true
        } catch {
            // If save throws, we can still show an alert, but here we just fall back silently.
            // Consider surfacing an error state if desired.
            showSuccessAlert = true
        }
    }

    private let numberFormatter: NumberFormatter = {
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

            Toggle(isOn: $cpu) { Text("CPU") }
            Toggle(isOn: $disk) { Text("Disk") }
            Toggle(isOn: $memory) { Text("Memory") }

            Button("Save Changes") {
                saveServer()
            }
            .modifier(GlassButton())
            
            // Live link preview similar to AddServerView
            let url = "\(scheme.rawValue)://\(host):\(port.description)"
            let link: URL? = URL(string: url)
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
        .frame(maxWidth: 500)
        .navigationTitle("Edit Server")
        .onAppear { loadFromServer() }
        .alert("Server Updated", isPresented: $showSuccessAlert) {
            if #available(macOS 26.0, *) {
                Button("OK", role: .confirm) { }
                    .modifier(GlassButton())
            } else {
                Button("OK") { }
                    .modifier(GlassButton())
            }
        } message: {
            Text("\(name) has been updated successfully!")
        }
    }
}

#Preview {
    // Provide a simple preview by creating a constant binding.
    // Replace with a real SwiftData preview model if available.
    struct PreviewHost: View {
        @State var model = ServerModel(
            scheme: Schemes.http.rawValue,
            name: "My Cool Server",
            host: "localhost",
            port: 5001,
            components: [.CPU, .Disk]
        )
        var body: some View {
            EditServerView(server: $model)
        }
    }
    return PreviewHost()
}
