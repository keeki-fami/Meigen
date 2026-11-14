//
//  SharedModelContainer.swift
//  Meigen
//  
//  Created by keeki-fami on 2026/11/14
//  
//

// ModelConfiguration, Schemaの明示的な指定
// 保存先のカスタマイズを行う場合は、SchemaとModelConfigurationを使用する。

import SwiftData

enum SharedModelContainer {

    static let appGroupID = "group.com.keeki.MeigenApp"

    static func create() throws -> ModelContainer {
//        , fileNamePath: nil
        let schema = Schema([
            QuoteRecord.self
        ])

        let configuration = ModelConfiguration(
            "SharedStore",
            schema: schema,
            groupContainer: .identifier(appGroupID),
            cloudKitDatabase: .none
        )

        return try ModelContainer(
            for: schema,
            configurations: [configuration]
        )
    }
}
