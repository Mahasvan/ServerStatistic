//
//  NewEditServerView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 13/12/25.
//

import SwiftUI

struct EditServerView: View {
    
    private var server: ServerModel
    
    init(server: ServerModel) {
        self.server = server
    }
    
    var body: some View {
        ModifyServerView(server: server, addingNewServer: false)
    }
}

#Preview {
    let server = ServerModel(
        scheme: "http",
        name: "name",
        host: "host",
        port: 100,
        components: [.CPU, .Disk])
    EditServerView(server: server)
}
