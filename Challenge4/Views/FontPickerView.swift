//
//  FontPickerView.swift
//  TesteColorPicker
//
//  Created by Felipe Lau on 03/02/25.
//
import SwiftUI

struct FontPickerView: View {
    @ObservedObject var viewModel: FontViewModel
    @State private var fontName = ""
    @State private var selectedCategory = "Categoria"

    let categories = ["Títulos", "Texto Corrido", "Legenda", "Footnote"]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack{
                Text("Texto")
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color.pink)
                Spacer()
                
                Picker("Função", selection: $selectedCategory) {
                    Text("Categoria").tag("").disabled(true)
                    ForEach(categories, id: \ .self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
       
            }
            
            
            HStack {
                TextField("Nome da fonte", text: $fontName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                

                
                Button("Adicionar") {
                    if !fontName.isEmpty && !selectedCategory.isEmpty {
                        withAnimation {
                            viewModel.addFont(nameFont: fontName, category: selectedCategory)
                        }
                        fontName = ""
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color(red: 0.8, green: 0, blue: 0.3))
                .foregroundColor(.white)
                .cornerRadius(8)
                .accessibilityLabel("Botão para adicionar uma nova fonte")
                
            }
            
            Divider().background(Color.white.opacity(0.3))

            List {
                ForEach(viewModel.fonts, id: \ .self) { font in
                    HStack {
                        Text(font.category ?? "Sem categoria")
                            .bold()
                        Spacer()
                        Text(font.nameFont ?? "Sem nome")
                    }
                }
                .onDelete(perform: viewModel.deleteFont)
            }.listStyle(PlainListStyle())
        }
        .padding()
    }
}

struct FontPickerView_Previews: PreviewProvider {
    static var previews: some View {
        FontPickerView(viewModel: FontViewModel())
    }
}
