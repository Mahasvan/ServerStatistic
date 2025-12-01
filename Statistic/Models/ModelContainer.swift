//
//  ModelContainer.swift
//  Statistic
//
//  Created by Mahasvan Mohan on 01/12/25.
//

import Foundation
import SwiftData

enum SharedModelContainer {
    static let container: ModelContainer = {
        let schema = Schema([ServerModel.self])
        let config = ModelConfiguration(
            schema: schema,
            groupContainer: .identifier("group.com.mahasvan.Statistic")
        )
        return try! ModelContainer(for: schema, configurations: [config])
    }()
}
