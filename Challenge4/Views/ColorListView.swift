//
//  ColorListView.swift
//  TesteColorPicker
//
//  Created by HENRIQUE LEAL PEREIRA DOS SANTOS on 30/01/25.
//

import SwiftUI

struct ColorListView: View {
    @ObservedObject var viewModel: ColorViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                if viewModel.colors.isEmpty {
                    Text("Nenhuma cor adicionada ainda.")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(viewModel.colors, id: \.self) { colorItem in
                        if let hex = colorItem.hex, let validColor = Color(hex: hex) {
                            CardView(colorItem: colorItem, viewModel: viewModel)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 5)
    }
}


