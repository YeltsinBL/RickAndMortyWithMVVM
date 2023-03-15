//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 14/03/23.
//

import UIKit

final class RMEpisodeDetailView: UIView {

    private var episodeDetailViewViewModel: RMEpisodeDetailViewViewModel?
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func
    private func setUpConstraints() {
        
    }
    
    
    /// Relacionar los datos del ViewModel con sus respectivos elementos de la vista
    /// - Parameter episodeDetailViewViewModel: ViewModel del detalle del Episodio
    public func configure(with episodeDetailViewViewModel: RMEpisodeDetailViewViewModel) {
        self.episodeDetailViewViewModel = episodeDetailViewViewModel
    }
}
