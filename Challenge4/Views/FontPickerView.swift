import SwiftUI

struct FontPickerView: View {
    @ObservedObject var viewModel: FontViewModel
    @State private var fontName = ""
    @State private var selectedCategory: String? = nil

    let categories = ["Títulos", "Texto Corrido", "Legenda", "Footnote"]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text("Texto")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color.accent)
                Spacer()
                Button("Adicionar") {
                    if !fontName.isEmpty, let category = selectedCategory {
                        withAnimation {
                            viewModel.addFont(nameFont: fontName, category: category)
                        }
                        fontName = ""
                        selectedCategory = nil
                    }
                }
                .disabled(selectedCategory == nil)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color(red: 0.8, green: 0, blue: 0.3))
                .foregroundStyle(.white)
                .cornerRadius(8)
            }

            HStack {
                TextField("Nome da fonte", text: $fontName)
                    .frame(width: 200, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()

                Menu {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCategory ?? "Selecione")
                            .foregroundColor(selectedCategory == nil ? .gray : .primary)
                        Image(systemName: "chevron.down")
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.linha, lineWidth: 1)
                    )
                }
            }

            if $viewModel.fonts.isEmpty {
                Text("Nenhuma fonte adicionada ainda.")
                    .foregroundStyle(.gray)
                    .italic()
                    .padding(.all)
            }
            List {
                ForEach(viewModel.fonts, id: \.self) { font in
                    HStack {
                        Text(font.category ?? "Categoria não definida")
                            .bold()
                        Spacer()
                        Text(font.nameFont ?? "Sem nome")
                    }
                }
                .onDelete(perform: viewModel.deleteFont)
            }
            .listStyle(PlainListStyle())
            
            .scrollDisabled(true)
            
            .frame(height: CGFloat(viewModel.fonts.count) * 60)
        }
        
    }
}
