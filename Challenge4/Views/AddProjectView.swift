//
//  AddProjectView.swift
//  Challenge4
//
//  Created by GUSTAVO SOUZA SANTANA on 31/01/25.
//

import SwiftUI

struct AddProjectView: View {
    @ObservedObject var coreDataVM: ProjectViewModel
    @State var nameProjectTextField: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Adicionar Projeto")
                    .font(.title)
                    .bold()
                    .padding(.top)
                    .padding(.leading)
                Spacer()
            }
            
            TextField("Nome do projeto aqui...", text: $nameProjectTextField)
                .foregroundColor(.black)
                .font(.headline)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)
            
            Button(action: {
                guard !nameProjectTextField.isEmpty else { return }
                coreDataVM.addProject(name: nameProjectTextField)
                dismiss()
            }, label: {
                Text("Criar")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            })
            .padding(.horizontal)
            
            Spacer()
        }
        .padding() // Garante que os elementos tenham espaço nas bordas
        .background(Color(UIColor.systemGray6)) // Fundo mais suave para destaque
    }
}



#Preview {
    AddProjectView(coreDataVM: ProjectViewModel())
}
