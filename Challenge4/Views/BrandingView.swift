//
//  ContentView.swift
//  TesteColorPicker
//
//  Created by HENRIQUE LEAL PEREIRA DOS SANTOS on 30/01/25.
//import SwiftUI
import SwiftUI
import CoreData



struct BrandingView: View {
    @Environment(\ .managedObjectContext) private var viewContext
    @StateObject private var colorViewModel = ColorViewModel()
    @StateObject private var fontViewModel = FontViewModel()
    
    var body: some View {
        
        
        VStack{
            ColorPickerView(viewModel: colorViewModel)
            Divider()
            FontPickerView(viewModel: fontViewModel)
            Divider()
        }
            .environment(\ .managedObjectContext, viewContext)
        }
}
//#Preview {
//    BrandingView().environment(\ .managedObjectContext, PersistenceController.preview.container.viewContext)
//}
