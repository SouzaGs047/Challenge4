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
            HStack {
                Text("Texto")
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color.pink)
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
                .background(Color.pink)
                .foregroundColor(.white)
                .cornerRadius(8)
            }

            HStack {
                TextField("Nome da fonte", text: $fontName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 150, height: 50)
                Spacer()
                Picker("Função", selection: $selectedCategory) {
                    Text("Selecione").tag("").disabled(true)
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            if viewModel.fonts.isEmpty {
                Text("Nenhuma fonte adicionada ainda.")
                    .foregroundColor(.gray)
                    .italic()
                    .padding()
            }

            List {
                ForEach(viewModel.fonts, id: \.self) { font in
                    HStack {
                        Text(font.category ?? "Sem categoria").bold()
                        Spacer()
                        Text(font.nameFont ?? "Sem nome")
                    }
                }
                .onDelete(perform: viewModel.deleteFont)
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
                    viewModel.fetchFonts()
                }
    }
}


