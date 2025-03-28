//
//  Pet.swift
//  Paws
//
//  Created by Nicola Buompane on 28/03/25.
//

import Foundation
import SwiftData

@Model
final class Pet {
    var name: String
    @Attribute(.externalStorage) var photo: Data?
    
    init(name: String, photo: Data? = nil) {
        self.name = name
        self.photo = photo
    }
}

extension Pet {
    @MainActor
    static var preview: ModelContainer {
        let configutation = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Pet.self, configurations: configutation)
        
        container.mainContext.insert(Pet(name: "Rexy"))
        container.mainContext.insert(Pet(name: "Eros"))
        container.mainContext.insert(Pet(name: "Tobia"))
        container.mainContext.insert(Pet(name: "Max"))
        container.mainContext.insert(Pet(name: "Sky"))
        container.mainContext.insert(Pet(name: "Pippo"))
        
        return container
    }
}
