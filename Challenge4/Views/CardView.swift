//
//  CardView.swift
//  TesteColorPicker
//
//  Created by HENRIQUE LEAL PEREIRA DOS SANTOS on 30/01/25.
//


import SwiftUI

struct CardView: View {
    let ColorItemEntity: ColorItemEntity
    @ObservedObject var viewModel: ColorViewModel
    @State private var isDeleted = false
    @State private var showAlert = false

    var body: some View {
        if !isDeleted {
            VStack {
                Circle()
                    .fill(Color(hex: ColorItemEntity.hex ?? "#000000") ?? .black)
                    .frame(width: 65, height: 65)
                    .background(
                        Circle()
                            .stroke(.linha, lineWidth: 2)
                    )
                
                
                Text(ColorItemEntity.hex ?? "#000000")
                
                    .font(.system(size: 10).bold())
                    .foregroundStyle(.primary)
                    
                
            }.padding(3)
                    
                    .contextMenu {
                        Button(role: .destructive) {
                            showAlert = true
                        } label: {
                            Label("Excluir", systemImage: "trash")
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Excluir cor"),
                            message: Text("Tem certeza que deseja excluir esta cor?"),
                            primaryButton: .destructive(Text("Excluir")) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    isDeleted = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    viewModel.deleteColor(color: ColorItemEntity)
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .opacity(isDeleted ? 0.0 : 1.0)
            }
        }
    }


