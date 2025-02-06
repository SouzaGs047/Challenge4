//import SwiftUI
//import CoreData
//
//struct CardView: View {
//    let ColorItemEntity: ColorItemEntity
//    @ObservedObject var viewModel: ColorViewModel
//    @State private var isDeleted = false
//    @State private var showAlert = false
//    
//    var body: some View {
//        if !isDeleted {
//            VStack(spacing: 8) {
//                Circle()
//                    .fill(Color(hex: ColorItemEntity.hex ?? "#000000") ?? .black)
//                    .frame(width: 50, height: 50)
//                
//                Text(ColorItemEntity.hex ?? "#000000")
//                    .font(.caption)
//                    .foregroundColor(.white)
//            }
//            .padding(.vertical, 8)
//            .contextMenu {
//                Button(role: .destructive) {
//                    showAlert = true
//                } label: {
//                    Label("Excluir", systemImage: "trash")
//                }
//            }
//            .alert(isPresented: $showAlert) {
//                Alert(
//                    title: Text("Excluir cor"),
//                    message: Text("Tem certeza que deseja excluir esta cor?"),
//                    primaryButton: .destructive(Text("Excluir")) {
//                        withAnimation(.easeOut(duration: 0.3)) {
//                            isDeleted = true
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                            viewModel.deleteColor(color: ColorItemEntity)
//                        }
//                    },
//                    secondaryButton: .cancel()
//                )
//            }
//            .opacity(isDeleted ? 0 : 1)
//        }
//    }
//}
//
//struct ColorPickerView: View {
//    @ObservedObject var viewModel: ColorViewModel
//    @State private var selectedColor = Color.blue
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Cores")
//                .font(.title3)
//                .bold()
//                .foregroundColor(.pink)
//            
//            HStack {
//                Spacer()
//                ColorPicker("", selection: $selectedColor)
//                    .labelsHidden()
//                    .frame(width: 40)
//                
//                Button("Adicionar") {
//                    if let hex = selectedColor.toHex() {
//                        withAnimation {
//                            viewModel.addColor(hex: hex)
//                        }
//                    }
//                }
//                .buttonStyle(AddButtonStyle())
//            }
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 15) {
//                    if viewModel.colors.isEmpty {
//                        Text("Nenhuma cor adicionada ainda.")
//                            .foregroundColor(.gray)
//                            .italic()
//                    } else {
//                        ForEach(viewModel.colors, id: \.self) { colorItem in
//                            CardView(ColorItemEntity: colorItem, viewModel: viewModel)
//                        }
//                    }
//                }
//                .padding(.horizontal)
//            }
//        }
//        .padding()
//        .background(Color.black)
//        .cornerRadius(12)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//        )
//    }
//}
//
//struct FontPickerView: View {
//    @ObservedObject var viewModel: FontViewModel
//    @State private var fontName = ""
//    @State private var selectedCategory = "Selecione"
//    
//    let categories = ["Títulos", "Texto Corrido", "Legenda", "Footnote"]
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Texto")
//                .font(.title3)
//                .bold()
//                .foregroundColor(.pink)
//            
//            HStack {
//                TextField("Nome da fonte", text: $fontName)
//                    .textFieldStyle(DarkTextFieldStyle())
//                
//                Picker("Função", selection: $selectedCategory) {
//                    Text("Selecione").tag("Selecione")
//                    ForEach(categories, id: \.self) { category in
//                        Text(category).tag(category)
//                    }
//                }
//                .pickerStyle(MenuPickerStyle())
//                .foregroundColor(.white)
//            }
//            
//            HStack {
//                Spacer()
//                Button("Adicionar") {
//                    if !fontName.isEmpty && selectedCategory != "Selecione" {
//                        viewModel.addFont(nameFont: fontName, category: selectedCategory)
//                        fontName = ""
//                        selectedCategory = "Selecione"
//                    }
//                }
//                .buttonStyle(AddButtonStyle())
//            }
//            
//            LazyVStack(spacing: 12) {
//                ForEach(viewModel.fonts, id: \.self) { font in
//                    HStack {
//                        Text(font.category ?? "")
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text(font.nameFont ?? "")
//                            .foregroundColor(.white)
//                    }
//                    Divider()
//                        .background(Color.gray.opacity(0.3))
//                }
//            }
//        }
//        .padding()
//        .background(Color.black)
//        .cornerRadius(12)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//        )
//    }
//}
//
//struct AddButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .padding(.vertical, 8)
//            .padding(.horizontal, 16)
//            .background(Color(red: 0.8, green: 0, blue: 0.3))
//            .foregroundColor(.white)
//            .cornerRadius(8)
//            .scaleEffect(configuration.isPressed ? 0.95 : 1)
//    }
//}
//
//struct DarkTextFieldStyle: TextFieldStyle {
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        configuration
//            .padding()
//            .background(Color.black)
//            .cornerRadius(8)
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//            )
//            .foregroundColor(.white)
//    }
//}
