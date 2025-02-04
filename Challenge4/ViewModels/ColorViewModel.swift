//
//  ColorViewModel.swift
//  TesteColorPicker
//
//  Created by HENRIQUE LEAL PEREIRA DOS SANTOS on 30/01/25.
//import SwiftUI
import CoreData

class ColorViewModel: ObservableObject {
private let context: NSManagedObjectContext
@Published var colors: [ColorItemEntity] = []


init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
    self.context = context
    fetchColors()
}

func fetchColors() {
    let request: NSFetchRequest<ColorItemEntity> = ColorItemEntity.fetchRequest()
    do {
        colors = try context.fetch(request)
    } catch {
        print("Erro ao buscar cores: \(error.localizedDescription)")
    }
}

func addColor(hex: String) {
    guard !colors.contains(where: { $0.hex == hex }) else {
        print("A cor já existe na lista.")
        return
    }
    
    let newColor = ColorItemEntity(context: context)
    newColor.hex = hex
    saveData()
}

func deleteColor(color: ColorItemEntity) {
    context.delete(color)
    saveData()
}

func deleteAllColors() {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ColorItemEntity.fetchRequest()
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

    do {
        try context.execute(deleteRequest)
        try context.save()
        fetchColors()
    } catch {
        print("Erro ao apagar todas as cores: \(error.localizedDescription)")
    }
}

private func saveData() {
    do {
        try context.save()
        fetchColors()
    } catch {
        print("Erro ao salvar dados: \(error.localizedDescription)")
    }
}
}
