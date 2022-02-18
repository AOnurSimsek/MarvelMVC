//
//  CharactersModel.swift
//  MarvelMVC
//
//  Created by Abdullah Onur Şimşek on 16.02.2022.
//

import Foundation
import ObjectMapper

//MARK: - Main Model
class CharactersModel : Mappable {
    var code: Int?
    var status: String?
    var copyright: String?
    var attributionText: String?
    var attributionHTML: String?
    var etag: String?
    var data: CharactersDataModel?
    
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

//MARK: - Submodels
class CharactersDataModel : Mappable {
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var result: [CharactersResultModel]?
    
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

class CharactersResultModel : Mappable {
    var id: Int?
    var name: String?
    var description: String?
    var modified: String?
    var thumbnail: ThumbnailModel?
    var resourceURI: String?
//    var comics: ComicsModel?
//    var series: SeriesModel?
//    var stories: StoriesModel?
//    var events: EventsModel?
//    var urls: [UrlsModel]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        modified <- map["modified"]
        thumbnail <- map["thumbnail"]
        resourceURI <- map["resourceURI"]
    }
    
}

class ThumbnailModel : Mappable {
    var path: String?
    var `extension`: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        path <- map["path"]
        `extension` <- map["extension"]
    }
    
    func getImageURL() -> URL? {
        let _url = path.getImageUrl(format: `extension`)
        return URL(string: _url)
    }
}

//class ComicsModel : Mappable {
//    var available: Int?
//    var collectionURI:String?
//    var items: [ItemModel]?
//    var returned: Int?
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//    }
//
//}
//
//class ItemModel : Mappable {
//    var resourceURI: String?
//    var name: String?
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//    }
//
//}
//
//class SeriesModel : Mappable {
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//    }
//
//
//}
//
//class StoriesModel : Mappable {
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//    }
//
//}
//
//class EventsModel : Mappable {
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//    }
//
//}
//
//class UrlsModel : Mappable {
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//    }
//
//}
