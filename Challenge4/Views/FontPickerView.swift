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
    @State private var selectedCategory = "Selecione"

    let categories = ["Títulos", "Texto Corrido", "Legenda", "Footnote"]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack{
                
                HStack{
                    Text("Texto")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Color.accent)
                    Spacer()
                    Button("Adicionar") {
                        if !fontName.isEmpty && selectedCategory != "Selecione" {
                            withAnimation {
                                viewModel.addFont(nameFont: fontName, category: selectedCategory)
                            }
                            fontName = ""
                            selectedCategory = "Selecione"

                        }
                    }
                    .disabled(selectedCategory == "Selecione")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color(red: 0.8, green: 0, blue: 0.3))
                    .foregroundStyle(.white)
                    .cornerRadius(8)
                    .disabled(selectedCategory == "Selecione")
                    .accessibilityLabel("Botão para adicionar uma nova fonte")
                }
                
       
            }
            
            
            HStack {
                TextField("Nome da fonte", text: $fontName)
                    .frame(width: 200, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                
                Spacer()
                Picker("Função", selection: $selectedCategory) {
                    Text("Selecione").tag("").disabled(true)
                    ForEach(categories, id: \ .self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
            }
            
            if viewModel.fonts.isEmpty {
                Text("Nenhuma cor adicionada ainda.")
                    .foregroundStyle(.gray)
                    .italic()
               

                    .padding(.all)
                    .accessibilityLabel("Aviso: Nenhuma cor adicionada ainda")
            }

    

            List {
                ForEach(viewModel.fonts, id: \.self) { font in
                    HStack {
                        Text(font.category?.isEmpty == false ? font.category! : "Categoria não definida")
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
