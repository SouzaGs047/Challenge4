import SwiftUI
import PhotosUI

struct EditProjectFormView: View {
    @EnvironmentObject var coreDataVM: ProjectViewModel
    @ObservedObject var currentProject: ProjectEntity // Novo parâmetro
    
    @Binding var selectedImages: [UIImage]  // Alteração para um array de UIImage
    
    @State private var isBrandingExpanded = false
    @State private var isSaved = false  // Estado para alternar entre editar e salvar
    @State private var isImagePickerPresented = false  // Controla a exibição do ImagePicker
    
    private let projectTypes = [
        "UX/UI Design",
        "Design de Jogos",
        "Design de Interfaces",
        "Design de Marca",
        "Design de Motion",
        "Design de Animação",
        "Outros"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Exibição da Imagem com texto explicativo
                ImageView(selectedImages: $selectedImages, isEditing: false)
                    .onTapGesture {
                        // Lógica para selecionar uma nova foto
                        isImagePickerPresented.toggle()
                    }
                
                // Formulário
                Group {
                    // Tipo do Projeto com design customizado no Menu
                    HStack {
                        Text("Tipo")
                            .font(.headline)
                            .padding()
                            .foregroundStyle(.accent)
                            
                        Spacer()
                        
                        Menu {
                            ForEach(projectTypes, id: \.self) { type in
                                Button(action: {
                                    coreDataVM.type = type
                                }) {
                                    Text(type)
                                }
                            }
                        } label: {
                            HStack {
                                Text(coreDataVM.type.isEmpty ? "Selecione um tipo" : coreDataVM.type)
                                    .foregroundColor(coreDataVM.type.isEmpty ? .gray : .primary)
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        }
                        .disabled(!isSaved) // Desabilita quando estiver no modo de visualização
                    }
                    
                    // Objetivo do Projeto
                    VStack(alignment: .leading) {
                        Text("Objetivo")
                            .font(.headline)
                            .padding()
                            .foregroundStyle(.accent)
                        
                        ZStack(alignment: .topLeading) {
                            // Placeholder que só aparece se o texto estiver vazio
                            if coreDataVM.objective.isEmpty {
                                Text("Escreva o objetivo")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                            }
                            
                            TextEditor(text: $coreDataVM.objective)
                                .frame(height: 100)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .scrollContentBackground(.hidden)
                                .disabled(!isSaved) 
                        }
                    }

                    
                    // Data de início e prazo final
                    HStack(spacing: 25) {
                        DatePickerField(title: " Data de início", date: $coreDataVM.startDate)
                        DatePickerField(title: "   Prazo Final", date: $coreDataVM.finalDate)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(!isSaved) // Desabilita os campos de data quando não estiver no modo de edição
                    .padding()
                    .cornerRadius(15)
                }
                
                // Branding Section dentro do DisclosureGroup
                DisclosureGroup {
                    BrandingView(currentProject: currentProject)
                        .padding(.top, 10)
                } label: {
                    Text("Configurações de Branding")
                        .foregroundColor(.white) // Define a cor do texto como branca
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity) // Garante que o fundo cubra toda a largura
                        .background(Color.pink) // Definåe o fundo rosa
                        .cornerRadius(10)
                }
                .padding()
                .background(Color.pink.opacity(0.1)) // Fundo geral com uma transparência leve
                .cornerRadius(10)
                .animation(.easeInOut, value: isBrandingExpanded)

            }
            .padding()
        }
        // Aqui adicionamos o onChange para salvar automaticamente a imagem assim que ela for adicionada
        .onChange(of: selectedImages) { newImages in
            guard let firstImage = newImages.first else { return }
            let imageData = firstImage.jpegData(compressionQuality: 1.0)
            coreDataVM.updateProject(
                currentProject,
                type: coreDataVM.type,
                objective: coreDataVM.objective,
                startDate: coreDataVM.startDate,
                finalDate: coreDataVM.finalDate,
                image: imageData
            )
        }
        .navigationBarItems(
            trailing: Button(action: {
                if isSaved {
                    // Modo de edição ativo: salva os dados e sai do modo de edição
                    saveData()
                } else {
                    // Entra no modo de edição
                    isSaved.toggle()
                }
            }) {
                Text(isSaved ? "Salvar" : "Editar")
                    .bold()
                    .foregroundStyle(.accent)
            }
        )
        .sheet(isPresented: $isImagePickerPresented) {
            // Apresenta o ImagePicker
            ImagePicker(selectedImages: $selectedImages)
        }
    }
    
    func saveData() {
         // Converter imagem para Data (se existir)
         let imageData = selectedImages.first?.jpegData(compressionQuality: 1.0)
         
         // Atualizar o projeto
         coreDataVM.updateProject(
             currentProject,
             type: coreDataVM.type,
             objective: coreDataVM.objective,
             startDate: coreDataVM.startDate,
             finalDate: coreDataVM.finalDate,
             image: imageData
         )
         
         isSaved.toggle()
     }
}

// Componente para exibir a imagem com texto explicativo
struct ImageView: View {
    @Binding var selectedImages: [UIImage]  // Imagens selecionadas
    var isEditing: Bool  // Define se o modo de edição está ativado
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                if let firstImage = selectedImages.first {
                    Image(uiImage: firstImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    Image("DefaultImage")
                        .resizable()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.gray)
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                // Texto explicativo para o usuário
                if selectedImages.isEmpty {
                    Text("Clique para adicionar uma foto")
                        .foregroundStyle(.white)
                        .font(.caption)
                        .bold()
                        .padding(5)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(5)
                        .padding(5)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Botão de Remover (aparece apenas se houver imagem e o modo de edição estiver ativo)
                if !selectedImages.isEmpty && isEditing {
                    Button(action: {
                        selectedImages.removeAll() // Remove todas as imagens
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                    .padding(10)
                }
            }
        }
    }
}

// Componente para o campo de DatePicker
struct DatePickerField: View {
    let title: String
    @Binding var date: Date
     
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(.accent)
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}


//#Preview {
//    EditProjectFormView(selectedImages: .constant([UIImage()]))
//        .environmentObject(ProjectViewModel())
//}
