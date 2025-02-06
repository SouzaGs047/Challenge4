import SwiftUI
import PhotosUI

struct EditProjectFormView: View {
    @EnvironmentObject var coreDataVM: ProjectViewModel
    @ObservedObject var currentProject: ProjectEntity 
    
    @Binding var selectedImages: [UIImage]
    
    @State private var isBrandingExpanded = false
    @State private var isSaved = false
    @State private var isImagePickerPresented = false
    
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
              
                ImageView(selectedImages: $selectedImages)
                    .onTapGesture {
                      
                        isImagePickerPresented.toggle()
                    }
                
             
                Group {
                   
                    HStack {
                        Text("Tipo")
                            .foregroundStyle(.accent)
                            .bold()
                            .padding(.horizontal)
                        
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
                            
                        }
                        .disabled(!isSaved)
                    }.background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.linha, lineWidth: 1)
                    )
                    
                   
                    VStack(alignment: .leading) {
                        Text("Objetivo")
                            .padding(.top, 5)
                            .padding(.horizontal)
                            .foregroundStyle(.accent)
                            .bold()
                        
                        TextEditor(text: $coreDataVM.objective)
                            .frame(height: 100)
                            .padding(8)
                            
                            .scrollContentBackground(.hidden)
                            .disabled(!isSaved)
                    }.background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.linha, lineWidth: 1)
                    )
                    

                    HStack(spacing: 20) {
                        DatePickerField(title: " Data de início", date: $coreDataVM.startDate)
                            .bold()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.linha, lineWidth: 1)
                            )
                        DatePickerField(title: "  Prazo Final", date: $coreDataVM.finalDate)
                            .bold()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.linha, lineWidth: 1)
                            )
                    }
                    
                    .disabled(!isSaved)
                }
                .padding()
                .cornerRadius(15)
                
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
                    
                    saveData()
                } else {
                    
                    isSaved.toggle()
                }
            }) {
                Text(isSaved ? "Salvar" : "Editar")
                    .bold()
                    .foregroundStyle(.accent)
            }
        )
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImages: $selectedImages)
                .edgesIgnoringSafeArea(.all)
        }

    }
    
    func saveData() {
         
         let imageData = selectedImages.first?.jpegData(compressionQuality: 1.0)
         
         
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


struct ImageView: View {
    @Binding var selectedImages: [UIImage]
    
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
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
    }
}
