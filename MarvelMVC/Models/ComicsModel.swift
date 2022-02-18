//
//  CharacterDetailModel.swift
//  MarvelMVC
//
//  Created by Abdullah Onur Şimşek on 16.02.2022.
//

import Foundation
import ObjectMapper

//MARK: - Main Model
class ComicsMainModel : Mappable {
    var code: Int?
    var status: String?
    var copyright: String?
    var attributionText: String?
    var attributionHTML: String?
    var etag: String?
    var data: ComicsModel?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        status <- map["status"]
        copyright <- map["copyright"]
        attributionText <- map["attributionText"]
        attributionHTML <- map["attributionHTML"]
        etag <- map["etag"]
        data <- map["data"]
    }
    
}

//MARK: - SubModels
class ComicsModel : Mappable {
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var result: [ComicResultModel]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        offset <- map["offset"]
        limit <- map["limit"]
        total <- map["total"]
        count <- map["count"]
        result <- map["results"]
    }
    
}

class ComicResultModel : Mappable {
    var id: Int?
    var title: String?
    var thumbnail: ThumbnailModel?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        thumbnail <- map["thumbnail"]
    }
    
}




