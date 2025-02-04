//
//  Persistence.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 29/01/25.
//

import CoreData

class ProjectViewModel: ObservableObject {
    private let context: NSManagedObjectContext
        @Published var savedEntities: [ProjectEntity] = []
        
        init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
            self.context = context
            fetchProjects()
        }
        
        func fetchProjects() {
            let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
            do {
                savedEntities = try context.fetch(request)
            } catch {
                print("Error fetching projects: \(error)")
            }
        }
        
        func addProject(name: String) {
            let newProject = ProjectEntity(context: context)
            newProject.name = name
            saveData()
        }
        
        func updateProject() {
            saveData()
        }
        
        func deleteProject(indexSet: IndexSet) {
            for index in indexSet {
                context.delete(savedEntities[index])
            }
            saveData()
        }
        
        private func saveData() {
            PersistenceController.shared.saveContext()
            fetchProjects()
        }
    }
