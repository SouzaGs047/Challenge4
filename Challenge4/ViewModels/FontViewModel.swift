
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
    @Published var fonts: [FontItemEntity] = []
    private var project: ProjectEntity
    
    init(project: ProjectEntity, context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
        self.project = project
        fetchFonts()
    }
    

    func fetchFonts() {
        DispatchQueue.main.async {
            if let set = self.project.brandingFonts as? Set<FontItemEntity> {
                self.fonts = set.sorted { ($0.nameFont ?? "") < ($1.nameFont ?? "") }
                print(" Fontes carregadas: \(self.fonts.map { $0.nameFont ?? "Sem nome" })")
            } else {
                print("Nenhuma fonte encontrada para o projeto.")
            }
        }
    }
    
    func addFont(nameFont: String, category: String) {
       
        if fonts.contains(where: { $0.nameFont == nameFont && $0.category == category }) {
            print(" Fonte  duplicada:'\(nameFont)' já existe no projeto.")
            return
        }
        
        let newFont = FontItemEntity(context: context)
        newFont.nameFont = nameFont
        newFont.category = category
        newFont.project = project
        
        project.addToBrandingFonts(newFont)
        
        saveData()
        
        print(" Fonte adicionada: \(nameFont), Categoria: \(category)")
    }
    
   
    func deleteFont(at offsets: IndexSet) {
        offsets.forEach { index in
            let font = fonts[index]
            context.delete(font)
        }
        saveData()
    }
    
 
    func deleteFont(font: FontItemEntity) {
        context.delete(font)
        saveData()
    }
    
  
    private func saveData() {
        do {
            try context.save()
            fetchFonts()
        } catch {
            print(" Erro ao salvar fontes: \(error.localizedDescription)")
        }
    }
}
