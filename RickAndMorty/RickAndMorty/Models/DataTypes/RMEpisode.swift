//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import Foundation

// Extendemos del protocolo
struct RMEpisode: Codable, RMEpisodeDataRender
{
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
