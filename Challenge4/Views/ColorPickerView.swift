//
//  ColorPickerView.swift
//  TesteColorPicker
//
//  Created by HENRIQUE LEAL PEREIRA DOS SANTOS on 30/01/25.
//
import SwiftUI

struct ColorPickerView: View {
    @ObservedObject var viewModel: ColorViewModel
    @State private var selectedColor = Color.blue
    @State private var colorName = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Cores")
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.pink)
                    .accessibilityLabel("Título: Cores")
                Spacer()
                ColorPicker("Escolha uma cor", selection: $selectedColor)
                    .labelsHidden()
                    .padding(.horizontal, 4)
            }
            HStack(spacing: 30) {
                TextField("Nome da cor", text: $colorName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .accessibilityLabel("Campo de texto para nome da cor")
                
                Button("Adicionar") {
                    if let hex = selectedColor.toHex(), !colorName.isEmpty {
                        withAnimation {
                            viewModel.addColor(name: colorName, hex: hex)
                        }
                        colorName = ""
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color(red: 0.8, green: 0, blue: 0.3))
                .foregroundColor(.white)
                .cornerRadius(8)
                .accessibilityLabel("Botão para adicionar uma nova cor")
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    if viewModel.colors.isEmpty {
                        Text("Nenhuma cor adicionada ainda.")
                            .foregroundColor(.gray)
                            .italic()
                            .accessibilityLabel("Aviso: Nenhuma cor adicionada ainda")
                    } else {
                        ForEach(viewModel.colors, id: \ .self) { ColorItemEntity in
                            if let hex = ColorItemEntity.hex, let _ = Color(hex: hex) {
                                CardView(ColorItemEntity: ColorItemEntity, viewModel: viewModel)
                                    .accessibilityLabel("Cor: \(ColorItemEntity.name ?? "Sem nome") - Código: \(ColorItemEntity.hex ?? "#000000")")
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 5)
        }
        .padding()
    }
}
