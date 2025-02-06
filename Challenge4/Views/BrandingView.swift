//
//  ContentView.swift
//  TesteColorPicker
//
//  Created by HENRIQUE LEAL PEREIRA DOS SANTOS on 30/01/25.
//import SwiftUI
import SwiftUI
import CoreData



struct BrandingView: View {
    @ObservedObject var currentProject: ProjectEntity
    @StateObject private var colorViewModel: ColorViewModel
    @StateObject private var fontViewModel: FontViewModel
    
    init(currentProject: ProjectEntity) {
        self.currentProject = currentProject
        _colorViewModel = StateObject(wrappedValue: ColorViewModel(project: currentProject))
        _fontViewModel = StateObject(wrappedValue: FontViewModel(project: currentProject))
    }
    
    var body: some View {
        VStack {
            ColorPickerView(viewModel: colorViewModel)
            Divider()
            FontPickerView(viewModel: fontViewModel)
            
        }
    }
}

//#Preview {
//    BrandingView().environment(\ .managedObjectContext, PersistenceController.preview.container.viewContext)
//}
