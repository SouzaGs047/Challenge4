//
//  LogDetailViewModel.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 05/02/25.
//

import CoreData
import SwiftUI

class LogDetailViewModel: ObservableObject {
    private let context: NSManagedObjectContext

    @Published var log: LogEntity
    @Published var selectedOption: String
    @Published var editedTextContent: String
    @Published var selectedImages: [UIImage]

    init(log: LogEntity, context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
        self.log = log
        self.selectedOption = log.title ?? "Sem título"
        self.editedTextContent = log.textContent ?? ""
        self.selectedImages = (log.images as? Set<LogImageEntity>)?.compactMap { entity in
            guard let imageData = entity.imageData else { return nil }
            return UIImage(data: imageData)
        } ?? []
    }

    func updateLog() {
        guard !selectedOption.isEmpty, !editedTextContent.isEmpty else { return }

        log.title = selectedOption
        log.textContent = editedTextContent

        // Atualiza as imagens no Core Data
        let newImages = selectedImages.compactMap { image -> LogImageEntity? in
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
            let newImageEntity = LogImageEntity(context: context)
            newImageEntity.imageData = imageData
            return newImageEntity
        }

        log.images = NSSet(array: newImages)

        saveData()
    }

    private func saveData() {
        do {
            try context.save()
            print("Log atualizado com sucesso.")
        } catch {
            print("Erro ao salvar Log: \(error)")
        }
    }
}

