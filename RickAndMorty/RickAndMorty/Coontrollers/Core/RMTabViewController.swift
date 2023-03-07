//
//  ViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import UIKit

/// Agregamos el final para que no se pueda subclasificar ni hacer herencia
final class RMTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
        setUpTabs()
    }

    private func setUpTabs() {
        let charactersVC = RMCharacterViewController()
        let episodesVC = RMEpisodeViewController()
        let locationsVC = RMLocationViewController()
        let settingsVC = RMSettingsViewController()
        
        ///Agrandar el texto de los Item del Navigation
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        locationsVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        ///Agrupamos los controller en un NavigationController y le agregamos el Titulo
        let navCharacter = UINavigationController(rootViewController: charactersVC)
        let navLocation = UINavigationController(rootViewController: locationsVC)
        let navEpisode = UINavigationController(rootViewController: episodesVC)
        let navSetting = UINavigationController(rootViewController: settingsVC)
        
        ///Agregar imágenes a los Items del Navigation y que se visualicen los items en la vista desde el inicio
        navCharacter.tabBarItem = UITabBarItem(title: "Características",
                                               image: UIImage(systemName: "person"),
                                               tag: 1)
        navLocation.tabBarItem = UITabBarItem(title: "Localización",
                                              image: UIImage(systemName: "globe"),
                                              tag: 2)
        navEpisode.tabBarItem = UITabBarItem(title: "Episodios",
                                             image: UIImage(systemName: "tv"),
                                             tag: 3)
        navSetting.tabBarItem = UITabBarItem(title: "Configuración",
                                             image: UIImage(systemName: "gear"),
                                             tag: 4)
        
        
        ///Agrandar el titulo de los Controllers
        for nav in [navCharacter, navLocation, navEpisode, navSetting] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        ///Adjuntamos los controller en el TabBarController
        setViewControllers([navCharacter, navLocation, navEpisode, navSetting],
                           animated: true)
        
    }

}

