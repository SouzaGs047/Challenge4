//import SwiftUI
//import PhotosUI
//
//struct ProjectCreationView: View {
//    @StateObject var coreDataVM: ProjectViewModel
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var projectName: String = ""
//    @State private var projectType: String = ""
//    @State private var selectedImages: [UIImage] = []
//    @State private var projectObjective: String = ""
//    @State private var startDate: Date = Date()
//    @State private var finalDate: Date = Date()
//    @State private var currentStep: Int = 1
//    @State private var isImagePickerPresented = false
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                // Progress steps
//                ProgressView(value: Double(currentStep), total: 4)
//                    .padding(.horizontal)
//                
//                switch currentStep {
//                case 1:
//                    StepOneView(projectName: $projectName) {
//                        // Ao avançar do step 1, já salva o nome do projeto
//                        coreDataVM.addProject(name: projectName)
//                        currentStep = 2
//                    }
//                case 2:
//                    StepThreeView(selectedImages: $selectedImages,
//                                openImagePicker: { isImagePickerPresented = true }) {
//                        currentStep = 3
//                    }
//                case 3:
//                    FinalStepView(projectObjective: $projectObjective) {
//                        // Atualiza o projeto com todos os dados
//                        if let projectEntity = coreDataVM.savedEntities.last,
//                           let imageData = selectedImages.first?.jpegData(compressionQuality: 0.7) {
//                            coreDataVM.updateProject(
//                                projectEntity,
//                                type: projectType,
//                                objective: projectObjective,
//                                startDate: startDate,
//                                finalDate: finalDate,
//                                image: imageData
//                            )
//                        }
//                        dismiss()
//                    }
//                default:
//                    EmptyView()
//                }
//            }
//            .navigationTitle("Novo Projeto")
//            .sheet(isPresented: $isImagePickerPresented) {
//                ImagePicker(selectedImages: $selectedImages)
//            }
//        }
//    }
//}
//
//struct StepOneView: View {
//    @Binding var projectName: String
//    var nextStep: () -> Void
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Nome do Projeto")
//                .font(.title2)
//                .bold()
//            
//            TextField("Digite o nome", text: $projectName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            Button("Próximo") {
//                guard !projectName.isEmpty else { return }
//                nextStep()
//            }
//            .buttonStyle(.borderedProminent)
//            .disabled(projectName.isEmpty)
//        }
//        .padding()
//    }
//}
//
//
//
//struct StepThreeView: View {
//    @Binding var selectedImages: [UIImage]
//    var openImagePicker: () -> Void
//    var nextStep: () -> Void
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Imagem do Projeto")
//                .font(.title2)
//                .bold()
//            
//            Button(action: openImagePicker) {
//                if let firstImage = selectedImages.first {
//                    Image(uiImage: firstImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 200)
//                        .cornerRadius(15)
//                } else {
//                    Image(systemName: "photo")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 200)
//                        .foregroundColor(.gray)
//                }
//            }
//            
//            Button("Próximo") { nextStep() }
//                .buttonStyle(.borderedProminent)
//        }
//        .padding()
//    }
//}
//
//struct FinalStepView: View {
//    @Binding var projectObjective: String
//    var createProject: () -> Void
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Objetivo do Projeto")
//                .font(.title2)
//                .bold()
//            
//            TextEditor(text: $projectObjective)
//                .frame(height: 150)
//                .border(Color.gray, width: 1)
//                .padding()
//            
//            Button("Criar Projeto") {
//                guard !projectObjective.isEmpty else { return }
//                createProject()
//            }
//            .buttonStyle(.borderedProminent)
//            .disabled(projectObjective.isEmpty)
//        }
//        .padding()
//    }
//}
//
//
