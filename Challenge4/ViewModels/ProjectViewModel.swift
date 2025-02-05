import CoreData

class ProjectViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    @Published var savedEntities: [ProjectEntity] = []
    @Published var type: String = ""  // Adicionando @Published
        @Published var objective: String = ""
        @Published var startDate: Date = Date()
        @Published var finalDate: Date = Date()
        @Published var image: Data? = nil
    
    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
        fetchProjects()
    }
    
    func fetchProjects() {
        let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
        do {
            savedEntities = try context.fetch(request)
            print("Projetos carregados: \(savedEntities.count)")
        } catch {
            print("Erro ao buscar projetos: \(error)")
        }
    }

    
    // Função separada para adicionar apenas o nome
        func addProject(name: String) {
            let newProject = ProjectEntity(context: context)
            newProject.name = name
            saveData()
        }
    
    func addProjects(name: String, type: String, objective: String, startDate: Date, finalDate: Date, image: Data?) {
        let newProject = ProjectEntity(context: context)
        newProject.name = name
        newProject.type = type
        newProject.objective = objective
        newProject.startDate = startDate
        newProject.finalDate = finalDate
        newProject.image = image
        saveData()
    }
    
    func updateProject(_ project: ProjectEntity, type: String, objective: String, startDate: Date, finalDate: Date, image: Data?) {
        project.type = type
        project.objective = objective
        project.startDate = startDate
        project.finalDate = finalDate
        project.image = image
        saveData()
    }
    
    func deleteProject(indexSet: IndexSet) {
        for index in indexSet {
            context.delete(savedEntities[index])
        }
        saveData()
    }
    
    private func saveData() {
        do {
            try PersistenceController.shared.viewContext.save()
            print("Dados salvos com sucesso.")
        } catch {
            print("Erro ao salvar dados: \(error)")
        }
        fetchProjects()  // Atualiza a lista de projetos após salvar
    }

}
