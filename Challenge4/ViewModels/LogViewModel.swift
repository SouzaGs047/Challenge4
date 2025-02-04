
import CoreData

class LogViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
    }
    
    func addLog(to project: ProjectEntity, title: String, textContent: String, imagesData: [Data]) {
        let newLog = LogEntity(context: context)
        newLog.title = title
        newLog.textContent = textContent
        newLog.date = Date()
        newLog.project = project

        // Criar e associar cada imagem ao log
        for imageData in imagesData {
            let logImage = LogImageEntity(context: context)
            logImage.imageData = imageData
            logImage.log = newLog
        }

        saveData()
    }
    func updateLog(log: LogEntity, title: String, textContent: String, imageData: [Data]) {
        log.title = title
        log.textContent = textContent
        
        // Remover imagens antigas antes de adicionar novas
        if let currentImages = log.images as? Set<LogImageEntity> {
            for imageEntity in currentImages {
                context.delete(imageEntity)
            }
        }

        // Adicionar as novas imagens
        for imageData in imageData {
            let newImageEntity = LogImageEntity(context: context)
            newImageEntity.imageData = imageData
            newImageEntity.log = log
        }

        saveData()
    }

    
    private func saveData() {
        PersistenceController.shared.saveContext()
    }



}
