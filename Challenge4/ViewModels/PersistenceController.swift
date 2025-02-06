//
//  Persistence.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 31/01/25.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "ProjectsContainer")

        
        
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true

        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA.. \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext() {
        viewContext.perform {
            do {
                try self.viewContext.save()
            } catch {
                print("Error saving. \(error)")
            }
        }
    }
}


