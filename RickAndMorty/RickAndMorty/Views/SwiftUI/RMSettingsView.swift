//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 17/03/23.
//

import SwiftUI

struct RMSettingsView: View {
    let settingsViewViewModel: RMSettingsViewViewModel
    init(viewModel: RMSettingsViewViewModel) {
        self.settingsViewViewModel = viewModel
    }
    
    var body: some View {
        List(settingsViewViewModel.cellViewModels)
        { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30,
                               height: 30)
                        .padding(10)
                        .background(Color(viewModel.iconCantainerColor))
                        .cornerRadius(6)
                        
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
            }
            .padding(5)
        }
    }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(
            viewModel: RMSettingsViewViewModel(
                cellViewModels: RMSettingsOption.allCases.compactMap({
                    return RMSettingsCellViewModel(type: $0)
                })
            )
        )
    }
}
