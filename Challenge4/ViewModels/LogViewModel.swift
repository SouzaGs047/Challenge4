
import CoreData

class LogViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
    }
    
    func addLog(to logProject: ProjectEntity, title: String, textContent: String, imagesData: [Data]) {
        let newLog = LogEntity(context: context)
        newLog.title = title
        newLog.textContent = textContent
        newLog.date = Date()
        newLog.logProject = logProject

      
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
        
      
        if let currentImages = log.images as? Set<LogImageEntity> {
            for imageEntity in currentImages {
                context.delete(imageEntity)
            }
        }

      
        for imageData in imageData {
            let newImageEntity = LogImageEntity(context: context)
            newImageEntity.imageData = imageData
            newImageEntity.log = log
        }

        saveData()
    }
    
    func deleteLog(_ log: LogEntity) {
        if let project = log.logProject {
            
            project.removeFromLogs(log)
        }
        
        context.delete(log) 
        saveData()
    }


    

    

    
    private func saveData() {
        PersistenceController.shared.saveContext()
    }



}
