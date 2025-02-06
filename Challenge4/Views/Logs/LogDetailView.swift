import SwiftUI

struct LogDetailView: View {
    
    let log: LogEntity
    
    let onLogUpdated: () -> Void

    @ObservedObject private var viewModel = LogViewModel()
    @State private var isEditing = false
    @State private var selectedOption: String?
    @State private var editedTextContent: String
    @State private var selectedImages: [UIImage]
    @State private var showImagePicker = false
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)


    let topics = [
        "Anotação", "Lousa", "Marca", "Pesquisa",
        "Progresso", "Referências", "Testes",
        "Visita Técnica", "Outros"
    ]

    init(log: LogEntity, onLogUpdated: @escaping () -> Void) {
            self.log = log
            self.onLogUpdated = onLogUpdated
            _selectedOption = State(initialValue: log.title)
            _editedTextContent = State(initialValue: log.textContent ?? "")
            _selectedImages = State(initialValue: log.images?.compactMap { entity in
                guard let imageData = (entity as? LogImageEntity)?.imageData else { return nil }
                return UIImage(data: imageData)
            } ?? [])
        }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isEditing {
                    // Menu de seleção de tópico (substitui o título)
                    Menu {
                        ForEach(topics, id: \.self) { topic in
                            Button(topic) {
                                selectedOption = topic
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedOption ?? "O que você quer registrar agora?")
                                .foregroundColor(.pink)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    // TextEditor com placeholder
                    TextEditor(text: $editedTextContent)
                        .placeholder(when: editedTextContent.isEmpty) {
                            Text("Clique aqui para digitar")
                                .foregroundColor(.gray)
                        }
                        .frame(maxHeight: 200)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    // Botão para adicionar imagens
                    VStack(spacing: 0) {
                        HStack {
                            Text("Imagens")
                                .foregroundColor(.pink)
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                            Button(action: {
                                showImagePicker = true
                            }) {
                                Text("Clique aqui para adicionar")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16))
                            }
                            Spacer()
                        }
                        .padding()

                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(selectedImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100) // Definir tamanho quadrado
                                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                        .clipped() // Evita distorção
                                }
                            }
                            .padding()
                        }
                    }
                    .padding(.bottom)

                    // Botão para salvar alterações
                    Button(action: {
                        guard let topic = selectedOption, !editedTextContent.isEmpty else { return }
                        let imagesData = selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
                        updateLog(title: topic, textContent: editedTextContent, imagesData: imagesData)
                        isEditing = false
                    }) {
                        Text("Salvar Alterações")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                } else {
                    // Modo de visualização
                    Text(log.title ?? "Sem título")
                        .font(.title)
                        .bold()

                    Text(log.textContent ?? "Sem conteúdo")
                        .font(.body)

                    if selectedImages.isEmpty {
                        Text("Nenhuma imagem disponível")
                            .foregroundColor(.gray)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(selectedImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100) // Definir tamanho quadrado
                                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                        .clipped() // Evita distorção
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Cancelar" : "Editar")
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            PhotoPicker(selectedImages: $selectedImages)
        }
    }

    private func updateLog(title: String, textContent: String, imagesData: [Data]) {
        viewModel.updateLog(log: log, title: title, textContent: textContent, imageData: imagesData)
        editedTextContent = textContent
        selectedImages = imagesData.compactMap { UIImage(data: $0) }
        onLogUpdated()
    }
}

extension View {
    func placeholders<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
