//
//  LogViewModel.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 31/01/25.
//

import CoreData

class LogViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
    }
    
    func addLog(to project: ProjectEntity, title: String, textContent: String) {
        let newLog = LogEntity(context: context)
        newLog.title = title
        newLog.textContent = textContent
        newLog.date = Date()
        
        let existingLogs = project.logs as? Set<LogEntity> ?? []
        project.logs = NSSet(set: existingLogs.union([newLog]))
        
        
        saveData()
    }
    
    private func saveData() {
        PersistenceController.shared.saveContext()
    }
}

