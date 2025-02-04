//
//  ColorPickerView.swift
//  TesteColorPicker
//
//  Created by HENRIQUE LEAL PEREIRA DOS SANTOS on 30/01/25.
//import SwiftUI
import SwiftUI
import CoreData

struct ColorPickerView: View {
    @ObservedObject var viewModel: ColorViewModel
    @State private var selectedColor = Color.blue

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Cores")
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.pink)
                    .accessibilityLabel("Título: Cores")
            }
            
            HStack {
                
                Spacer()
                ColorPicker("", selection: $selectedColor)
                    .labelsHidden()
                
                Button("Adicionar") {
                    if let hex = selectedColor.toHex() {
                        withAnimation {
                            viewModel.addColor(hex: hex)
                        }
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
