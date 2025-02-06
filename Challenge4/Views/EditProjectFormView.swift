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
                ImageView(selectedImages: $selectedImages)
                    .onTapGesture {
                        // Lógica para selecionar uma nova foto
                        isImagePickerPresented.toggle()
                    }
                
                // Formulário
                Group {
                    // Tipo do Projeto com design customizado no Menu
                    HStack {
                        Text("Tipo")
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
                            .foregroundStyle(.accent)
                        
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
                            .disabled(!isSaved) // Desabilita quando estiver no modo de visualização
                    }
                    
                    // Data de início e prazo final
                    HStack(spacing: 20) {
                        DatePickerField(title: "Data de início", date: $coreDataVM.startDate)
                        DatePickerField(title: "Prazo Final", date: $coreDataVM.finalDate)
                    }
                    .disabled(!isSaved) // Desabilita os campos de data quando não estiver no modo de edição
                }
                .padding()
                .cornerRadius(15)
                
                // Branding Section dentro do DisclosureGroup
                DisclosureGroup("Configurações de Branding", isExpanded: $isBrandingExpanded) {
                    BrandingView(currentProject: currentProject)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
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
    @Binding var selectedImages: [UIImage]  // Alteração para um array de UIImage
    
    var body: some View {
        VStack {
            ZStack {
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
