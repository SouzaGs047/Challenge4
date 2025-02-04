
//
//  FontViewModel.swift
//  TesteColorPicker
//
//  Created by Felipe Lau on 03/02/25.
//
import SwiftUI
import CoreData

class FontViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    @Published var fonts: [ColorItemEntity] = []
    
    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
        fetchFonts()
    }
    
    // Buscar fontes no Core Data
    func fetchFonts() {
        let request: NSFetchRequest<ColorItemEntity> = ColorItemEntity.fetchRequest()
        do {
            fonts = try context.fetch(request)
        } catch {
            print("Erro ao buscar fontes: \(error.localizedDescription)")
        }
    }

    func addFont(nameFont: String, category: String) {
        let newFont = ColorItemEntity(context: context)
        newFont.nameFont = nameFont
        newFont.category = category
        saveData()
    }


    func deleteFont(at offsets: IndexSet) {
        offsets.forEach { index in
            let font = fonts[index]
            context.delete(font)
        }
        saveData()
    }

    private func saveData() {
        do {
            try context.save()
            fetchFonts()
        } catch {
            print("Erro ao salvar dados: \(error.localizedDescription)")
        }
    }
}
