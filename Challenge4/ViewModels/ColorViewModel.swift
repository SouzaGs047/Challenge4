//
//  ColorViewModel.swift
//  TesteColorPicker
//
//  Created by HENRIQUE LEAL PEREIRA DOS SANTOS on 30/01/25.

import SwiftUI
import CoreData

class ColorViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    @Published var colors: [ColorItemEntity] = []
    private var project: ProjectEntity
    
    init(project: ProjectEntity, context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
        self.project = project
        fetchColors()
    }
    
    func fetchColors() {
        if let set = project.brandingColors as? Set<ColorItemEntity> {
            self.colors = set.sorted { ($0.hex ?? "") < ($1.hex ?? "") }
        }
    }
    
    func addColor(hex: String) {
        
        if let existingColors = project.brandingColors as? Set<ColorItemEntity>,
           existingColors.contains(where: { $0.hex == hex }) {
            print("Cor \(hex) já existe no projeto e não será adicionada.")
            return
        }
        
        let newColor = ColorItemEntity(context: context)
        newColor.hex = hex
        newColor.project = project
        
        project.addToBrandingColors(newColor)
        
        saveData()
    }

    func deleteColor(at offsets: IndexSet) {
        offsets.forEach { index in
            let color = colors[index]
            context.delete(color)
        }
        saveData()
    }
    
    func deleteColor(color: ColorItemEntity) {
        context.delete(color)
        saveData()
    }

    
    private func saveData() {
        do {
            try context.save()
            fetchColors()
        } catch {
            print("Erro ao salvar cores: \(error.localizedDescription)")
        }
    }
}
