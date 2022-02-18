//
//  Protocols.swift
//  MarvelMVC
//
//  Created by Abdullah Onur Şimşek on 17.02.2022.
//

import Foundation

protocol cellFavoriteButtonProtocol {
    func buttonPressed(id: Int?, isFavorite: Bool?, index: IndexPath?)
}

protocol ReloadProtocol {
    func reloadCollectionView()
}
