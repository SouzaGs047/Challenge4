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
                .foregroundStyle(.black)
                .font(.headline)
                .padding(.leading)
                .frame(height: 55)
                .background(.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
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
                    .background(.accent)
                    .background(in: RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
            })
            .padding(.horizontal)
        }
        
        Spacer()
    }
}


#Preview {
    AddProjectView(coreDataVM: ProjectViewModel())
}
