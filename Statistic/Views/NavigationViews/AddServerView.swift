//
//  AddServerView.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 03/09/25.
//

import SwiftUI


struct AddServerView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var serverObject = ServerModel(
        scheme: "",
        name: "",
        host: "",
        port: 0,
        components: [],
        placeholder: true
    )
    
    var body: some View {
        ModifyServerView(server: serverObject, addingNewServer: true)
    }
    
    
}

#Preview {
    AddServerView()
}
