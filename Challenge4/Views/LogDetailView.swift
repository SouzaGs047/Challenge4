import SwiftUI

struct LogDetailView: View {
    @StateObject private var viewModel: LogDetailViewModel
    @State private var isEditing = false
    @State private var showImagePicker = false
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
    let topics = ["Anotação", "Lousa", "Marca", "Pesquisa", "Progresso", "Referências", "Testes", "Visita Técnica", "Outros"]
    
    init(log: LogEntity) {
        _viewModel = StateObject(wrappedValue: LogDetailViewModel(log: log))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Menu {
                    ForEach(topics, id: \.self) { topic in
                        Button(topic) { viewModel.selectedOption = topic }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text(viewModel.selectedOption )
                            .foregroundColor(.pink)
                        Spacer()
                        Image(systemName: "chevron.down").foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                }
                .disabled(!isEditing)
                .padding(.horizontal)
                .padding(.top)
                
                
                
                TextEditor(text: $viewModel.editedTextContent)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .scrollContentBackground(.hidden)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.rosaPreto) // Fundo com canto arredondado
                    )
                    .frame(height: 250)
                    .padding(.horizontal)
                    .disabled(!isEditing)

                
                
                HStack {
                    Text("Imagens").foregroundColor(.pink).font(.system(size: 20, weight: .bold))
                    Spacer()
                    if (isEditing) {
                        Button("Clique aqui para adicionar") { showImagePicker = true }
                            .foregroundColor(.gray).font(.system(size: 16))
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                .clipped()
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Log")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: {
                if (isEditing) {
                    viewModel.updateLog()
                }
                isEditing.toggle()
            },label: {
                Text(isEditing ? "Salvar" : "Editar")
            })
        }
        .sheet(isPresented: $showImagePicker) {
            PhotoPicker(selectedImages: $viewModel.selectedImages)
        }
    }
}
